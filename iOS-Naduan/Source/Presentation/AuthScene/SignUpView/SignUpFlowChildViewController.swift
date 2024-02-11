//
//  SignUpFlowChildViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

class SignUpFlowChildViewController: UIViewController {
  weak var signUpDelegate: SignUpFlowChildControllerDelegate?
  
  internal let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendardFont(to: .B1M)
    label.textColor = .accent
    label.numberOfLines = .zero
//    label.setTextWithLineHeight(text: "만나서 반가워요 :)\n가입약관을 확인해주세요.", lineHeight: 26)
    return label
  }()
  
  internal let nextFlowButton: UIButton = {
    var attributes = AttributeContainer()
    attributes.font = UIFont.pretendardFont(weight: .bold, size: 18)
    
    var configuration = UIButton.Configuration.filled()
    configuration.baseBackgroundColor = UIColor.accent
    configuration.background.cornerRadius = .zero
    configuration.attributedTitle = AttributedString("다음", attributes: attributes)
    configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: .zero, bottom: 40, trailing: .zero)
    
    let button = UIButton(configuration: configuration)
    button.automaticallyUpdatesConfiguration = false
    
    button.configurationUpdateHandler = { button in
      switch button.state {
        case .disabled:
          button.configuration?.background.backgroundColor = .disable
        case .normal:
          button.configuration?.background.backgroundColor = .accent
        default:
          return
      }
    }
    button.isEnabled = false
    return button
  }()
  
  init(title: String) {
    self.titleLabel.setTextWithLineHeight(text: title, lineHeight: 26)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
  }
  
  private func configureUI() {
    view.backgroundColor = .systemBackground
    
    configureHierarchy()
    makeConstraints()
  }
  
  func configureHierarchy() {
    [titleLabel, nextFlowButton].forEach(view.addSubview)
  }
  
  func makeConstraints() {
    titleLabel.attach {
      $0.leading(equalTo: view.safeAreaLayoutGuide.leadingAnchor, padding: 20)
      $0.trailing(equalTo: view.safeAreaLayoutGuide.trailingAnchor, padding: 20)
      $0.top(equalTo: view.safeAreaLayoutGuide.topAnchor)
    }
    
    nextFlowButton.attach {
      $0.leading(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
      $0.trailing(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
      $0.bottom(equalTo: view.bottomAnchor)
    }
    
    additionalSafeAreaInsets.top += titleLabel.frame.height
    additionalSafeAreaInsets.bottom += nextFlowButton.frame.height
  }
}
