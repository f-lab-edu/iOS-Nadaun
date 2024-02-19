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
  
  var keyBoardType: UIKeyboardType {
    switch self {
      case .name, .position:
        return .default
      case .phone:
        return .numberPad
      case .email:
        return .emailAddress
    }
  }
}

class SignUpTextField: UITextField {
  // MARK: - View Properties
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendardFont(to: .B3M)
    label.textColor = .title
    return label
  }()
  
  private let padding: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
  
  // MARK: - Business Logic Properties
  private let formType: TextFormType
  
  // MARK: - Initializer
  convenience init(
    type: TextFormType,
    to title: String? = nil
  ) {
    self.init(formType: type)
    self.tag = type.rawValue
    self.titleLabel.text = title
    
    configureInitSetting()
  }
  
  init(formType: TextFormType) {
    self.formType = formType
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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

// MARK: - Configure UI Methods
private extension SignUpTextField {
  func configureInitSetting() {
    keyboardType = formType.keyBoardType
    borderStyle = .none
    font = .pretendardFont(to: .B4R)
    textColor = .title
    layer.borderColor = UIColor.accent.cgColor
    layer.borderWidth = 1
    layer.cornerRadius = 4
  }
  
  func configureUI() {
    addSubview(titleLabel)
    
    titleLabel.attach {
      $0.bottom(equalTo: topAnchor, padding: 8)
      $0.leading(equalTo: leadingAnchor)
      $0.trailing(equalTo: trailingAnchor)
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
        to: "이름"
      )
      return view
    }
    .frame(width: 300)
  }
}

#endif
