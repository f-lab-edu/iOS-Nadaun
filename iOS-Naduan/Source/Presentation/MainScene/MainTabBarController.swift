//
//  MainTabBarController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

final class MainTabBarController: UITabBarController {
  private enum SceneRouter: CaseIterable {
    case myCard
    case example
    
    func generateInstance() -> UIViewController {
      switch self {
        case .myCard:
          let controller = MyCardViewController()
          let tabBarItem = UITabBarItem()
          tabBarItem.image = .add.withBaselineOffset(fromBottom: UIFont.systemFontSize * 2)
          controller.tabBarItem = tabBarItem
          return controller
          
        case .example:
          let controller = MyCardViewController()
          controller.tabBarItem = UITabBarItem(title: nil, image: .remove, tag: 1)
          return controller
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureTabBar()
    configureTabItems()
  }
  
  private func configureTabItems() {
    view.backgroundColor = .systemBackground
    
    let controllers = SceneRouter.allCases.map { $0.generateInstance() }
    setViewControllers(controllers, animated: true)
  }
  
  private func configureTabBar() {
    tabBar.isTranslucent = false
    tabBar.unselectedItemTintColor = .black
    tabBar.backgroundColor = .accent
    tabBar.tintColor = .white
  }
}
