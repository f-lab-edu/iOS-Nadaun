//
//  AuthError.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import Foundation

enum AuthError: Error, LocalizedError {
  case didNotFoundCredential
  case didNotFoundIDToken
  case didNotFoundUser
  case unexpected
  
  var failureReason: String? {
    return "예기치 못한 에러가 발생하였습니다."
  }
  
  var recoverySuggestion: String? {
    return "잠시후 다시 시도해주세요."
  }
  
  var errorDescription: String? {
    return (failureReason ?? "") + "\n" + (recoverySuggestion ?? "")
  }
}
