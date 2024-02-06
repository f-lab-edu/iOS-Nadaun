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
        signInWithKakao(to: idToken)
    }
  }
}

private extension LoginViewModel {
  func signInWithKakao(to idToken: String) {
    authRepository.signIn(provider: .kakao, idToken: idToken) { result in
      switch result {
        case .success(let user):
          self.currentUser = user
        case .failure(let error):
          print(error)
      }
    }
  }
}
