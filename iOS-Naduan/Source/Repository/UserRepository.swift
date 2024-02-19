//
//  UserRepository.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import FirebaseAuth
import FirebaseFirestore

class UserRepository {
  private let user: User
  private let store: Firestore
  
  init(user: User, store: Firestore) {
    self.user = user
    self.store = store
  }
  
  func updateUserProfile(to profile: UserProfile, completion: @escaping (Result<Void, Error>) -> Void) {
    do {
      try store.collection("User").document(user.uid)
        .setData(from: profile)
      completion(.success(()))
    } catch let error {
      completion(.failure(error))
    }
  }
  
  func updateBusinessCard(completion: @escaping (Result<Void, Error>) -> Void) {
    
  }
}
