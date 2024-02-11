//
//  AuthError.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import Foundation

enum AuthError {
  case credentialMissing
  case IDTokenMissing
  case userMissing
  case unexpected
}

extension AuthError: LocalizedError {
  var failureReason: String? {
    switch self {
      case .credentialMissing:
        return "자격증명을 획득하지 못했습니다."
      case .IDTokenMissing:
        return "토큰을 획득하지 못했습니다."
      case .userMissing:
        return "사용자를 찾지 못했습니다."
      case .unexpected:
        return "예기치 못한 에러가 발생하였습니다."
    }
  }
}
