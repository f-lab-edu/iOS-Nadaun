//
//  SignUpTextField.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

class SignUpTextField: UITextField {
  // MARK: - View Properties
  private let explanationLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendardFont(weight: .regular, size: 8)
    label.textColor = .disable
    return label
  }()
  
  private let padding: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
  
  // MARK: - Business Logic Properties
  private var errorMessage: String?
  
  // MARK: - Initializer
  convenience init(
    to placeholder: String? = nil,
    with errorMessage: String? = nil
  ) {
    self.init()
    self.placeholder = placeholder
    self.errorMessage = errorMessage
    
    configureInitSetting()
  }
  
  // MARK: - Life Cycle Methods
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    configureUI()
  }
}

// MARK: - Update UI Methods
extension SignUpTextField {
  func updateErrorMessage(to errorDescription: String, with color: UIColor? = .redError) {
    self.explanationLabel.text = errorDescription
    self.explanationLabel.textColor = color
  }
}

// MARK: - Configure UI Methods
private extension SignUpTextField {
  func configureInitSetting() {
    borderStyle = .none
    font = .pretendardFont(to: .C2R)
    textColor = .accent
    layer.borderColor = UIColor.disable.cgColor
    layer.borderWidth = 1
    explanationLabel.text = errorMessage
  }
  
  func configureUI() {
    addSubview(explanationLabel)
    
    explanationLabel.attach {
      $0.top(equalTo: bottomAnchor, padding: 4)
      $0.leading(equalTo: leadingAnchor)
      $0.trailing(equalTo: trailingAnchor)
      $0.height(equalTo: heightAnchor, multi: 0.3)
    }
    
    setNeedsUpdateConstraints()
  }
}

#if DEBUG

import SwiftUI

struct SignUpTextField_Previews: PreviewProvider {
  static var previews: some View {
    UIViewPreview {
      let view = SignUpTextField(
        to: "이름",
        with: "잘못된 입력입니다."
      )
      return view
    }
    .frame(maxWidth: .infinity)
  }
}

#endif
