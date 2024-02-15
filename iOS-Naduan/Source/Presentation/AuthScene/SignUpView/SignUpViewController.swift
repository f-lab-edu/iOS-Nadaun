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
}

final class SignUpViewController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureTabBarController()
    configureUI()
  }
}

extension SignUpViewController: AgreeTermDelegate {
  func agreeTerm(isComplete controller: UIViewController) {
    print("Success AgreeTerm")
    selectedIndex += 1
  }
}

private extension SignUpViewController {
  func generateChildController(to flow: SignUpFlow) -> UIViewController {
    switch flow {
      case .agreeTerm:
        let viewModel = AgreeTermViewModel()
        let controller = AgreeTermViewController(viewModel: viewModel)
        controller.delegate = self
        return controller
      default:
        return UIViewController()
    }
  }
}

private extension SignUpViewController {
  func configureTabBarController() {
    addSubControllers()
    configureTabBar()
  }
  
  func addSubControllers() {
    let controllers = SignUpFlow.allCases.map { generateChildController(to: $0) }
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
