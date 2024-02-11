//
//  Bundle + Extension.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import Foundation

extension Bundle {
  static func KAKAO_KEY() -> String {
    guard let key = Self.main.object(forInfoDictionaryKey: "KAKAO_KEY") as? String else {
      fatalError("KAKAO SDK 키를 입력해주세요.")
    }
    
    return key
  }
}
