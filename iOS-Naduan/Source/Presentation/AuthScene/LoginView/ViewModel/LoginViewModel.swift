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
  
  private var currentUser: User? {
    didSet {
      didChangeUserSession(user: currentUser)
    }
  }
  
  private var error: Error? {
    didSet {
      if let error = self.error {
        didOccurError?(error)
      }
    }
  }
  
  var didNotRegister: ((User) -> Void)?
  var didRegister: ((User) -> Void)?
  var didOccurError: ((Error) -> Void)?
  
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
  func didChangeUserSession(user: User?) {
    guard let user = user else {
      self.error = AuthError.didNotFoundUser
      return
    }
    
    if user.email == nil || user.phoneNumber == nil || user.displayName == nil {
      didNotRegister?(user)
      return
    }
    
    didRegister?(user)
  }
  
  func handleSignInResult(to result: Result<User, Error>) {
    switch result {
      case .success(let user):
        self.currentUser = user
      case .failure(let error):
        self.error = error
    }
  }
}
