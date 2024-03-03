//
//  UserRepository.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import FirebaseAuth
import FirebaseFirestore

class UserRepository {
  private let user: User?
  private let store: Firestore
  
  init(auth: Auth, store: Firestore) {
    self.user = auth.currentUser
    self.store = store
  }
  
  func createUserProfile(
    to profile: UserProfile,
    completion: @escaping (Result<UserProfile, UserProfileError>) -> Void
  ) {
    updateEmail(to: profile.email) { [weak self] result in
      switch result {
        case .success:
          self?.createNewUserProfile(to: profile, completion: completion)
        case .failure(let error):
          completion(.failure(error))
      }
    }
  }
}

private extension UserRepository {
  func updateEmail(to email: String?, completion: @escaping (Result<Void, UserProfileError>) -> Void) {
    guard let email = email, let user = user else {
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
    completion: @escaping (Result<UserProfile, UserProfileError>) -> Void
  ) {
    guard let user = user else {
      completion(.failure(.unExpected))
      return
    }
    
    var updatedProfile = profile
    updatedProfile.updateID(with: user.uid)
    
    do {
      try store.collection("User").document(user.uid).setData(from: updatedProfile)
      completion(.success(updatedProfile))
    } catch {
      completion(.failure(.unExpected))
    }
  }
}
