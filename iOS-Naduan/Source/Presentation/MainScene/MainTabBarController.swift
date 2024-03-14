//
//  MainTabBarController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

final class MainTabBarController: UITabBarController {
  // MARK: - Scene Router
  private enum SceneRouter: Int, CaseIterable {
    case myCard
    case contact
    case setting
    
    var image: UIImage? {
      switch self {
        case .myCard:
          return .iconCard.withBaselineOffset(fromBottom: UIFont.systemFontSize * 2)
        case .contact:
          return .iconAddressBook.withBaselineOffset(fromBottom: UIFont.systemFontSize * 2)
        case .setting:
          return .iconGear.withBaselineOffset(fromBottom: UIFont.systemFontSize * 2)
      }
    }
    
    func generateInstance() -> UIViewController {
      switch self {
        case .myCard:
          let businessCardRepository = BusinessCardRepository()
          let viewModel = MyCardViewModel(cardRepository: businessCardRepository)
          let controller = MyCardViewController(viewModel: viewModel)
          controller.tabBarItem = UITabBarItem(title: nil, image: self.image, tag: self.rawValue)
          return controller
          
        // TODO: - 새로 생성되는 뷰컨 추가하기
        default:
          return UIViewController()
      }
    }
  }
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureTabBar()
    configureTabItems()
  }
  
  // MARK: Configure UI Methods
  private func configureTabItems() {
    view.backgroundColor = .systemBackground
    
    let controllers = SceneRouter.allCases.map { $0.generateInstance() }
      .map { UINavigationController(rootViewController: $0) }
    setViewControllers(controllers, animated: true)
  }
  
  private func configureTabBar() {
    tabBar.isTranslucent = false
    tabBar.unselectedItemTintColor = .body2
    tabBar.backgroundColor = .accent
    tabBar.tintColor = .white
    tabBar.layer.cornerRadius = 16
  }
}
