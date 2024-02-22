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
  
  func createUserProfile(
    to profile: UserProfile,
    completion: @escaping (Result<Void, UserProfileError>) -> Void
  ) {
    updateEmail(to: profile.email) { [weak self] result in
      if case .success = result {
        self?.createNewUserProfile(to: profile, completion: completion)
        return
      }
      completion(result)
    }
  }
}

private extension UserRepository {
  func updateEmail(to email: String?, completion: @escaping (Result<Void, UserProfileError>) -> Void) {
    guard let email = email else {
      completion(.failure(.unExpected))
      return
    }
    
    user.updateEmail(to: email) { error in
      if let error = error as? NSError {
        let authError = AuthErrorCode(_nsError: error as NSError)
        
        let userProfileError = UserProfileError(rawValue: authError.errorCode)
        completion(.failure(userProfileError))
        return
      }
      
      completion(.success(()))
    }
  }
  
  func createNewUserProfile(
    to profile: UserProfile,
    completion: @escaping (Result<Void, UserProfileError>) -> Void
  ) {
    do {
      try store.collection("User").document(user.uid).setData(from: profile)
      completion(.success(()))
    } catch {
      completion(.failure(.unExpected))
    }
  }
}
