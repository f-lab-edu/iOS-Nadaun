//
//  UIButton + Extension.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

/// Button Configuration Helper Method
extension UIButton.Configuration {
  mutating func setTitle(to title: String, with container: AttributeContainer? = nil) {
    if let container = container {
      attributedTitle = AttributedString(title, attributes: container)
      return
    }
    
    self.title = title
  }
}

/// Daun Button Styling Method
extension UIButton.Configuration {
  enum DaunButtonStyle {
    case basic
    case sub
    case disable
    case custom(_ background: UIColor?, _ foreground: UIColor?)
    
    var backgroundColor: UIColor? {
      switch self {
        case .basic:    return .accent
        case .sub:      return .white
        case .disable:  return .disable
        case .custom(let background, _):
          return background
      }
    }
    
    var foregroundColor: UIColor? {
      switch self {
        case .basic:    return .white
        case .sub:      return .accent
        case .disable:  return .body1
        case .custom(_, let foreground):
          return foreground
      }
    }
  }
  
  static func daunStyle(with style: DaunButtonStyle) -> Self {
    var configuration = Self.filled()
    configuration.titleAlignment = .center
    configuration.baseBackgroundColor = style.backgroundColor
    configuration.baseForegroundColor = style.foregroundColor
    return configuration
  }
}

extension AttributedString {
  static func authTitle(to title: String, with color: UIColor) -> Self {
    var attributes = AttributeContainer()
    attributes.font = UIFont.pretendardFont(to: .H4B)
    attributes.foregroundColor = color
    return AttributedString(title, attributes: attributes)
  }
}
