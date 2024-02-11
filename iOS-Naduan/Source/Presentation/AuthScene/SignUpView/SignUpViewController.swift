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
  
  var controller: SignUpChildFlowViewController {
    switch self {
      case .agreeTerm:
        let viewModel = AgreeTermViewModel()
        return AgreeTermViewController(viewModel: viewModel)
      case .settingProfile:
        return SettingProfileViewController()
      case .generateBasicCard:
        return GenerateBasicCardViewController()
    }
  }
}

final class SignUpViewController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureTabBarController()
    configureUI()
  }
}

extension SignUpViewController: SignUpFlowChildControllerDelegate {
  func signUpFlowChild(to controller: UIViewController, didSuccess item: Any) {
    selectedIndex += 1
  }
  
  func signUpFlowChild(to controller: UIViewController, didFailure error: Error) {
    print("실패")
  }
}

private extension SignUpViewController {
  func configureTabBarController() {
    addSubControllers()
    configureTabBar()
  }
  
  func addSubControllers() {
    let controllers = SignUpFlow.allCases.map(\.controller)
    controllers.forEach { $0.signUpDelegate = self }
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
  }
  
  func configureNavigationBar() {
    let closeAction = UIAction { _ in
      self.dismiss(animated: true)
    }
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "취소", primaryAction: closeAction)
  }
}
