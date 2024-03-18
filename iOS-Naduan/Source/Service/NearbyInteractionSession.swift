//
//  NearbyInreactionSession.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import Foundation
import NearbyInteraction
import MultipeerConnectivity

enum NearbyInteractionError: Error {
  case notFoundToken
}

class NearbyInteractionSession: NSObject {
  var didReachNear: (() -> Void)?
  var shareMyToken: ((NIDiscoveryToken) -> Void)?
  
  private var nearBySession: NISession
  private var isSendCard: Bool = false
  private var isShareMyToken: Bool = false
  private var connectedPeerToken: NIDiscoveryToken?
  private var connectedPeerID: MCPeerID?
  
  override init() {
    self.nearBySession = NISession()
    super.init()
    nearBySession.delegate = self
  }
  
  func connectToPeer(peer: MCPeerID) throws {
    guard connectedPeerID == nil, let discoveryToken = nearBySession.discoveryToken else {
      throw NearbyInteractionError.notFoundToken
    }
    
    if isShareMyToken == false {
      shareMyToken?(discoveryToken)
    }
    
    connectedPeerID = peer
  }
  
  func disconnectPeer(peer: MCPeerID) {
    if connectedPeerID != peer { return }
    
    isSendCard = false
    isShareMyToken = false
    connectedPeerID = nil
    connectedPeerToken = nil
  }
  
  func didReceivePeerToken(data: Data, peer: MCPeerID) throws {
    guard let token = try NSKeyedUnarchiver.unarchivedObject(ofClass: NIDiscoveryToken.self, from: data),
          connectedPeerID == peer else {
      throw NearbyInteractionError.notFoundToken
    }
    
    connectedPeerToken = token
    let configuration = NINearbyPeerConfiguration(peerToken: token)
    nearBySession.run(configuration)
  }
}

extension NearbyInteractionSession: NISessionDelegate {
  func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
    if isSendCard == true { return }
    
    guard let token = connectedPeerID else { return }
    
    let object = nearbyObjects.first { $0.discoveryToken == token }
    
    if (object?.distance ?? Float.infinity) < 0.05 {
      didReachNear?()
      isSendCard = true
    } 
  }
  
  // 세션이 에러와 함께 종료된다.
  func session(_ session: NISession, didInvalidateWith error: Error) { }
  
  // Session이 더 이상 상호작용하지 않는 경우 세션을 종료할 때 호출된다.
  func session(
    _ session: NISession,
    didRemove nearbyObjects: [NINearbyObject],
    reason: NINearbyObject.RemovalReason
  ) { }
  
  // Session이 시작되면 불리는 메서드
  func sessionDidStartRunning(_ session: NISession) { }
  
  // Session이 종료된 후 불리는 메서드
  func sessionWasSuspended(_ session: NISession) { }
}
