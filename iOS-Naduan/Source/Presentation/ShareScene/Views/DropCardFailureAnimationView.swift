//
//  DropCardFailureAnimationView.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

import Lottie

class DropCardFailureAnimationView: UIView {
  private let animationBackgroundView: LottieAnimationView = {
    let view = LottieAnimationView(name: "warning")
    view.backgroundBehavior = .pause
    view.loopMode = .playOnce
    view.contentMode = .scaleAspectFit
    view.animationSpeed = 2.0
    return view
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "공유를 다시 시도해주세요."
    label.font = .pretendardFont(to: .H2B)
    label.textColor = .redError
    label.textAlignment = .center
    return label
  }()
  
  init() {
    super.init(frame: .zero)
    
    self.isHidden = true
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func play() {
    animationBackgroundView.play(toProgress: 0.8)
  }
}

private extension DropCardFailureAnimationView {
  func configureUI() {
    configureHierarchy()
    makeConstraints()
  }
  
  func configureHierarchy() {
    [animationBackgroundView, titleLabel].forEach { addSubview($0) }
  }
  
  func makeConstraints() {
    titleLabel.attach {
      $0.top(equalTo: safeAreaLayoutGuide.topAnchor)
      $0.leading(equalTo: safeAreaLayoutGuide.leadingAnchor)
      $0.trailing(equalTo: safeAreaLayoutGuide.trailingAnchor)
    }
    
    animationBackgroundView.attach {
      $0.leading(equalTo: safeAreaLayoutGuide.leadingAnchor)
      $0.trailing(equalTo: safeAreaLayoutGuide.trailingAnchor)
      $0.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
      $0.height(equalTo: safeAreaLayoutGuide.heightAnchor, multi: 0.5)
    }
  }
}
