//
//  BusinessCardRepository.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import FirebaseFirestore

class BusinessCardRepository {
  typealias CompanyInformation = (company: String?, department: String?, position: String?)
  
  private let profile: UserProfile
  private let collection: CollectionReference
  
  init(profile: UserProfile, path: String = "Card") {
    self.profile = profile
    self.collection = Firestore.firestore().collection(path)
  }
  
  func createNewCard(
    to information: CompanyInformation,
    completion: @escaping (Result<Void, Error>) -> Void
  ) {
    guard let userID = profile.ID else {
      completion(.failure(AuthError.userMissing))
      return
    }
    
    let card = BusinessCard.make(
      profile: profile,
      company: information.company,
      department: information.department,
      position: information.position
    )
    
    do {
      try collection.document(userID).collection(card.name).addDocument(from: card)
      completion(.success(()))
    } catch {
      
    }
  }
}
