//
//  MyCardCollectionViewCell.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

// MARK: MyCardCollectionViewCell Delegate
protocol MyCardCollectionViewCellDelegate: AnyObject {
  func myCardCollectionViewCell(_ cell: MyCardCollectionViewCell, didSelectShare card: BusinessCard)
}

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

// MARK: MyCardCollectionViewCell
class MyCardCollectionViewCell: UICollectionViewCell {
  // MARK: - View Properties
  private let cardView = CardView()
  
  weak var delegate: MyCardCollectionViewCellDelegate?
  
  // MARK: - Initializer
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    cardView.reset()
  }
  
  // MARK: - Binding Method
  func bind(with card: BusinessCard) {
    cardView.bind(to: card)
  }
}

private extension MyCardCollectionViewCell {
  func configureUI() {
    configureAttributes()
    configureHierarchy()
    makeConstraints()
  }
  
  func configureAttributes() {
    layer.cornerRadius = 8
    layer.backgroundColor = UIColor.white.cgColor
    layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
    layer.shadowRadius = 8
    layer.shadowOpacity = 1
    layer.shadowOffset = CGSize(width: 1, height: 1)
    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
  }
  
  func configureHierarchy() {
    contentView.addSubview(cardView)
  }
  
  func makeConstraints() {
    cardView.attach {
      $0.top(equalTo: contentView.topAnchor)
      $0.leading(equalTo: contentView.leadingAnchor)
      $0.trailing(equalTo: contentView.trailingAnchor)
      $0.bottom(equalTo: contentView.bottomAnchor)
    }
  }
}

private extension MyCardCollectionViewCell {
  enum Constants {
    static let shareActionID = UIAction.Identifier("SHARE")
  }
}
