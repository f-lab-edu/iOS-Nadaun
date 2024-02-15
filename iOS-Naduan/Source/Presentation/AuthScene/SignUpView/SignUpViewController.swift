//
//  SignUpViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

final class SignUpViewController: UITabBarController {
  // MARK: - Child Flow Item
  enum SignUpFlow: CaseIterable {
    case agreeTerm
    case settingProfile
    case generateBasicCard
  }
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureTabBarController()
    configureUI()
  }
}

// MARK: - AgreeTerm Delegate Method
extension SignUpViewController: AgreeTermDelegate {
  func agreeTerm(isComplete controller: UIViewController) {
    selectedIndex += 1
  }
}

// MARK: - SettingProfile Delegate Method
extension SignUpViewController: SettingProfileDelegate {
  func settingProfile(to controller: UIViewController, didSuccessUpdate profile: UserProfile) {
    let cardController = generateChildController(to: .generateBasicCard)
    viewControllers?.append(cardController)
    selectedIndex += 1
  }
}

// MARK: - GenerateBasicCard Delegate Method
extension SignUpViewController: GenerateBasicCardDelegate {
  func generateBasicCard(to controller: UIViewController, didSuccessUpdate card: BusinessCard) {
    // TODO: - 홈 화면으로 전환
  }
}

// MARK: - Child Controller Generate Methods
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

// MARK: - Configure Tab Bar Controller
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

// MARK: - Configure UI Method
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
