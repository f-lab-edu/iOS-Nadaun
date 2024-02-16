//
//  SignUpTitleLabel.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

class SignUpTitleLabel: UILabel {
  init() {
    super.init(frame: .zero)
    
    font = .pretendardFont(to: .B1M)
    textColor = .accent
    numberOfLines = .zero
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
