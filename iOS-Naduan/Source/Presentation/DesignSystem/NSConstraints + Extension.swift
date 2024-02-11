//
//  NSConstraints + Extension.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

@resultBuilder
struct ConstraintBuilder {
  static func buildBlock(_ components: NSLayoutConstraint...) -> [NSLayoutConstraint] {
    return components
  }
}

extension UIView {
  func attach(@ConstraintBuilder build: (UIView) -> [NSLayoutConstraint]) {
    self.translatesAutoresizingMaskIntoConstraints = false
    let constraints = build(self)
    constraints.forEach { $0.isActive = true }
  }
  
  func top(equalTo item: NSLayoutYAxisAnchor, padding: CGFloat = .zero) -> NSLayoutConstraint {
    return topAnchor.constraint(equalTo: item, constant: padding)
  }
  
  func leading(equalTo item: NSLayoutXAxisAnchor, padding: CGFloat = .zero) -> NSLayoutConstraint {
    return leadingAnchor.constraint(equalTo: item, constant: padding)
  }
  
  func bottom(equalTo item: NSLayoutYAxisAnchor, padding: CGFloat = .zero) -> NSLayoutConstraint {
    return bottomAnchor.constraint(equalTo: item, constant: -padding)
  }
  
  func trailing(equalTo item: NSLayoutXAxisAnchor, padding: CGFloat = .zero) -> NSLayoutConstraint {
    return trailingAnchor.constraint(equalTo: item, constant: -padding)
  }
  
  func width(equalTo item: NSLayoutDimension, multi: CGFloat = 1) -> NSLayoutConstraint {
    return widthAnchor.constraint(equalTo: item, multiplier: multi)
  }
  
  func width(equalTo width: CGFloat) -> NSLayoutConstraint {
    return widthAnchor.constraint(equalToConstant: width)
  }
  
  func height(equalTo item: NSLayoutDimension, multi: CGFloat = 1) -> NSLayoutConstraint {
    return heightAnchor.constraint(equalTo: item, multiplier: multi)
  }
  
  func height(equalTo width: CGFloat) -> NSLayoutConstraint {
    return heightAnchor.constraint(equalToConstant: width)
  }
}

