//
//  DropCardSuccessView.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

class DropCardSuccessView: UIView {
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendardFont(to: .H2B)
    label.textColor = .accent
    label.text = "상대방의 명함을 확인해보세요."
    return label
  }()
  
  private let cardView: CardView = {
    let cardView = CardView()
    cardView.layer.backgroundColor = UIColor.white.cgColor
    cardView.layer.cornerRadius = 8
    cardView.layer.backgroundColor = UIColor.white.cgColor
    cardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
    cardView.layer.shadowRadius = 8
    cardView.layer.shadowOpacity = 1
    cardView.layer.shadowOffset = CGSize(width: 1, height: 1)
    return cardView
  }()
  
  init() {
    super.init(frame: .zero)
    
    configureUI()
  }
  
  @available(*, unavailable, message: "스토리보드로 생성할 수 없습니다.")
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bind(to card: BusinessCard) {
    isHidden = false
    cardView.bind(to: card)
    
    UIView.animate(withDuration: 1) { [weak self] in
      guard let self = self else { return }
      cardView.transform = CGAffineTransform(translationX: .zero, y: -(frame.height / 2))
    }
  }
  
  private func configureUI() {
    [cardView, titleLabel].forEach(addSubview)
    
    titleLabel.attach {
      $0.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
      $0.top(equalTo: safeAreaLayoutGuide.topAnchor)
    }
    
    cardView.attach {
      $0.leading(equalTo: safeAreaLayoutGuide.leadingAnchor, padding: 32)
      $0.trailing(equalTo: safeAreaLayoutGuide.trailingAnchor, padding: 32)
      $0.centerYAnchor.constraint(equalTo: bottomAnchor)
      $0.height(equalTo: heightAnchor, multi: 0.7)
    }
    
    configureAttributes()
  }
  
  private func configureAttributes() {
    isHidden = true
    backgroundColor = .white
  }
}
