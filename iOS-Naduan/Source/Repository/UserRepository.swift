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
    
    updateEmail(to: profile.email, with: profileUpdateGroup) { result in
      switch result {
        case .success:
          print("UPDATE EMAIL SUCCESS")
        case .failure(let error):
          print("ERROR OCCUR - \(error)")
      }
    }
    
    updateName(to: profile.nickName, with: profileUpdateGroup) { result in
      switch result {
        case .success:
          print("UPDATE USER NAME")
        case .failure(let error):
          print("ERROR OCCUR - \(error)")
      }
    }
    
    profileUpdateGroup.notify(queue: .global()) {
      print(self.user.displayName, self.user.email)
      print("NOTIFY PROFILE UPDATE GROUP")
    }
  }
  
  func updateBusinessCard(completion: @escaping (Result<Void, Error>) -> Void) {
    
  }
}

private extension UserRepository {
  func updateName(to name: String?, with group: DispatchGroup, completion: @escaping (Result<Void, Error>) -> Void) {
    group.enter()
    let changeRequest = user.createProfileChangeRequest()
    changeRequest.displayName = name
    changeRequest.commitChanges { error in
      if let error = error {
        group.leave()
        completion(.failure(AuthError.unexpected))
        return
      }
      
      group.leave()
      completion(.success(()))
    }
  }
  
  func updateEmail(to email: String?, with group: DispatchGroup, completion: @escaping (Result<Void, Error>) -> Void) {
    group.enter()
    
    guard let email = email else {
      group.leave()
      completion(.failure(AuthError.unexpected))
      return
    }
    
    self.user.updateEmail(to: email) { error in
      if let error = error {
        group.leave()
        completion(.failure(error))
        return
      }
      
      group.leave()
      completion(.success(()))
    }
  }
}
