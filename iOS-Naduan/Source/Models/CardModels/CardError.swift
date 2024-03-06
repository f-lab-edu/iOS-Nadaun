//
//  BusinessCardError.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import Foundation

enum CardError: Error, CustomStringConvertible {
  case missingError
  case notConvertCard
  case failureUpload
  
  var description: String {
    switch self {
      case .notConvertCard:
        return "잘못된 입력이 포함되어 있습니다. 모든 입력이 정확한지 확인해주세요."
      case .missingError, .failureUpload:
        return "예기치 못한 오류가 발생하였습니다. 잠시후 다시 시도해주세요."
    }
  }
}
