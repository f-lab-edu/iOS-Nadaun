//
//  AuthController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import AuthenticationServices

import KakaoSDKUser
import KakaoSDKAuth

protocol AuthControllerDelegate: AnyObject {
  func authController(to controller: AuthController, didSuccess idToken: String)
  func authController(to controller: AuthController, didFailure error: Error)
}

class AuthController: NSObject {
  weak var delegate: AuthControllerDelegate?
  
  func authWithKakao() {
    if UserApi.isKakaoTalkLoginAvailable() {
      UserApi.shared.loginWithKakaoTalk(completion: handleKakaoToken)
    } else {
      UserApi.shared.loginWithKakaoAccount(completion: handleKakaoToken)
    }
  }
  
  func authWithApple() {
    let provider = ASAuthorizationAppleIDProvider()
    let request = provider.createRequest()
    
    let controller = ASAuthorizationController(authorizationRequests: [request])
    controller.delegate = self
    controller.performRequests()
  }
  
  private func handleKakaoToken(_ token: OAuthToken?, _ error: Error?) {
    if let error = error {
      delegate?.authController(to: self, didFailure: error)
      return
    }
    
    guard let idToken = token?.idToken else {
      delegate?.authController(to: self, didFailure: AuthError.didNotFoundIDToken)
      return
    }
    
    delegate?.authController(to: self, didSuccess: idToken)
  }
}

extension AuthController: ASAuthorizationControllerDelegate {
  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithError error: Error
  ) {
    delegate?.authController(to: self, didFailure: error)
  }
  
  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
      delegate?.authController(to: self, didFailure: AuthError.didNotFoundCredential)
      return
    }
    
    guard let idTokenData = credential.identityToken,
          let idToken = String(data: idTokenData, encoding: .utf8) else {
      delegate?.authController(to: self, didFailure: AuthError.didNotFoundIDToken)
      return
    }
    
    delegate?.authController(to: self, didSuccess: idToken)
  }
}
