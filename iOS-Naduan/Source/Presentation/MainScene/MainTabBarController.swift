//
//  MainTabBarController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

import FirebaseAuth

final class MainTabBarController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    
    let controller = MainSampleViewController()
    controller.tabBarItem = UITabBarItem(title: "홈", image: .checkmark, tag: .zero)
    setViewControllers([controller], animated: true)
  }
}

class MainSampleViewController: UIViewController {
  private let button: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("로그아웃", for: .normal)
    button.setTitleColor(.black, for: .normal)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    let action = UIAction { [weak self] _ in
      guard let _ = try? Auth.auth().signOut(),
            let windowScene = self?.view.window?.windowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
      
      sceneDelegate.presentLoginViewController()
    }
    button.addAction(action, for: .touchUpInside)
    
    view.addSubview(button)
    
    button.attach {
      $0.centerXAnchor.constraint(equalTo: view.centerXAnchor)
      $0.centerYAnchor.constraint(equalTo: view.centerYAnchor)
      $0.width(equalTo: 100)
    }
  }
}
