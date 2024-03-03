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
    let storyBoard = UIStoryboard(name: "SplashScreen", bundle: nil)
    let initialViewController = storyBoard.instantiateViewController(identifier: "SplashViewController")
    window?.rootViewController = initialViewController
    window?.makeKeyAndVisible()
  }
}
