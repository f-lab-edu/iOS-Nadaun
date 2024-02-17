//
//  LoginViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

final class LoginViewController: UIViewController {
  // MARK: - View Properties
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
    var container = AttributeContainer()
    container.font = UIFont.pretendardFont(to: .H5B)
    
    var configuration = UIButton.Configuration.daunStyle(with: .custom(.colorKakao, .title))
    configuration.image = .iconKakao
    configuration.imagePadding = 10
    configuration.cornerStyle = .capsule
    configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: .zero, bottom: 10, trailing: .zero)
    
    configuration.setTitle(to: "카카오로 계속하기", with: container)
    return UIButton(configuration: configuration)
  }()
  
  private let appleAuthButton: UIButton = {
    var container = AttributeContainer()
    container.font = UIFont.pretendardFont(to: .H5B)
    
    var configuration = UIButton.Configuration.daunStyle(with: .custom(.title, .white))
    configuration.image = .iconApple
    configuration.imagePadding = 10
    configuration.cornerStyle = .capsule
    configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: .zero, bottom: 10, trailing: .zero)
    
    configuration.setTitle(to: "애플로 계속하기", with: container)
    
    return UIButton(configuration: configuration)
  }()
  
  // MARK: - Logical Properties
  private let authController: AuthController
  private let viewModel: LoginViewModel
  
  // MARK: - Initializer
  init(authController: AuthController, viewModel: LoginViewModel) {
    self.authController = authController
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
        
    authController.delegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
    attachActions()
    
    setBinding()
  }
}

// MARK: - AuthController Delegate Method
extension LoginViewController: AuthControllerDelegate {
  func authController(
    to controller: AuthController,
    didSuccess idToken: String,
    withProvider provider: AuthProvider
  ) {
    viewModel.bind(with: .signIn(provider: provider, idToken: idToken))
  }
  
  func authController(to controller: AuthController, didFailure error: LocalizedError) {
    presentErrorAlert(to: error)
  }
}

// MARK: - Binding Method
private extension LoginViewController {
  func setBinding() {
    viewModel.didNotRegister = { [weak self] user in
      let controller = SignUpViewController(user: user)
      let navigationController = UINavigationController(rootViewController: controller)
      navigationController.modalPresentationStyle = .fullScreen
      self?.present(navigationController, animated: true)
    }
    
    viewModel.didRegister = { user in
      // TODO: - PRESENT HOME VIEW
    }
    
    viewModel.didErrorOccur = { [weak self] error in
      self?.presentErrorAlert(to: error)
    }
  }
}

// MARK: - View Action Method
private extension LoginViewController {
  func attachActions() {
    let kakaoAuthAction = UIAction { [weak self] _ in
      self?.authController.authWithKakao()
    }
    
    kakaoAuthButton.addAction(kakaoAuthAction, for: .touchUpInside)
    
    let appleAuthAction = UIAction { [weak self] _ in
      self?.authController.authWithApple()
    }
    
    appleAuthButton.addAction(appleAuthAction, for: .touchUpInside)
  }
  
  func presentErrorAlert(to error: LocalizedError) {
      let confirmAction = UIAlertAction(title: "확인", style: .cancel)
      let controller = UIAlertController(title: "오류", message: error.errorDescription, preferredStyle: .alert)
      
      controller.addAction(confirmAction)
      
      present(controller, animated: true)
  }
}

// MARK: - Configuration UI
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
