//
//  DropCardViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

import Lottie

class DropCardViewController: UIViewController {
  private let closeButton: UIButton = {
    var configuration = UIButton.Configuration.filled()
    configuration.cornerStyle = .capsule
    configuration.contentInsets = NSDirectionalEdgeInsets(
      top: 4, leading: 4, bottom: 4, trailing: 4
    )
    configuration.image = UIImage.xmark.withTintColor(.white)
    return UIButton(configuration: configuration)
  }()
  
  private let dropCardShareAnimationView = DropCardShareAnimationView()
  
  private let cardView: CardView = {
    let cardView = CardView()
    cardView.layer.cornerRadius = 8
    cardView.layer.backgroundColor = UIColor.white.cgColor
    cardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
    cardView.layer.shadowRadius = 8
    cardView.layer.shadowOpacity = 1
    cardView.layer.shadowOffset = CGSize(width: 1, height: 1)
    cardView.isHidden = true
    return cardView
  }()
  
  private let viewModel: DropCardViewModel
  
  init(viewModel: DropCardViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable, message: "스토리보드로 생성할 수 없습니다.")
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
    binding()
    configureButtonActions()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    viewModel.bind(with: .startShare)
  }
}

private extension DropCardViewController {
  func binding() {
    viewModel.didReceiveCard = { [weak self] card in
      DispatchQueue.main.async {
        self?.dropCardShareAnimationView.isHidden = true
        self?.cardView.isHidden = false
      }
    }
  }
}

private extension DropCardViewController {
  func configureUI() {
    view.backgroundColor = .systemBackground
    
    configureHierarchy()
    makeConstraints()
  }
  
  func configureButtonActions() {
    let action = UIAction { [weak self] _ in
      self?.viewModel.bind(with: .stopShare)
      self?.dismiss(animated: true)
    }
    closeButton.addAction(action, for: .touchUpInside)
  }
  
  func configureHierarchy() {
    [closeButton, dropCardShareAnimationView].forEach(view.addSubview)
  }
  
  func makeConstraints() {
    closeButton.attach {
      $0.top(equalTo: view.safeAreaLayoutGuide.topAnchor, padding: 16)
      $0.leading(equalTo: view.safeAreaLayoutGuide.leadingAnchor, padding: 16)
      $0.height(equalTo: 24)
      $0.width(equalTo: 24)
    }
    
    dropCardShareAnimationView.attach {
      $0.top(equalTo: closeButton.bottomAnchor, padding: 16)
      $0.leading(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
      $0.trailing(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
      $0.bottom(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
//    cardView.attach {
//      $0.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//      $0.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//      $0.leading(equalTo: view.safeAreaLayoutGuide.leadingAnchor, padding: 32)
//      $0.trailing(equalTo: view.safeAreaLayoutGuide.trailingAnchor, padding: 32)
//      $0.height(equalTo: view.safeAreaLayoutGuide.heightAnchor, multi: 0.7)
//    }
  }
}

private extension DropCardViewController {

}
