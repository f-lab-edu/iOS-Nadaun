//
//  BusinessCardView.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

class BusinessCardView: UIView {
  private let companyLabel: UILabel = {
    let label = UILabel()
    label.text = "Apple Inc"
    label.font = .pretendardFont(to: .H4B)
    label.textAlignment = .right
    label.textColor = .title
    return label
  }()
  
  private let profileStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .equalSpacing
    stackView.alignment = .fill
    stackView.spacing = 4
    return stackView
  }()
  
  private let contactStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .equalSpacing
    stackView.alignment = .fill
    stackView.spacing = 4
    return stackView
  }()
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendardFont(to: .H4B)
    label.textColor = .title
    return label
  }()
  
  private let positionLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendardFont(to: .B3M)
    label.textColor = .body2
    return label
  }()
  
  private let phoneNumberLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendardFont(weight: .regular, size: 10)
    label.textColor = .title
    return label
  }()
  
  private let emailLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendardFont(weight: .regular, size: 10)
    label.textColor = .title
    return label
  }()
  
  init() {
    super.init(frame: .zero)
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    [companyLabel, profileStackView, contactStackView].forEach(addSubview)
    [nameLabel, positionLabel].forEach(profileStackView.addArrangedSubview)
    [phoneNumberLabel, emailLabel].forEach(contactStackView.addArrangedSubview)
    
    companyLabel.attach {
      $0.top(equalTo: topAnchor, padding: 16)
      $0.leading(equalTo: leadingAnchor, padding: 16)
      $0.trailing(equalTo: trailingAnchor, padding: 16)
    }
    
    profileStackView.attach {
      $0.topAnchor.constraint(greaterThanOrEqualTo: companyLabel.bottomAnchor, constant: 16)
      $0.leading(equalTo: companyLabel.leadingAnchor)
      $0.trailing(equalTo: companyLabel.trailingAnchor)
    }
    
    contactStackView.attach {
      $0.top(equalTo: profileStackView.bottomAnchor, padding: 10)
      $0.leading(equalTo: companyLabel.leadingAnchor)
      $0.trailing(equalTo: companyLabel.trailingAnchor)
      $0.bottom(equalTo: bottomAnchor, padding: 16)
    }
    
    layer.cornerRadius = 8
    layer.backgroundColor = UIColor.white.cgColor
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    layer.applyShadow(color: UIColor.black, alpha: 0.5, x: 2, y: 0, blur: 20)
  }
  
  func updateProfile(
    name: String? = nil,
    phone: String? = nil,
    email: String? = nil,
    position: String? = nil
  ) {
    if let name = name {
      self.nameLabel.setTextWithLineHeight(text: name, lineHeight: 22)
    }
    
    if let phone = phone {
      self.phoneNumberLabel.setTextWithLineHeight(text: phone, lineHeight: 10)
    }
    
    if let email = email {
      self.emailLabel.setTextWithLineHeight(text: email, lineHeight: 10)
    }
    
    if let position = position {
      self.positionLabel.setTextWithLineHeight(text: position, lineHeight: 14)
    }
  }
}

#if DEBUG && canImport(SwiftUI)

import SwiftUI

struct CardView_Previews: PreviewProvider {
  static var previews: some View {
    UIViewPreview {
      let view = BusinessCardView()
      view.layer.applyShadow(color: .black, alpha: 0.2, x: -2, y: 2, blur: 30, spread: .zero)
      return view
    }
    .previewLayout(.sizeThatFits)
    .frame(width: UIScreen.main.bounds.width - 32, height: (UIScreen.main.bounds.width - 32) * 0.6)
    .padding()
    .background(.green)
  }
}

#endif
