//
//  BusinessCardRepository.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import FirebaseAuth

import FirebaseFirestore

class BusinessCardRepository {
  typealias CompanyInformation = (company: String?, department: String?, position: String?)
  
  private let auth: Auth
  private let store: Firestore
  
  init(auth: Auth = .auth(), store: Firestore = .firestore()) {
    self.auth = auth
    self.store = store
  }
  
  func createNewCard(
    to information: CompanyInformation,
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
        pointer?.pointee = NSError(domain: "Weak Self Error", code: -1)
        return nil
      }
      
      do {
        let userProfile = try fetchUserProfile(to: userID, with: transaction)
        try updateBusinessCard(profile: userProfile,
                           information: information,
                           reference: cardReference,
                           with: transaction)
        
        updateCardID(cardID: cardReference.documentID, reference: userReference, transaction: transaction)
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
  
  private func fetchUserProfile(to userID: String, with transaction: Transaction) throws -> UserProfile {
    let userReference = Firestore.firestore().collection("User").document(userID)
    
    let document = try transaction.getDocument(userReference)
    let userProfile = try document.data(as: UserProfile.self)
    return userProfile
  }
  
  private func updateBusinessCard(
    profile: UserProfile,
    information: CompanyInformation,
    reference: DocumentReference,
    with transaction: Transaction
  ) throws {
    let card = BusinessCard.make(
      profile: profile,
      company: information.company,
      department: information.department,
      position: information.position
    )
    
    try transaction.setData(from: card, forDocument: reference)
  }
  
  private func updateCardID(
    cardID: String,
    reference: DocumentReference,
    transaction: Transaction
  ) {
    transaction.updateData(["cardIDs": FieldValue.arrayUnion([cardID])], forDocument: reference)
  }
}
