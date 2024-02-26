//
//  SignUpViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

import FirebaseAuth

final class SignUpViewController: UITabBarController {
  // MARK: - Child Flow Item
  enum SignUpFlow {
    case agreeTerm
    case settingProfile
    case generateBasicCard(UserProfile)
  }
  
  private let user: FirebaseAuth.User
  
  init(user: FirebaseAuth.User) {
    self.user = user
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
    let skipAction = UIAction { [weak self] _ in
      self?.view.sceneDelegate?.presentMainViewController()
    }
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "나중에", primaryAction: skipAction)
    
    let cardController = generateChildController(to: .generateBasicCard(profile))
    viewControllers?.append(cardController)
    selectedIndex += 1
  }
}

// MARK: - GenerateBasicCard Delegate Method
extension SignUpViewController: GenerateBasicCardDelegate {
  func generateBasicCard(didSuccessUpdate controller: UIViewController) {
    view.sceneDelegate?.presentMainViewController()
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
        let repository = UserRepository(user: user, store: .firestore())
        let viewModel = SettingProfileViewModel(userRepository: repository)
        
        let controller = SettingProfileViewController(viewModel: viewModel)
        controller.delegate = self
        return controller
        
      case .generateBasicCard(let profile):
        let repository = BusinessCardRepository(profile: profile)
        let viewModel = GenerateBasicViewModel(repository: repository)
        let controller = GenerateBasicCardViewController(viewModel: viewModel)
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
