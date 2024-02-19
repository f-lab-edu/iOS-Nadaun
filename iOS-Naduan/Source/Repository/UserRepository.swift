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
    let profileUpdateGroup = DispatchGroup()
    
    var updateError: Error? = nil
    
    updateEmail(to: profile.email, in: profileUpdateGroup) { result in
      if case let .failure(error) = result {
        updateError = error
      }
    }
    
    uploadProfile(to: profile, in: profileUpdateGroup) { result in
      if case let .failure(error) = result {
        updateError = error
      }
    }
    
    profileUpdateGroup.notify(queue: .global()) {
      if let updateError = updateError {
        completion(.failure(updateError))
        return
      }
      
      completion(.success(()))
    }
  }
  
  func updateBusinessCard(completion: @escaping (Result<Void, Error>) -> Void) {
    
  }
}

private extension UserRepository {
  func updateEmail(to email: String?, in group: DispatchGroup, completion: @escaping (Result<Void, Error>) -> Void) {
    group.enter()
    
    guard let email = email else {
      group.leave()
      completion(.failure(AuthError.unexpected))
      return
    }
    
    user.updateEmail(to: email) { error in
      if let error = error {
        group.leave()
        completion(.failure(error))
        return
      }
      
      group.leave()
      completion(.success(()))
    }
  }
  
  func uploadProfile(to profile: UserProfile, in group: DispatchGroup, completion: @escaping (Result<Void, Error>) -> Void) {
    group.enter()
    
    do {
      try store.collection("User").document(user.uid).setData(from: profile)
      
      group.leave()
      completion(.success(()))
    } catch let error {
      group.leave()
      completion(.failure(error))
    }
  }
}
