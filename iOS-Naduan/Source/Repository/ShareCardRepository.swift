//
//  ShareCardRepository.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import FirebaseFirestore
import MultipeerConnectivity
import NearbyInteraction

enum ShareError: Error {
  case notFindReceiveData
}

class ShareCardRepository {
  private let store: CollectionReference
  private let nearBySession: NearbyInteractionSession
  private var multiPeerSession: MultiPeerSession?
  
  init(path: String) {
    self.store = Firestore.firestore().collection(path)
    self.nearBySession = NearbyInteractionSession()
  }
  
  func shareCards(with card: BusinessCard, completion: @escaping ((Result<BusinessCard, Error>) -> Void)) {
    configureNearBySession(with: card)
    
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
    completion: @escaping ((Result<BusinessCard, Error>) -> Void)
  ) -> MultiPeerSession {
    let session = MultiPeerSession(service: "nadaun", identity: "com.share.nadaun", maxPeers: 1)
    
    session.peerConnectedHandler = { [weak self] in
      try? self?.nearBySession.connectToPeer(peer: $0)
    }
    
    session.peerDataHandler = { [weak self] in
      if let card = try? JSONDecoder().decode(BusinessCard.self, from: $0) {
        self?.saveCardDataWithTransaction(to: card, completion: completion)
        return
      }
      
      try? self?.nearBySession.didReceivePeerToken(data: $0, peer: $1)
    }
    
    session.peerDisconnectedHandler = { [weak self] in
      self?.nearBySession.disconnectPeer(peer: $0)
    }
    return session
  }
  
  func configureNearBySession(with card: BusinessCard) {
    nearBySession.didReachNear = { [weak self, card] in
      guard let data = try? JSONEncoder().encode(card) else { return }
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
}

// MARK: FireStore Data Handling Method
private extension ShareCardRepository {
  func saveCardDataWithTransaction(
    to card: BusinessCard,
    completion: @escaping (Result<BusinessCard, Error>) -> Void
  ) {
    let document = store.document(card.cardID)
    let relationCollection = Firestore.firestore().collection("Relation")
    
    Firestore.firestore().runTransaction { (transaction, pointer) -> Any? in
      let document = try? transaction.getDocument(document)
      guard let receivedCard = try? document?.data(as: BusinessCard.self) else {
        pointer?.pointee = NSError(domain: "ReceiveError", code: -1)
        return nil
      }
      
      let relationDocument = relationCollection.document(card.userID)
        .collection(receivedCard.cardID).document()
      
      let _ = try? transaction.setData(from: receivedCard, forDocument: relationDocument)
      
      return receivedCard
    } completion: { receivedCard, error in
      if let error = error {
        completion(.failure(error))
        return
      }
      guard let receivedCard = receivedCard as? BusinessCard else {
        completion(.failure(ShareError.notFindReceiveData))
        return
      }
      
      completion(.success(receivedCard))
    }
  }
}
