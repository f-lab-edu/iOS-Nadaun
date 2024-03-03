//
//  SplashViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

class SplashViewController: UIViewController {
  @IBOutlet weak var iconImage: UIImageView?
  
  private let viewModel: SplashViewModel
  
  init(viewModel: SplashViewModel) {
    self.viewModel = viewModel
    super.init()
  }
  
  required init?(coder: NSCoder) {
    let authRepository = AuthRepository(auth: .auth())
    self.viewModel = SplashViewModel(authRepository: authRepository)
    super.init(coder: coder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel.currentUserChange = { [weak self] user in
      if let user = user {
        self?.presentMain()
      } else {
        self?.presentLogin()
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    UIView.animate(withDuration: 1.0) {
      self.iconImage?.alpha = 1
    } completion: { [weak self] _ in
      self?.viewModel.bind(to: .checkAuthState)
    }
  }
  
  private func presentMain() {
    let controller = MainSampleViewController(nibName: nil, bundle: nil)
    controller.modalPresentationStyle = .fullScreen
    controller.modalTransitionStyle = .crossDissolve
    present(controller, animated: true)
  }
  
  private func presentLogin() {
    let authController = AuthController()
    let authRepository = AuthRepository(auth: .auth())
    let viewModel = LoginViewModel(authRepository: authRepository)
    let controller = LoginViewController(authController: authController, viewModel: viewModel)
    controller.modalPresentationStyle = .fullScreen
    controller.modalTransitionStyle = .crossDissolve
    present(controller, animated: true)
  }
}
