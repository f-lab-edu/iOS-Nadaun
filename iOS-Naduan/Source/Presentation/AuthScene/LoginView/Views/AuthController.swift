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

class AuthController {
  weak var delegate: AuthControllerDelegate?
  
  func authWithKakao() {
    if UserApi.isKakaoTalkLoginAvailable() {
      UserApi.shared.loginWithKakaoTalk(completion: handleKakaoToken)
    } else {
      UserApi.shared.loginWithKakaoAccount(completion: handleKakaoToken)
    }
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
