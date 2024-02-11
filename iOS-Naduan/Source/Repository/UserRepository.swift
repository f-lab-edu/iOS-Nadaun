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
  
  func updateUserProfile(completion: @escaping (Result<Void, Error>) -> Void) {
    
  }
  
  func updateBusinessCard(completion: @escaping (Result<Void, Error>) -> Void) {
    
  }
}
