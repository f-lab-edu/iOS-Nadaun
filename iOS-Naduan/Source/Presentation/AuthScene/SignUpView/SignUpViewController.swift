//
//  SignUpViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

enum SignUpFlow: CaseIterable {
  case agreeTerm
  case settingProfile
  case generateBasicCard
  
  var controller: UIViewController {
    switch self {
      case .agreeTerm:
        return AgreeTermViewController()
      case .settingProfile:
        return SettingProfileViewController()
      case .generateBasicCard:
        return GenerateBasicCardViewController()
    }
  }
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
    
    configureTabBarController()
    configureUI()
  }
}

private extension SignUpViewController {
  func configureTabBarController() {
    addSubControllers()
    configureTabBar()
  }
  
  func addSubControllers() {
    let controllers = SignUpFlow.allCases.map(\.controller)
    setViewControllers(controllers, animated: true)
  }
  
  func configureTabBar() {
    tabBar.isHidden = true
  }
}

private extension SignUpViewController {
  func configureUI() {
    view.backgroundColor = .systemBackground
    
    configureNavigationBar()
    
    configureHierarchy()
    makeConstraints()
  }
  
  func configureNavigationBar() {
    let closeAction = UIAction { _ in
      self.dismiss(animated: true)
    }
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "취소", primaryAction: closeAction)
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
