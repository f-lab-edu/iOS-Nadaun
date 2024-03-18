//
//  ShareCardRepository.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import FirebaseFirestore
import MultipeerConnectivity
import NearbyInteraction

class ShareCardRepository {
  private let store: CollectionReference
  private let nearBySession: NearbyInteractionSession
  private var multiPeerSession: MultiPeerSession?
  
  init(path: String) {
    self.store = Firestore.firestore().collection(path)
    self.nearBySession = NearbyInteractionSession()
  }
  
  func shareCards(with ID: String, completion: @escaping (BusinessCard?) -> Void) {
    configureNearBySession(with: ID)
    
    if multiPeerSession == nil {
      let session = configureMultiPeerSession(with: 1, completion: completion)
      multiPeerSession = session
      multiPeerSession?.invalidate()
      multiPeerSession?.start()
    }
  }
}

private extension ShareCardRepository {
  func configureMultiPeerSession(
    with max: Int,
    completion: @escaping (BusinessCard?) -> Void
  ) -> MultiPeerSession {
    let session = MultiPeerSession(service: "nadaun", identity: "com.share.nadaun", maxPeers: 1)
    
    session.peerConnectedHandler = { [weak self] in
      try? self?.nearBySession.connectToPeer(peer: $0)
    }
    
    session.peerDataHandler = { [weak self] in
      if let cardID = String(data: $0, encoding: .utf8) {
        print("Peer Data Handler", cardID)
        self?.fetchCard(to: cardID, completion: completion)
        return
      }
      
      try? self?.nearBySession.didReceivePeerToken(data: $0, peer: $1)
    }
    
    session.peerDisconnectedHandler = { [weak self] in
      self?.nearBySession.disconnectPeer(peer: $0)
    }
    return session
  }
  
  func configureNearBySession(with ID: String) {
    nearBySession.didReachNear = { [weak self, ID] in
      guard let data = ID.data(using: .utf8) else { return }
      self?.multiPeerSession?.sendDataToAllPeers(data: data)
    }
    
    nearBySession.shareMyToken = { [weak self] myToken in
      guard let encodedData = try? NSKeyedArchiver.archivedData(
        withRootObject: myToken,
        requiringSecureCoding: true
      ) else { return }
      
      self?.multiPeerSession?.sendDataToAllPeers(data: encodedData)
    }
  
  }
  
  func fetchCard(to ID: String, completion: @escaping (BusinessCard?) -> Void) {
    store.document(ID).getDocument(as: BusinessCard.self) { result in
      switch result {
        case .success(let card):
          completion(card)
        case .failure:
          completion(nil)
      }
    }
  }
}
