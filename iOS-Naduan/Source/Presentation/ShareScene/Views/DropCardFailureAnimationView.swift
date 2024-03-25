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
  
//  private let explanationLabel: Label = {
//    let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//    let label = Label(padding: padding)
//    label.numberOfLines = .zero
//    label.textColor = .disable
//    label.font = .pretendardFont(to: .C1R)
//    label.layer.cornerRadius = 8
//    label.layer.backgroundColor = UIColor.gray02.cgColor
//    label.text = TextConstants.shareExplanation
//    return label
//  }()
  
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
    [animationBackgroundView]
      .forEach { addSubview($0) }
  }
  
  func makeConstraints() {
    animationBackgroundView.attach {
      $0.leading(equalTo: safeAreaLayoutGuide.leadingAnchor)
      $0.trailing(equalTo: safeAreaLayoutGuide.trailingAnchor)
      $0.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
      $0.height(equalTo: safeAreaLayoutGuide.heightAnchor, multi: 0.5)
    }
  }
}
