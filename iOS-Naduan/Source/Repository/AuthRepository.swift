//
//  AuthRepository.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import FirebaseAuth

class AuthRepository {
  typealias authCompletionHandler = (Result<User, Error>) -> Void
  
  private let auth: Auth
  
  init(auth: Auth = .auth()) {
    self.auth = auth
  }
  
  func signIn(provider: Provider, idToken: String, completion: @escaping authCompletionHandler) {
    switch provider {
      case .apple:
        signInWithApple(with: idToken, completion: completion)
      case .kakao:
        signInWithOpenID(
          to: provider.rawValue,
          with: idToken,
          completion: completion
        )
    }
  }
  
  private func signInWithApple(with idToken: String, completion: @escaping authCompletionHandler) {
    let credential = OAuthProvider.appleCredential(withIDToken: idToken, rawNonce: nil, fullName: nil)
    signIn(credential: credential, completion: completion)
  }
  
  private func signInWithOpenID(
    to providerName: String,
    with idToken: String,
    completion: @escaping authCompletionHandler
  ) {
    let credential = OAuthProvider.credential(withProviderID: providerName, idToken: idToken, rawNonce: nil)
    signIn(credential: credential, completion: completion)
  }
  
  private func signIn(credential: AuthCredential, completion: @escaping authCompletionHandler) {
    auth.signIn(with: credential) { result, error in
      if let error = error {
        completion(.failure(error))
        return
      }
      
      guard let result = result else {
        completion(.failure(AuthError.userMissing))
        return
      }
      
      completion(.success(result.user))
    }
  }
}
