//
//  BusinessCardRepository.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import FirebaseAuth

import FirebaseFirestore

class BusinessCardRepository {
  
  private let auth: Auth
  private let store: Firestore
  
  init(auth: Auth = .auth(), store: Firestore = .firestore()) {
    self.auth = auth
    self.store = store
  }
  
  func createNewCard(
    to information: BusinessCard.CompanyInformation,
    completion: @escaping (Result<Void, CardError>) -> Void
  ) {
    guard let userID = auth.currentUser?.uid else {
      completion(.failure(.missingError))
      return
    }
    
    let userReference = store.collection("User").document(userID)
    let cardReference = store.collection("Card").document()
    
    store.runTransaction { [weak self] transaction, pointer in
      guard let self = self else {
        pointer?.pointee = NSError(domain: "Capture Self Error", code: -1)
        return nil
      }
      
      guard let userProfile = try? fetchUserProfile(to: userID, with: transaction) else {
        pointer?.pointee = NSError(domain: "Fetch Profile Error", code: -1)
        return nil
      }
      
      let card = BusinessCard.make(profile: userProfile, information: information)
      let updateFields = ["cardIDs": FieldValue.arrayUnion([cardReference.documentID])]
      
      do {
        try transaction.setData(from: card, forDocument: cardReference)
        transaction.updateData(updateFields, forDocument: userReference)
        return nil
      } catch let error as NSError {
        pointer?.pointee = error
        return nil
      }
    } completion: { object, error in
      guard error == nil else {
        completion(.failure(.failureUpload))
        return
      }
      completion(.success(()))
    }
  }
}

// MARK: Detail Methods
private extension BusinessCardRepository {
  func fetchUserProfile(to userID: String, with transaction: Transaction) throws -> UserProfile {
    let userReference = Firestore.firestore().collection("User").document(userID)
    
    let document = try transaction.getDocument(userReference)
    let userProfile = try document.data(as: UserProfile.self)
    return userProfile
  }
}
