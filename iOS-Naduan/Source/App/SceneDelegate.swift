//
//  SceneDelegate.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.
        

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    window = UIWindow(windowScene: windowScene)
    let authController = AuthController()
    
    let authRepository = AuthRepository()
    let loginViewModel = LoginViewModel(authRepository: authRepository)
    
    window?.rootViewController = LoginViewController(authController: authController, viewModel: loginViewModel)
    window?.makeKeyAndVisible()
  }
  
  func presentMainViewController() {
    let controller = UIViewController()
    controller.view.backgroundColor = .yellow
    window?.rootViewController = controller
  }
}
