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
  
  private let nameTextField = SignUpTextField(type: .name, to: "이름", with: "이름을 입력해주세요.")
  private let phoneTextField = SignUpTextField(type: .phone, to: "휴대폰 번호")
  private let emailTextField = SignUpTextField(type: .email, to: "이메일")
  private let positionTextField = SignUpTextField(type: .position, to: "직급")
  
  weak var delegate: SettingProfileDelegate?
  private let viewModel: SettingProfileViewModel
  
  init(viewModel: SettingProfileViewModel) {
    self.viewModel = viewModel
    titleLabel.setTextWithLineHeight(text: "다운 이용을 위해\n기본 정보를 기입해주세요.", lineHeight: 26)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
    
    [nameTextField, phoneTextField, emailTextField, positionTextField].forEach {
      $0.delegate = self
      $0.addTarget(self, action: #selector(didChangeTextField), for: .editingChanged)
    }
    
    binding()
  }
  
  @objc private func didChangeTextField(_ textField: UITextField) {
    bindTextFieldItem(with: textField)
  }
}

extension SettingProfileViewController: UITextFieldDelegate {
  private func bindTextFieldItem(with textField: UITextField) {
    guard let textField = textField as? SignUpTextField,
          let text = textField.text,
          let fieldType = TextFormType(rawValue: textField.tag) else { return }
    print(text)
    switch fieldType {
      case .name:
        viewModel.bind(to: .editName(text))
      case .phone:
        viewModel.bind(to: .editPhoneNumber(text))
      case .email:
        viewModel.bind(to: .editEmail(text))
      case .position:
        viewModel.bind(to: .editPosition(text))
    }
  }
}

private extension SettingProfileViewController {
  func binding() {
    viewModel.nameUpdate = { [weak self] nickName in
      guard let nickName = nickName else { return }
      
      self?.nameTextField.text = nickName
      
      if nickName.isEmpty {
        self?.nameTextField.updateErrorMessage(to: "이름을 입력해주세요.")
        return
      }
      
      self?.nameTextField.updateSuccessMessage()
    }
    
    viewModel.phoneNumberUpdate = { [weak self] number in
      guard let number = number else { return }
      
      self?.phoneTextField.text = number
      
      if self?.verifyPhoneNumber(with: number) == false {
        self?.phoneTextField.updateErrorMessage(to: "올바른 번호를 입력해주세요.")
        return
      }
      
      self?.phoneTextField.updateSuccessMessage()
    }
  }
  
  private func verifyPhoneNumber(with number: String) -> Bool {
    let regex = "^01[0-1, 7]-[0-9]{3,4}-[0-9]{3,4}"
    return number.range(of: regex, options: .regularExpression) != nil
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
