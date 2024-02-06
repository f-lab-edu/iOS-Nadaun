//
//  LoginViewModel.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import FirebaseAuth

enum LoginAction {
  case signIn(provider: Provider, idToken: String)
}

class LoginViewModel {
  private let authRepository: AuthRepository
  
  private var currentUser: User?
  
  init(authRepository: AuthRepository) {
    self.authRepository = authRepository
  }
  
  func bind(with action: LoginAction) {
    switch action {
      case .signIn(let provider, let idToken):
        authRepository.signIn(provider: provider, idToken: idToken, completion: handleSignInResult)
    }
  }
}

private extension LoginViewModel {
  func handleSignInResult(to result: Result<User, Error>) {
    switch result {
      case .success(let user):
        self.currentUser = user
      case .failure(let error):
        print(error)
    }
  }
}
