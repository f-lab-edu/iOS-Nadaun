//
//  NearByInteractionService.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import Foundation
import MultipeerConnectivity
import NearbyInteraction

struct MPCSessionConstants {
  static let serviceID: String = "nadaun"
  static let keyID: String = "com.share.nadaun"
  static let discoveryID: String = "com.nadaun.discoveryID"
}

class NearByInteractionService: NSObject {
  var didReachHandler: (MCPeerID) -> Void
  var didReceiveNotDecodableData: ((Data) -> Void)?
  private let serviceID: String
  private let session: MCSession
  private let localPeerID: MCPeerID
  private let mcAdvertiser: MCNearbyServiceAdvertiser
  private let mcBrowser: MCNearbyServiceBrowser
  private let identifier: String
  private let maxNumPeers: Int
  private let nearBySession: NISession
  private var connectedTokens: [NIDiscoveryToken: MCPeerID] = [:]
  
  init(
    peerID: String,
    service: String = MPCSessionConstants.serviceID,
    identifier: String = MPCSessionConstants.keyID,
    maxNumPeers: Int = 8,
    didReachHandler: @escaping (MCPeerID) -> Void
  ) {
    self.serviceID = service
    self.identifier = identifier
    let peerID = MCPeerID(displayName: peerID)
    self.localPeerID = peerID
    
    self.session = MCSession(
      peer: peerID,
      securityIdentity: nil,
      encryptionPreference: .required
    )
    self.mcAdvertiser = MCNearbyServiceAdvertiser(
      peer: peerID,
      discoveryInfo: [MPCSessionConstants.discoveryID: identifier],
      serviceType: service
    )
    self.mcBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: service)
    self.maxNumPeers = maxNumPeers
    self.nearBySession = NISession()
    self.didReachHandler = didReachHandler
    
    super.init()
    
    session.delegate = self
    mcAdvertiser.delegate = self
    mcBrowser.delegate = self
    nearBySession.delegate = self
  }
  
  func start() {
    mcAdvertiser.startAdvertisingPeer()
    mcBrowser.startBrowsingForPeers()
  }
  
  func stop() {
    mcAdvertiser.stopAdvertisingPeer()
    mcBrowser.stopBrowsingForPeers()
  }
  
  func invalidate() {
    stop()
    nearBySession.pause()
    nearBySession.invalidate()
  }
  
  func sendData(to peer: MCPeerID, with data: Data) {
    do {
      try session.send(data, toPeers: [peer], with: .reliable)
    } catch let error {
      print("[Error] Send Data to \(peer) with \(error.localizedDescription)")
    }
  }
  
  private func peerConnected(to peer: MCPeerID) {
    guard let discoveryToken = nearBySession.discoveryToken else { return }
    
    if let encodedData = try? NSKeyedArchiver.archivedData(
      withRootObject: discoveryToken,
      requiringSecureCoding: true
    ) {
      sendData(to: peer, with: encodedData)
    }
    
    if session.connectedPeers.count == maxNumPeers {
      stop()
    }
  }
}

extension NearByInteractionService: MCSessionDelegate {
  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    if state == .connected { peerConnected(to: peerID) }
  }
  
  func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    guard let token = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NIDiscoveryToken.self, from: data) else {
      didReceiveNotDecodableData?(data)
      return
    }
    
    let configuration = NINearbyPeerConfiguration(peerToken: token)
    connectedTokens[token] = peerID
    nearBySession.run(configuration)
  }
  
  func session(
    _ session: MCSession,
    didReceive stream: InputStream,
    withName streamName: String,
    fromPeer peerID: MCPeerID
  ) { }
  
  func session(
    _ session: MCSession,
    didStartReceivingResourceWithName resourceName: String,
    fromPeer peerID: MCPeerID,
    with progress: Progress
  ) { }
  
  func session(
    _ session: MCSession,
    didFinishReceivingResourceWithName resourceName: String,
    fromPeer peerID: MCPeerID,
    at localURL: URL?,
    withError error: Error?
  ) { }
}

extension NearByInteractionService: MCNearbyServiceAdvertiserDelegate {
  func advertiser(
    _ advertiser: MCNearbyServiceAdvertiser,
    didReceiveInvitationFromPeer peerID: MCPeerID,
    withContext context: Data?,
    invitationHandler: @escaping (Bool, MCSession?) -> Void
  ) {
    if session.connectedPeers.contains(peerID) == false {
      invitationHandler(true, session)
    }
  }
}

extension NearByInteractionService: MCNearbyServiceBrowserDelegate {
  func browser(
    _ browser: MCNearbyServiceBrowser,
    foundPeer peerID: MCPeerID,
    withDiscoveryInfo info: [String : String]?
  ) {
    guard let identifier = info?[MPCSessionConstants.discoveryID] else { return }
    
    if session.connectedPeers.contains(peerID) { return }
    
    if identifier == self.identifier && session.connectedPeers.count < maxNumPeers {
      browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }
  }
  
  func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    guard let key = connectedTokens.mapValues({ $0 == peerID }).map(\.key).first else { return }
    connectedTokens.removeValue(forKey: key)
    print("LOST PEER \(peerID)")
  }
}

extension NearByInteractionService: NISessionDelegate {
  func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
    let object = nearbyObjects.first { connectedTokens.keys.contains($0.discoveryToken) }
    
    guard let distance = object?.distance, let token = object?.discoveryToken else { return }
    
    if distance < 0.03, let peerID = connectedTokens[token] {
      didReachHandler(peerID)
      connectedTokens[token] = nil
    }
  }
  
  func session(
    _ session: NISession,
    didRemove nearbyObjects: [NINearbyObject],
    reason: NINearbyObject.RemovalReason
  ) {
    guard reason == .timeout else { return }

    let tokens = nearbyObjects.map(\.discoveryToken)
    
    tokens.forEach { connectedTokens.removeValue(forKey: $0) }
    
    if connectedTokens.isEmpty == false, let configuration = session.configuration {
      session.run(configuration)
      return
    }
  }
  
  func session(_ session: NISession, didInvalidateWith error: Error) {
    print(error)
  }
}
