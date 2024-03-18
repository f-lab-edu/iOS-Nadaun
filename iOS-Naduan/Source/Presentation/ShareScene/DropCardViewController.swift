//
//  DropCardViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

import Lottie

class DropCardViewController: UIViewController {
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
    animationBackgroundView.play()
  }
}

private extension DropCardViewController {
  func configureUI() {
    view.backgroundColor = .systemBackground
    
    configureHierarchy()
    makeConstraints()
  }
  
  func configureHierarchy() {
    [animationBackgroundView, shareImage].forEach(view.addSubview)
  }
  
  func makeConstraints() {
    animationBackgroundView.attach {
      $0.centerXAnchor.constraint(equalTo: view.centerXAnchor)
      $0.top(equalTo: view.safeAreaLayoutGuide.topAnchor)
      $0.leading(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
      $0.trailing(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
      $0.bottom(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    shareImage.attach {
      $0.centerYAnchor.constraint(equalTo: view.centerYAnchor)
      $0.centerXAnchor.constraint(equalTo: view.centerXAnchor)
      $0.height(equalTo: 250)
    }
  }
}
