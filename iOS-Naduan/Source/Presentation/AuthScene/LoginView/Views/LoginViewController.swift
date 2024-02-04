//
//  LoginViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

final class LoginViewController: UIViewController {
  private let rectangleView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.accent
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let logoLabel: UILabel = {
    let label = UILabel()
    label.text = "똑똑하고\n나다운\n명함"
    label.font = .pretendardFont(weight: .bold, size: 48)
    label.textColor = .accent
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let kakaoAuthButton: UIButton = {
    var configuration = UIButton.Configuration.authStyle()
    configuration.image = .iconKakao
    configuration.baseBackgroundColor = .colorKakao
    configuration.attributedTitle = .authTitle(to: "카카오로 계속하기", with: .black)
    let button = UIButton(configuration: configuration)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  private let appleAuthButton: UIButton = {
    var configuration = UIButton.Configuration.authStyle()
    configuration.image = .iconApple
    configuration.baseBackgroundColor = .black
    configuration.attributedTitle = .authTitle(to: "애플로 계속하기", with: .white)
    let button = UIButton(configuration: configuration)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
  }
}

private extension LoginViewController {
  func configureUI() {
    view.backgroundColor = .systemBackground
    
    configureHierarchy()
    makeConstraints()
  }
  
  func configureHierarchy() {
    [rectangleView, logoLabel, appleAuthButton, kakaoAuthButton].forEach(view.addSubview)
  }
  
  func makeConstraints() {
    let safeArea = view.safeAreaLayoutGuide
    
    rectangleView.attach { view in
      view.top(equalTo: safeArea.topAnchor, padding: 64)
      view.leading(equalTo: safeArea.leadingAnchor, padding: 16)
      view.trailing(equalTo: safeArea.trailingAnchor, padding: 64)
      view.height(equalTo: 20)
    }
    
    logoLabel.attach {
      $0.leading(equalTo: rectangleView.leadingAnchor)
      $0.trailing(equalTo: rectangleView.trailingAnchor)
      $0.top(equalTo: rectangleView.bottomAnchor, padding: 16)
    }
    
    kakaoAuthButton.attach {
      $0.leading(equalTo: safeArea.leadingAnchor, padding: 16)
      $0.trailing(equalTo: safeArea.trailingAnchor, padding: 16)
      $0.bottom(equalTo: appleAuthButton.topAnchor, padding: 8)
    }
    
    appleAuthButton.attach {
      $0.leading(equalTo: safeArea.leadingAnchor, padding: 16)
      $0.trailing(equalTo: safeArea.trailingAnchor, padding: 16)
      $0.bottom(equalTo: safeArea.bottomAnchor)
    }
  }
}
