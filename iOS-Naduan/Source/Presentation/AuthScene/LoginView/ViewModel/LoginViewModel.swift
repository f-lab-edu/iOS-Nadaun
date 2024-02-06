//
//  LoginViewModel.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import FirebaseAuth

enum LoginAction {
  case appleLogin(idToken: String)
  case kakaoLogin(idToken: String)
}

class LoginViewModel {
  private let authRepository: AuthRepository
  
  private var currentUser: User?
  
  init(authRepository: AuthRepository) {
    self.authRepository = authRepository
  }
  
  func bind(with action: LoginAction) {
    switch action {
      case .appleLogin(let idToken):
        print(idToken)
      case .kakaoLogin(let idToken):
        print(idToken)
    }
  }
}
