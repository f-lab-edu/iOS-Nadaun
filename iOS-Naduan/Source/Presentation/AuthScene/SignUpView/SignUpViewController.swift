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
        let viewModel = AgreeTermViewModel()
        return AgreeTermViewController(
          title: "만나서 반가워요 :)\n가입약관을 확인해주세요.",
          viewModel: viewModel
        )
      default:
        return UIViewController()
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
  }
  
  func configureNavigationBar() {
    let closeAction = UIAction { _ in
      self.dismiss(animated: true)
    }
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "취소", primaryAction: closeAction)
  }
}
