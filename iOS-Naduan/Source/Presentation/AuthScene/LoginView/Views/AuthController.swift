//
//  AuthController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import AuthenticationServices

import KakaoSDKUser

protocol AuthControllerDelegate: AnyObject {
  func authController(to controller: AuthController, didSuccess idToken: String)
  func authController(to controller: AuthController, didFailure error: Error)
}

class AuthController {
  weak var delegate: AuthControllerDelegate?
  
  
}
