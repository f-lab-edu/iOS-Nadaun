//
//  UserProfileError.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

enum UserProfileError: Int, Error, CustomStringConvertible {
  case duplicateEmail = 17007
  case invalidEmail = 17008
  case unExpected = -1
  
  init(rawValue: Int) {
    switch rawValue {
      case 17007:
        self = .duplicateEmail
      case 17008:
        self = .invalidEmail
      default:
        self = .unExpected
    }
  }
  
  var description: String {
    switch self {
      case .duplicateEmail:
        return "이미 가입된 계정이 있습니다. 해당 계정으로 로그인해주세요."
      case .invalidEmail:
        return "이메일을 정확하게 입력하였는지 확인해주세요."
      default:
        return "예상치 못한 오류가 발생하였습니다. 잠시 후 다시 시도해주세요."
    }
  }
}
