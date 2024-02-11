//
//  UINavigationController + Extension.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

extension UINavigationController {
  static let defaultAppearance: UINavigationBarAppearance = {
    let appearance = UINavigationBarAppearance()
    
    appearance.configureWithTransparentBackground()
    appearance.backgroundColor = .systemBackground
    appearance.titleTextAttributes = [
      .font: UIFont.pretendardFont(to: .B1M) as Any,
      .foregroundColor: UIColor.accent
    ]
    appearance.largeTitleTextAttributes = [
      .font: UIFont.pretendardFont(to: .H1B) as Any,
      .foregroundColor: UIColor.accent,
    ]
    
    return appearance
  }()
  
  func setupBarAppearance() {
    navigationBar.standardAppearance = Self.defaultAppearance
    navigationBar.compactAppearance = Self.defaultAppearance
    navigationBar.scrollEdgeAppearance = Self.defaultAppearance
    navigationBar.compactScrollEdgeAppearance = Self.defaultAppearance
    
    navigationBar.isTranslucent = false
    navigationBar.tintColor = .accent
  }
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    
    setupBarAppearance()
  }
}

