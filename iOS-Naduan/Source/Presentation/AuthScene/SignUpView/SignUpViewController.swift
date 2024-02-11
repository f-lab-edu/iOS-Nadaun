//
//  SignUpViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

enum SignUpFlow {
  case agreeTerm
  case settingProfile
  case generateBasicCard
}

final class SignUpViewController: UITabBarController {
  private let nextFlowButton: UIButton = {
    var attributes = AttributeContainer()
    attributes.font = UIFont.pretendardFont(weight: .bold, size: 18)
    
    var configuration = UIButton.Configuration.filled()
    configuration.baseBackgroundColor = UIColor.accent
    configuration.background.cornerRadius = .zero
    configuration.attributedTitle = AttributedString("다음", attributes: attributes)
    configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: .zero, bottom: 40, trailing: .zero)
    
    let button = UIButton(configuration: configuration)
    button.automaticallyUpdatesConfiguration = false
    
    button.configurationUpdateHandler = { button in
      switch button.state {
        case .disabled:
          button.configuration?.background.backgroundColor = .disable
        case .normal:
          button.configuration?.background.backgroundColor = .accent
        default:
          return
      }
    }
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureTabBar()
    configureUI()
  }
}

private extension SignUpViewController {
  func configureTabBar() {
    tabBar.isHidden = true
  }
}

private extension SignUpViewController {
  func configureUI() {
    view.backgroundColor = .systemBackground
    
    configureHierarchy()
    makeConstraints()
  }
  
  func configureHierarchy() {
    [nextFlowButton].forEach(view.addSubview)
  }
  
  func makeConstraints() {
    nextFlowButton.attach {
      $0.leading(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
      $0.trailing(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
      $0.bottom(equalTo: view.bottomAnchor)
    }
  }
}
