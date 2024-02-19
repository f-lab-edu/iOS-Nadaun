//
//  SignUpTextField.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

class SignUpTextField: UITextField {
  enum SignUpFormType: Int {
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
    
    var returnType: UIReturnKeyType {
      switch self {
        case .name:
          return .next
        case .email:
          return .done
        default: return .default
      }
    }
  }
  
  // MARK: - View Properties
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendardFont(to: .B3M)
    label.textColor = .title
    return label
  }()
  
  private let padding: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
  
  // MARK: - Business Logic Properties
  private let formType: SignUpFormType
  
  // MARK: - Initializer
  convenience init(type: SignUpFormType, to title: String? = nil) {
    self.init(formType: type)
    
    tag = type.rawValue
    titleLabel.text = title
    
    configureInitSetting()
  }
  
  init(formType: SignUpFormType) {
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
    returnKeyType = formType.returnType
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
