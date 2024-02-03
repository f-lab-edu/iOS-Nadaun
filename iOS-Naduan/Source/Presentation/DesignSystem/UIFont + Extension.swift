//
//  UIFont + Extension.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

enum TypographyType {
  enum FontSize: Int {
    case extraLarge = 22
    case large = 20
    case medium = 18
    case small = 16
    case extraSmall = 14
  }

  enum FontWeight: String {
    case bold = "Bold"
    case medium = "Medium"
    case regular = "Regular"
  }
  
  case H1B
  case H2B
  case H3B
  case H4B
  case H5B
  
  case B1M
  case B2M
  case B3M
  case B4R
  
  case C1M
  case C2R
  
  var size: FontSize {
    switch self {
      case .H1B:                          return .extraLarge
      case .H2B:                          return .large
      case .H3B, .B1M:                    return .medium
      case .H4B, .B2M:                    return .small
      case .H5B, .B3M, .B4R, .C1M, .C2R:  return .extraSmall
    }
  }
  
  var weight: FontWeight {
    switch self {
      case .H1B, .H2B, .H3B, .H4B, .H5B: return .bold
      case .B1M, .B2M, .B3M, .C1M:       return .medium
      case .B4R, .C2R:                   return .regular
    }
  }
}

extension UIFont {
  private static let pretendard = "Pretendard"
  
  static func pretendardFont(weight: TypographyType.FontWeight, size: CGFloat) -> UIFont {
    let name = pretendard + "-" + weight.rawValue
    return UIFont(name: name, size: size) ?? .preferredFont(forTextStyle: .body)
  }
  
  static func pretendardFont(to typography: TypographyType) -> UIFont {
    let name = pretendard + "-" + typography.weight.rawValue
    let size = CGFloat(typography.size.rawValue)
    return UIFont(name: name, size: size) ?? .preferredFont(forTextStyle: .body)
  }
}
