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
  
  func updateUserProfile(
    to profile: UserProfile,
    completion: @escaping (Result<Void, UserProfileError>) -> Void
  ) {
    updateEmail(to: profile.email) { result in
      if case let .failure(error) = result {
        let authError = AuthErrorCode(_nsError: error as NSError)
        
        let userProfileError = UserProfileError(rawValue: authError.errorCode)
        completion(.failure(userProfileError))
      }
    }
  }
  
  func updateBusinessCard(completion: @escaping (Result<Void, Error>) -> Void) {
    
  }
}

private extension UserRepository {
  func updateEmail(to email: String?, completion: @escaping (Result<Void, Error>) -> Void) {
    guard let email = email else {
      completion(.failure(AuthError.unexpected))
      return
    }
    
    user.updateEmail(to: email) { error in
      if let error = error {
        completion(.failure(error))
        return
      }
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
