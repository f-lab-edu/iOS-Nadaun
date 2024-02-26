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
    presentLoginViewController()
    window?.makeKeyAndVisible()
  }
  
  func presentMainViewController(to userID: String) {
    let controller = MainTabBarController(userID: userID)
    window?.rootViewController = controller
  }
  
  func presentLoginViewController() {
    let authController = AuthController()
    
    let authRepository = AuthRepository()
    let loginViewModel = LoginViewModel(authRepository: authRepository)
    let controller = LoginViewController(authController: authController, viewModel: loginViewModel)
    window?.rootViewController = controller
  }
}
