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
  private let store: Firestore
  //  private let nearBySession: NearbyInteractionSession
  private var multiPeerSession: NearByInteractionService?
  
  init() {
    self.store = Firestore.firestore()
  }
  
  func shareCards(with card: BusinessCard, completion: @escaping ((Result<BusinessCard, Error>) -> Void)) {
    let session = NearByInteractionService(peerID: card.name) { [weak self, card] peerID in
      guard let cardData = try? JSONEncoder().encode(card) else { return }
      self?.multiPeerSession?.sendData(to: peerID, with: cardData)
    }
    
    session.didReceiveNotDecodableData = { [weak self] data in
      guard let receivedCard = try? JSONDecoder().decode(BusinessCard.self, from: data) else {
        completion(.failure(ShareError.notFindReceiveData))
        return
      }
      
      self?.saveCardData(sendCard: card, receivedCard: receivedCard, completion: completion)
    }
    
    self.multiPeerSession = session
    session.start()
  }
}

private extension ShareCardRepository {
  func saveCardData(
    sendCard: BusinessCard,
    receivedCard: BusinessCard,
    completion: @escaping (Result<BusinessCard, Error>) -> Void
  ) {
    try? store.collection("Relation").document(sendCard.userID)
      .collection(receivedCard.cardID)
      .document().setData(from: receivedCard) { error in
        if error != nil {
          completion(.failure(ShareError.notFindReceiveData))
          return
        }
        
        completion(.success(receivedCard))
      }
  }
}
