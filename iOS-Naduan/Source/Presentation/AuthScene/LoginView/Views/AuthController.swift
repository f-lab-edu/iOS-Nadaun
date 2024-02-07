//
//  AuthController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import AuthenticationServices

import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon

protocol AuthControllerDelegate: AnyObject {
  func authController(to controller: AuthController, didSuccess idToken: String, withProvider provider: Provider)
  func authController(to controller: AuthController, didFailure error: LocalizedError)
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
      if case let .ClientFailed(reason, _) = (error as? SdkError), reason == .Cancelled { return }
      
      delegate?.authController(to: self, didFailure: AuthError.unexpected)
      return
    }
    
    guard let idToken = token?.idToken else {
      delegate?.authController(to: self, didFailure: AuthError.IDTokenMissing)
      return
    }
    
    delegate?.authController(to: self, didSuccess: idToken, withProvider: .kakao)
  }
}

extension AuthController: ASAuthorizationControllerDelegate {
  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithError error: Error
  ) {
    if (error as? ASAuthorizationError)?.code == .canceled { return }
    
    delegate?.authController(to: self, didFailure: AuthError.unexpected)
  }
  
  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
      delegate?.authController(to: self, didFailure: AuthError.credentialMissing)
      return
    }
    
    guard let idTokenData = credential.identityToken,
          let idToken = String(data: idTokenData, encoding: .utf8) else {
      delegate?.authController(to: self, didFailure: AuthError.IDTokenMissing)
      return
    }
    
    delegate?.authController(to: self, didSuccess: idToken, withProvider: .apple)
  }
}
