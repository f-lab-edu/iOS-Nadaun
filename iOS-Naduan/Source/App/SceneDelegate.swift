//
//  SceneDelegate.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.
        

import UIKit

import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  private let auth = Auth.auth()
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    window = UIWindow(windowScene: windowScene)
    
    if let user = auth.currentUser {
      presentMainViewController(to: user)
    } else {
      presentLoginViewController()
    }
    
    window?.makeKeyAndVisible()
  }
  
  func presentMainViewController(to user: User) {
    let controller = MainTabBarController()
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
