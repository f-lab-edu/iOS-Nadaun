//
//  UINavigationController + Extension.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

extension UINavigationController {
  func setupBarAppearance() {
    let appearance = UINavigationBarAppearance()
    
    appearance.configureWithTransparentBackground()
    appearance.backgroundColor = .systemBackground
    appearance.titleTextAttributes = [
      .font: UIFont.pretendardFont(to: .B1M) as Any,
      .foregroundColor: UIColor.accent
    ]
    appearance.largeTitleTextAttributes = [
      .font: UIFont.pretendardFont(to: .H1B) as Any,
      .foregroundColor: UIColor.accent
    ]
    
    navigationBar.standardAppearance = appearance
    navigationBar.compactAppearance = appearance
    navigationBar.scrollEdgeAppearance = appearance
    navigationBar.compactScrollEdgeAppearance = appearance
  }
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    
    setupBarAppearance()
  }
}

