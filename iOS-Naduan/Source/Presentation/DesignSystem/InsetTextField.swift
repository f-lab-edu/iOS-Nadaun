//
//  InsetTextField.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

class InsetTextField: UITextField {
  private let padding: UIEdgeInsets
  
  init(padding: UIEdgeInsets) {
    self.padding = padding
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    insetTextRect(for: bounds)
  }
  
  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    insetTextRect(for: bounds)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    insetTextRect(for: bounds)
  }
  
  private func insetTextRect(for bounds: CGRect) -> CGRect {
    let inset = bounds.inset(by: padding)
    return inset
  }
}
