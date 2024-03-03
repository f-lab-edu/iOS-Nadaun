//
//  SplashViewModel.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import FirebaseAuth

enum SplashAction {
  case checkAuthState
}

class SplashViewModel {
  private let authRepository: AuthRepository
  private var currentUser: FirebaseAuth.User? {
    didSet {
      currentUserChange?(currentUser)
    }
  }
  
  var currentUserChange: ((User?) -> Void)?
  
  init(authRepository: AuthRepository) {
    self.authRepository = authRepository
  }
  
  func bind(to action: SplashAction) {
    switch action {
      case .checkAuthState:
        self.currentUser = authRepository.checkAuthUser()
    }
  }
}
