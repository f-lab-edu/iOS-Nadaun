//
//  SceneDelegate.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.
        

import UIKit

import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    let storyBoard = UIStoryboard(name: Constants.storyBoardName, bundle: nil)
    let initialViewController = storyBoard.instantiateViewController(identifier: Constants.viewIdentifier)
    window?.rootViewController = initialViewController
    window?.makeKeyAndVisible()
  }
  
  private enum Constants {
    static let storyBoardName: String = "SplashScreen"
    static let viewIdentifier: String = "SplashViewController"
  }
  
  func presentMain() {
    let controller = MainTabBarController(nibName: nil, bundle: nil)
    controller.modalPresentationStyle = .fullScreen
    controller.modalTransitionStyle = .crossDissolve
    window?.rootViewController = controller
  }
  
  func presentLogin() {
    let authController = AuthController()
    let authRepository = AuthRepository(auth: .auth())
    let viewModel = LoginViewModel(authRepository: authRepository)
    let controller = LoginViewController(authController: authController, viewModel: viewModel)
    window?.rootViewController = controller
  }
}
