//
//  SignUpViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

final class SignUpViewController: UITabBarController {
  enum SignUpFlow: CaseIterable {
    case agreeTerm
    case settingProfile
    case generateBasicCard
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureTabBarController()
    configureUI()
  }
}

extension SignUpViewController: AgreeTermDelegate {
  func agreeTerm(isComplete controller: UIViewController) {
    selectedIndex += 1
  }
}

extension SignUpViewController: SettingProfileDelegate {
  func settingProfile(to controller: UIViewController, didSuccessUpdate profile: UserProfile) {
    // TODO: - 프로필 값을 활용하여서 기본 명함 설정 화면 이동
    let cardController = generateChildController(to: .generateBasicCard)
    viewControllers?.append(cardController)
    selectedIndex += 1
  }
}

extension SignUpViewController: GenerateBasicCardDelegate {
  func generateBasicCard(to controller: UIViewController, didSuccessUpdate card: BusinessCard) {
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
        
      case .settingProfile:
        let controller = SettingProfileViewController()
        controller.delegate = self
        return controller
        
      case .generateBasicCard:
        let controller = GenerateBasicCardViewController()
        controller.delegate = self
        return controller
    }
  }
}

private extension SignUpViewController {
  func configureTabBarController() {
    addSubControllers()
    configureTabBar()
  }
  
  func addSubControllers() {
    let flows: [SignUpFlow] = [.agreeTerm, .settingProfile]
    
    let controllers = flows.map { generateChildController(to: $0) }
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
