//
//  DropCardShareView.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

import Lottie

class DropCardShareAnimationView: UIView {
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendardFont(to: .H2B)
    label.textColor = .accent
    label.text = "핸드폰 뒷면을 마주쳐보세요."
    return label
  }()
  
  private let animationBackgroundView: LottieAnimationView = {
    let view = LottieAnimationView(name: "drop")
    view.backgroundBehavior = .continuePlaying
    view.loopMode = .loop
    view.animationSpeed = 0.5
    return view
  }()
  
  private let shareImage: UIImageView = {
    let imageView = UIImageView(image: .handShake)
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let explanationLabel: Label = {
    let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let label = Label(padding: padding)
    label.numberOfLines = .zero
    label.textColor = .disable
    label.font = .pretendardFont(to: .C1R)
    label.layer.cornerRadius = 8
    label.layer.backgroundColor = UIColor.gray02.cgColor
    label.text = TextConstants.shareExplanation
    return label
  }()
  
  init() {
    super.init(frame: .zero)
    
    configureUI()
    animationBackgroundView.play()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension DropCardShareAnimationView {
  func configureUI() {
    configureHierarchy()
    makeConstraints()
  }
  
  func configureHierarchy() {
    [titleLabel, animationBackgroundView, shareImage, explanationLabel]
      .forEach { addSubview($0) }
  }
  
  func makeConstraints() {
    titleLabel.attach {
      $0.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
      $0.top(equalTo: safeAreaLayoutGuide.topAnchor)
    }
    
    animationBackgroundView.attach {
      $0.top(equalTo: safeAreaLayoutGuide.topAnchor)
      $0.leading(equalTo: safeAreaLayoutGuide.leadingAnchor)
      $0.trailing(equalTo: safeAreaLayoutGuide.trailingAnchor)
      $0.bottom(equalTo: safeAreaLayoutGuide.bottomAnchor)
    }
    
    shareImage.attach {
      $0.leading(equalTo: animationBackgroundView.leadingAnchor)
      $0.trailing(equalTo: animationBackgroundView.trailingAnchor)
      $0.centerYAnchor.constraint(equalTo: animationBackgroundView.centerYAnchor)
      $0.height(equalTo: 250)
    }
    
    explanationLabel.attach {
      $0.leading(equalTo: safeAreaLayoutGuide.leadingAnchor, padding: 24)
      $0.trailing(equalTo: safeAreaLayoutGuide.trailingAnchor, padding: 24)
      $0.bottom(equalTo: safeAreaLayoutGuide.bottomAnchor)
    }
  }
}

private extension DropCardShareAnimationView {
  enum TextConstants {
    static let shareExplanation: String = """
    해당 기능은 UWB 기능을 지원하는 기기에서만 가능합니다. 지원되지 않는 기기는 QR 코드 화면이 나옵니다. 두 기기 모두 화면에 머물러야 공유가 가능합니다.
    
    지원 기기 : iPhone 11 이후 모델 (SE 기종 제외)
    """
  }
}
