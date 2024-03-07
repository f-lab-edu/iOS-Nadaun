//
//  MyCardCollectionViewCell.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

class MyCardCollectionViewCell: UICollectionViewCell {
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendardFont(to: .H1B)
    label.textColor = .title
    label.numberOfLines = 1
    label.text = "이경민"
    return label
  }()
  
  private let shareButton: UIButton = {
    var configuration = UIButton.Configuration.plain()
    configuration.image = .share
    configuration.contentInsets = .zero
    return UIButton(configuration: configuration)
  }()
  
  private let positionLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendardFont(to: .B3M)
    label.text = "iOS 개발자"
    label.textColor = .body1
    label.numberOfLines = 1
    return label
  }()
  
  private let companyLabel: UILabel = {
    let label = UILabel()
    label.text = "Naver"
    label.font = .pretendardFont(to: .C2R)
    label.textColor = .body1
    label.numberOfLines = 1
    return label
  }()
  
  private let phoneStackView = generatePrivacyStackView()
  
  private let phoneImage: UIImageView = {
    let imageView = UIImageView(image: UIImage(systemName: "iphone.gen1"))
    return imageView
  }()
  
  private let phoneLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendardFont(to: .C2R)
    label.text = "010-1234-1234"
    label.textColor = .body2
    label.textAlignment = .right
    return label
  }()
  
  func configure(with number: Int) {
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    layer.cornerRadius = 8
    layer.backgroundColor = UIColor.white.cgColor
    layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
    layer.shadowRadius = 2
    layer.shadowOpacity = 1
    layer.shadowOffset = CGSize(width: -1, height: 1)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    configureUI()
  }
  
  private static func generatePrivacyStackView() -> UIStackView {
    let stackView = UIStackView()
    stackView.alignment = .fill
    stackView.distribution = .fillProportionally
    stackView.spacing = 10
    return stackView
  }
}

private extension MyCardCollectionViewCell {
  func configureUI() {
    configureHierarchy()
    makeConstraints()
  }
  
  func configureHierarchy() {
    [phoneImage, phoneLabel].forEach(phoneStackView.addArrangedSubview)
    [
      nameLabel, shareButton, positionLabel, companyLabel,
      phoneStackView
    ].forEach {
      contentView.addSubview($0)
    }
  }
  
  func makeConstraints() {
    nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    shareButton.setContentCompressionResistancePriority(.required, for: .horizontal)
    
    nameLabel.attach {
      $0.top(equalTo: contentView.topAnchor, padding: 16)
      $0.leading(equalTo: contentView.leadingAnchor, padding: 16)
    }
    
    shareButton.attach {
      $0.leading(equalTo: nameLabel.trailingAnchor, padding: 4)
      $0.top(equalTo: contentView.topAnchor, padding: 16)
      $0.trailing(equalTo: contentView.trailingAnchor, padding: 16)
      $0.bottom(equalTo: nameLabel.bottomAnchor)
      $0.width(equalTo: 24)
    }
    
    positionLabel.attach {
      $0.top(equalTo: nameLabel.bottomAnchor, padding: 4)
      $0.leading(equalTo: nameLabel.leadingAnchor)
      $0.trailing(equalTo: contentView.trailingAnchor, padding: 16)
    }
    
    companyLabel.attach {
      $0.top(equalTo: positionLabel.bottomAnchor, padding: 4)
      $0.leading(equalTo: positionLabel.leadingAnchor)
      $0.trailing(equalTo: positionLabel.trailingAnchor)
    }
    
    phoneStackView.attach {
      $0.leading(equalTo: contentView.leadingAnchor, padding: 16)
      $0.trailing(equalTo: contentView.trailingAnchor, padding: 16)
      $0.bottom(equalTo: contentView.bottomAnchor, padding: 16)
    }
  }
}
