//
//  UIButton + Extension.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

extension UIButton.Configuration {
  static func authStyle() -> Self {
    var configuration = UIButton.Configuration.filled()
    configuration.imagePlacement = .leading
    configuration.imagePadding = 10
    configuration.titleAlignment = .leading
    configuration.cornerStyle = .capsule
    configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
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
