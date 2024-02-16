//
//  CALayer + Extension.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

extension CALayer {
  func applyShadow(
    color: UIColor,
    alpha: Float,
    x: CGFloat,
    y: CGFloat,
    blur: CGFloat,
    spread: CGFloat = .zero
  ) {
    masksToBounds = false
    shadowColor = color.cgColor
    shadowOpacity = alpha
    shadowOffset = CGSize(width: x, height: y)
    shadowRadius = blur / UIScreen.main.scale
    shadowPath = UIBezierPath(rect: bounds).cgPath
    
    if spread != .zero {
      let rect = bounds.insetBy(dx: -spread, dy: -spread)
      shadowPath = UIBezierPath(rect: rect).cgPath
    }
  }
}
