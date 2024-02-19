//
//  UserRepository.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import FirebaseAuth
import FirebaseFirestore

class UserRepository {
  private let store: Firestore
  
  init(store: Firestore) {
//    self.user = user
    self.store = store
  }
  
  func updateUserProfile(to profile: UserProfile, completion: @escaping (Result<Void, Error>) -> Void) {
    do {
      try store.collection("User").document()
        .setData(from: profile)
      completion(.success(()))
    } catch let error {
      completion(.failure(error))
    }
  }
  
  func updateBusinessCard(completion: @escaping (Result<Void, Error>) -> Void) {
    
  }
}
