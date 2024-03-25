//
//  DropCardViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

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
  private let dropCardSuccessView = DropCardSuccessView()
  private let dropCardFailureView = DropCardFailureAnimationView()
  
  private let additionalActionButton: UIButton = {
    var configuration = UIButton.Configuration.daunStyle(with: .basic)
    configuration.title = "확인"
    configuration.cornerStyle = .capsule
    configuration.baseBackgroundColor = .accent
    let button = UIButton(configuration: configuration)
    button.isHidden = true
    return button
  }()
  
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
    viewModel.didChangeCardShareState = { [weak self] in
      self?.updateUI(for: $0)
    }
  }
}

private extension DropCardViewController {
  func updateUI(for sharingState: CardShareState) {
    switch sharingState {
      case .success(let card):
        dropCardShareAnimationView.isHidden = true
        dropCardSuccessView.bind(to: card)
        dropCardSuccessView.isHidden = false
        dropCardFailureView.isHidden = true
        updateAdditionalAction(to: true)
        
      case .failure:
        dropCardShareAnimationView.isHidden = true
        dropCardSuccessView.isHidden = true
        dropCardFailureView.isHidden = false
        updateAdditionalAction(to: false)
        dropCardFailureView.play()
        
      case .sharing:
        dropCardShareAnimationView.isHidden = false
        dropCardSuccessView.isHidden = true
        dropCardFailureView.isHidden = true
        additionalActionButton.isHidden = true
    }
  }
}

private extension DropCardViewController {
  func configureUI() {
    view.backgroundColor = .systemBackground
    
    configureHierarchy()
    makeConstraints()
  }
  
  func updateAdditionalAction(to isSuccess: Bool) {
    additionalActionButton.isHidden = false
    var configuration = additionalActionButton.configuration
    let title = isSuccess ? "확인" : "다시 시도"
    configuration?.title = title
    additionalActionButton.configuration = configuration
    let identifier = UIAction.Identifier(Constants.actionIdentifier)
    additionalActionButton.removeAction(identifiedBy: identifier, for: .touchUpInside)
    
    
    if isSuccess {
      let action = UIAction(identifier: identifier) { [weak self] _ in
        self?.viewModel.bind(with: .stopShare)
        self?.dismiss(animated: true)
      }
      
      additionalActionButton.addAction(action, for: .touchUpInside)
      
      return
    }
    
    if isSuccess == false {
      let action = UIAction(identifier: identifier) { [weak self] action in
        self?.viewModel.bind(with: .stopShare)
        self?.viewModel.bind(with: .startShare)
        self?.dropCardShareAnimationView.isHidden = false
        self?.dropCardSuccessView.isHidden = true
        self?.dropCardFailureView.isHidden = true
        (action.sender as? UIButton)?.isHidden = true
      }
      
      additionalActionButton.addAction(action, for: .touchUpInside)
    }
  }
  
  func configureButtonActions() {
    let action = UIAction { [weak self] _ in
      self?.viewModel.bind(with: .stopShare)
      self?.dismiss(animated: true)
    }
    
    closeButton.addAction(action, for: .touchUpInside)
  }
  
  func configureHierarchy() {
    [closeButton, dropCardShareAnimationView, dropCardSuccessView, additionalActionButton, dropCardFailureView]
      .forEach(view.addSubview)
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
    
    dropCardSuccessView.attach {
      $0.top(equalTo: closeButton.bottomAnchor, padding: 16)
      $0.leading(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
      $0.trailing(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
      $0.bottom(equalTo: additionalActionButton.topAnchor, padding: 16)
    }
    
    dropCardFailureView.attach {
      $0.top(equalTo: closeButton.bottomAnchor, padding: 16)
      $0.leading(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
      $0.trailing(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
      $0.bottom(equalTo: additionalActionButton.topAnchor, padding: 16)
    }
    
    additionalActionButton.attach {
      $0.leading(equalTo: view.safeAreaLayoutGuide.leadingAnchor, padding: 16)
      $0.trailing(equalTo: view.safeAreaLayoutGuide.trailingAnchor, padding: 16)
      $0.bottom(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    }
  }
}

private extension DropCardViewController {
  enum Constants {
    static let actionIdentifier: String = "ADDITIONAL_ACTION"
  }
}
