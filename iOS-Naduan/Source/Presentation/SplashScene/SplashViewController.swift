//
//  SplashViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

protocol UserStateObserver: AnyObject {
  func userStateObserver(didChangeState: UIViewController)
}

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
    
    viewModel.didSignIn = { [weak self] isSignIn in
      if isSignIn {
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
    view.sceneDelegate?.presentMain()
  }
  
  private func presentLogin() {
    view.sceneDelegate?.presentLogin()
  }
}
