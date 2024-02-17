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
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendardFont(to: .B1M)
    label.textColor = .accent
    label.numberOfLines = .zero
    return label
  }()
  
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
  
  private let scrollContentView = UIView()
  
  private let inputFormStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.distribution = .fillProportionally
    stackView.alignment = .fill
    stackView.axis = .vertical
    stackView.spacing = 32
    return stackView
  }()
  
  private let cardView: BusinessCardView = {
    let cardView = BusinessCardView(profile: .init())
    return cardView
  }()
  
  private let nameTextField = SignUpTextField(to: "이름", with: "이름을 입력해주세요.")
  private let phoneTextField = SignUpTextField(to: "휴대폰 번호")
  private let emailTextField = SignUpTextField(to: "이메일")
  private let positionTextField = SignUpTextField(to: "직급")
  
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
    [cardView, inputFormStackView].forEach(scrollContentView.addSubview)
    [nameTextField, phoneTextField, emailTextField, positionTextField]
      .forEach(inputFormStackView.addArrangedSubview)
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
      $0.top(equalTo: titleLabel.bottomAnchor)
      $0.leading(equalTo: titleLabel.leadingAnchor)
      $0.trailing(equalTo: titleLabel.trailingAnchor)
      $0.bottom(equalTo: nextFlowButton.topAnchor)
    }
    
    scrollContentView.attach {
      $0.top(equalTo: profileInputScrollView.contentLayoutGuide.topAnchor)
      $0.leading(equalTo: profileInputScrollView.contentLayoutGuide.leadingAnchor)
      $0.trailing(equalTo: profileInputScrollView.contentLayoutGuide.trailingAnchor)
      $0.bottom(equalTo: profileInputScrollView.contentLayoutGuide.bottomAnchor)
      $0.width(equalTo: profileInputScrollView.frameLayoutGuide.widthAnchor)
    }
    
    cardView.attach {
      $0.top(equalTo: scrollContentView.topAnchor, padding: 32)
      $0.leading(equalTo: scrollContentView.leadingAnchor, padding: 32)
      $0.trailing(equalTo: scrollContentView.trailingAnchor, padding: 32)
      $0.height(equalTo: scrollContentView.widthAnchor, multi: 0.5)
    }
    
    inputFormStackView.attach {
      $0.top(equalTo: cardView.bottomAnchor, padding: 32)
      $0.leading(equalTo: scrollContentView.leadingAnchor, padding: 4)
      $0.trailing(equalTo: scrollContentView.trailingAnchor, padding: 4)
      $0.bottom(equalTo: scrollContentView.bottomAnchor, padding: 4)
    }
  }
}

#if DEBUG

import SwiftUI

struct SettingProfileViewController_Previews: PreviewProvider {
  static var previews: some View {
    UIViewControllerPreview {
      let controller = SettingProfileViewController()
      let navigationController = UINavigationController(rootViewController: controller)
      return navigationController
    }
    .ignoresSafeArea()
  }
}
#endif
