//
//  BusinessCardRepository.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import FirebaseFirestore
import FirebaseFirestoreSwift

class BusinessCardRepository {
  private let profile: UserProfile
  
  init(profile: UserProfile) {
    self.profile = profile
  }
  
  func createNewCard(to card: BusinessCard, completion: @escaping (Result<Void, Error>) -> Void) {
    
  }
}
