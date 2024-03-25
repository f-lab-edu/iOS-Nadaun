//
//  UICardView.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

class CardView: UIView {
  // MARK: - View Properties
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendardFont(to: .H1B)
    label.textColor = .title
    label.numberOfLines = 1
    return label
  }()
  
  private let positionLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendardFont(to: .B3M)
    label.textColor = .body1
    label.numberOfLines = 1
    return label
  }()
  
  private let companyLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendardFont(to: .C2R)
    label.textColor = .body1
    label.numberOfLines = 1
    return label
  }()
  
  private let phoneStackView = generatePrivacyStackView()
  
  private let phoneImage: UIImageView = {
    let imageView = UIImageView(image: .phone)
    return imageView
  }()
  
  private let phoneLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendardFont(to: .C2R)
    label.textColor = .body2
    label.textAlignment = .right
    return label
  }()
  
  private let emailStackView = generatePrivacyStackView()
  
  private let emailImage: UIImageView = {
    let imageView = UIImageView(image: .email)
    return imageView
  }()
  
  private let emailLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendardFont(to: .C2R)
    label.textColor = .body2
    label.textAlignment = .right
    return label
  }()
  
  init() {
    super.init(frame: .zero)
    
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  static func generatePrivacyStackView() -> UIStackView {
    let stackView = UIStackView()
    stackView.alignment = .fill
    stackView.distribution = .equalSpacing
    stackView.spacing = 10
    return stackView
  }
  
  func reset() {
    nameLabel.text = nil
    positionLabel.text = nil
    companyLabel.text = nil
    emailLabel.text = nil
    phoneLabel.text = nil
    phoneStackView.isHidden = true
  }
  
  func bind(to card: BusinessCard) {
    nameLabel.text = card.name
    positionLabel.text = card.position
    companyLabel.text = card.companyDescription
    emailLabel.text = card.email
    
    if let phone = card.phone {
      phoneLabel.text = phone
      phoneStackView.isHidden = false
    }
  }
}
// MARK: - Configure UI Methods
private extension CardView {
  func configureUI() {
    configureHierarchy()
    makeConstraints()
  }
  
  func configureHierarchy() {
    [phoneImage, phoneLabel].forEach(phoneStackView.addArrangedSubview)
    [emailImage, emailLabel].forEach(emailStackView.addArrangedSubview)
    [
      nameLabel, positionLabel, companyLabel,
      phoneStackView, emailStackView
    ].forEach { addSubview($0) }
  }
  
  func makeConstraints() {
    nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    
    nameLabel.attach {
      $0.top(equalTo: topAnchor, padding: 16)
      $0.leading(equalTo: leadingAnchor, padding: 16)
      $0.trailing(equalTo: trailingAnchor, padding: 16)
    }
    
    positionLabel.attach {
      $0.top(equalTo: nameLabel.bottomAnchor, padding: 4)
      $0.leading(equalTo: nameLabel.leadingAnchor)
      $0.trailing(equalTo: trailingAnchor, padding: 16)
    }
    
    companyLabel.attach {
      $0.top(equalTo: positionLabel.bottomAnchor, padding: 4)
      $0.leading(equalTo: positionLabel.leadingAnchor)
      $0.trailing(equalTo: positionLabel.trailingAnchor)
    }
    
    emailStackView.attach {
      $0.leading(equalTo: leadingAnchor, padding: 16)
      $0.trailing(equalTo: trailingAnchor, padding: 16)
      $0.bottom(equalTo: bottomAnchor, padding: 16)
    }
    
    phoneStackView.attach {
      $0.leading(equalTo: leadingAnchor, padding: 16)
      $0.trailing(equalTo: trailingAnchor, padding: 16)
      $0.bottom(equalTo: emailStackView.topAnchor, padding: 10)
    }
  }
}
