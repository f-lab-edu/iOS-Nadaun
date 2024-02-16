//
//  SettingProfileViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

protocol SettingProfileDelegate: AnyObject {
  func settingProfile(to controller: UIViewController, didSuccessUpdate profile: UserProfile)
}

class InsetTextField: UITextField {
  private let padding: UIEdgeInsets
  
  init(padding: UIEdgeInsets) {
    self.padding = padding
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    insetTextRect(for: bounds)
  }
  
  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    insetTextRect(for: bounds)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    insetTextRect(for: bounds)
  }
  
  private func insetTextRect(for bounds: CGRect) -> CGRect {
    let inset = bounds.inset(by: padding)
    return inset
  }
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
  
  private let cardView: CardView = {
    let cardView = CardView(profile: .init())
    return cardView
  }()
  
  private let nameTextField: InsetTextField = {
    let inset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    let textField = InsetTextField(padding: inset)
    textField.font = .pretendardFont(to: .B3M)
    textField.attributedPlaceholder = NSAttributedString(string: "이름 (필수)", attributes: [.foregroundColor: UIColor.disable])
    textField.layer.borderColor = UIColor.disable.cgColor
    textField.layer.borderWidth = 1
    textField.layer.cornerRadius = 4
    return textField
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
    [cardView, nameTextField].forEach(scrollContentView.addSubview)
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
      $0.leading(equalTo: view.leadingAnchor)
      $0.trailing(equalTo: view.trailingAnchor)
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
    
    nameTextField.attach {
      $0.top(equalTo: cardView.bottomAnchor, padding: 16)
      $0.leading(equalTo: scrollContentView.leadingAnchor, padding: 20)
      $0.trailing(equalTo: scrollContentView.trailingAnchor, padding: 20)
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
  }
}
#endif
