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
    
    NSLayoutConstraint.activate([
      rectangleView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 64),
      rectangleView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
      rectangleView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -64),
      rectangleView.heightAnchor.constraint(equalToConstant: 20),
      
      logoLabel.leadingAnchor.constraint(equalTo: rectangleView.leadingAnchor),
      logoLabel.topAnchor.constraint(equalTo: rectangleView.bottomAnchor, constant: 16),
      logoLabel.trailingAnchor.constraint(equalTo: rectangleView.trailingAnchor),
      
      appleAuthButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
      appleAuthButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
      appleAuthButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16),
      
      kakaoAuthButton.leadingAnchor.constraint(equalTo: appleAuthButton.leadingAnchor),
      kakaoAuthButton.trailingAnchor.constraint(equalTo: appleAuthButton.trailingAnchor),
      kakaoAuthButton.bottomAnchor.constraint(equalTo: appleAuthButton.topAnchor, constant: -8)
    ])
  }
}
