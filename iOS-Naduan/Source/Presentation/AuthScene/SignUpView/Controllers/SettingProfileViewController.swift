//
//  SettingProfileViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

protocol SettingProfileDelegate: AnyObject {
  func settingProfile(to controller: UIViewController, didSuccessUpdate profile: UserProfile)
}

final class SettingProfileViewController: UIViewController {
  // View Property
  private let titleLabel = SignUpTitleLabel()
  
  private let nextFlowButton: UIButton = {
    var container = AttributeContainer()
    container.font = UIFont.pretendardFont(weight: .bold, size: 18)
    
    let inset = NSDirectionalEdgeInsets(top: 10, leading: .zero, bottom: 40, trailing: .zero)
    var configuration = UIButton.Configuration.daunStyle(with: .basic)
    configuration.background.cornerRadius = .zero
    configuration.contentInsets = inset
    configuration.setTitle(to: "다음", with: container)
    
    let button = UIButton(configuration: configuration)
    button.automaticallyUpdatesConfiguration = false
    return button
  }()
  
  private let profileInputScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    return scrollView
  }()
  
  private let scrollContentView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fillProportionally
    return stackView
  }()
  
  weak var delegate: SettingProfileDelegate?
  
  init() {
    titleLabel.setTextWithLineHeight(text: "다운 이용을 위해\n기본 정보를 기입해주세요.", lineHeight: 26)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
    
    let nextAction = UIAction { [weak self] _ in
      guard let self = self else {
        return
      }
      self.delegate?.settingProfile(to: self, didSuccessUpdate: .init())
    }
    
    nextFlowButton.addAction(nextAction, for: .touchUpInside)
  }
}

private extension SettingProfileViewController {
  func configureUI() {
    configureHierarchy()
    makeConstraints()
  }
  
  func configureHierarchy() {
    [titleLabel, nextFlowButton, profileInputScrollView].forEach(view.addSubview)
    [scrollContentView].forEach(profileInputScrollView.addSubview)
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
    
    profileInputScrollView.attach {
      $0.top(equalTo: titleLabel.bottomAnchor, padding: 12)
      $0.leading(equalTo: titleLabel.leadingAnchor)
      $0.trailing(equalTo: titleLabel.trailingAnchor)
      $0.bottom(equalTo: nextFlowButton.topAnchor, padding: 12)
    }
    
    scrollContentView.attach {
      $0.top(equalTo: profileInputScrollView.contentLayoutGuide.topAnchor)
      $0.leading(equalTo: profileInputScrollView.contentLayoutGuide.leadingAnchor)
      $0.trailing(equalTo: profileInputScrollView.contentLayoutGuide.trailingAnchor)
      $0.bottom(equalTo: profileInputScrollView.contentLayoutGuide.bottomAnchor)
      $0.width(equalTo: profileInputScrollView.frameLayoutGuide.widthAnchor)
    }
  }
}
