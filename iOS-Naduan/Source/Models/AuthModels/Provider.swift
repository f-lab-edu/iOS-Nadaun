//
//  Provider.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import Foundation

enum Provider {
  case apple
  case openID(provider: OpenIDProvider)
}

enum OpenIDProvider: String {
  case kakao
  
  var description: String {
    return "oidc.\(self.rawValue)"
  }
}
