//
//  SignUpTextField.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

enum TextFormType: Int {
  case name
  case phone
  case email
  case position
  
  var errorDescription: String {
    switch self {
      case .name, .position:
        return ""
      case .phone:
        return "올바른 번호를 입력해주세요."
      case .email:
        return "올바른 이메일을 입력해주세요."
    }
  }
}

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
    type: TextFormType,
    to placeholder: String? = nil,
    with errorMessage: String? = nil
  ) {
    self.init()
    self.tag = type.rawValue
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
  func updateExplanationLabel(isError: Bool, to formType: TextFormType) {
    if isError {
      explanationLabel.text = formType.errorDescription
      explanationLabel.textColor = .redError
      layer.borderColor = UIColor.redError.cgColor
      return
    }
    
    explanationLabel.text = nil
    layer.borderColor = UIColor.accent.cgColor
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
        type: .name,
        to: "이름",
        with: "잘못된 입력입니다."
      )
      return view
    }
    .frame(maxWidth: .infinity)
  }
}

#endif
