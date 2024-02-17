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
<<<<<<< HEAD
  // MARK: - View Properties
  private let titleLabel = SignUpTitleLabel()
  private let nextFlowButton = SignUpNextButton(title: "다음")
  
  private let profileInputScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.showsVerticalScrollIndicator = false
    scrollView.alwaysBounceVertical = false
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
  
  private let cardView: BusinessCardView = BusinessCardView()
  private let nameTextField = SignUpTextField(type: .name, to: "이름", with: "이름을 입력해주세요.")
  private let phoneTextField = SignUpTextField(type: .phone, to: "휴대폰 번호")
  private let emailTextField = SignUpTextField(type: .email, to: "이메일")
  private let positionTextField = SignUpTextField(type: .position, to: "직급")
  
  weak var delegate: SettingProfileDelegate?
  private var cardWidthConstraint: NSLayoutConstraint?
  private var cardHideWidthConstraint: NSLayoutConstraint?
  private let viewModel: SettingProfileViewModel
  
  // MARK: - Initializer
  init(viewModel: SettingProfileViewModel) {
    self.viewModel = viewModel
    titleLabel.setTextWithLineHeight(text: "다운 이용을 위해\n기본 정보를 채워보세요.", lineHeight: 26)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    cardWidthConstraint = cardView.width(equalTo: titleLabel.widthAnchor, multi: 0.8)
    cardHideWidthConstraint = cardView.width(equalTo: titleLabel.widthAnchor, multi: 0.4)
    
    configureUI()
    
    binding()
  }
}

extension SettingProfileViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    textField.endEditing(true)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.endEditing(true)
  }
  
  private func bindTextFieldItem(with textField: UITextField) {
    guard let textField = textField as? SignUpTextField,
          let text = textField.text,
          let fieldType = TextFormType(rawValue: textField.tag) else { return }
    
    switch fieldType {
      case .name:
        updateName(text)
      case .phone:
        viewModel.bind(to: .editPhoneNumber(text))
      case .email:
        updateEmail(text)
      case .position:
        cardView.updateProfile(position: text)
    }
  }
}

// MARK: - Binding Method
private extension SettingProfileViewController {
  func binding() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(willShowKeyboard),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(willHideKeyboard),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
    
    [nameTextField, phoneTextField, emailTextField, positionTextField].forEach {
      $0.delegate = self
      $0.addTarget(self, action: #selector(didChangeTextField), for: .editingChanged)
    }
    
    viewModel.phoneNumberUpdate = updatePhoneNumber(_:)
  }
  
  @objc private func willShowKeyboard(_ notification: Notification) {
    guard let userInformation = notification.userInfo,
          let keyBoardFrame = userInformation[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
      return
    }
    
    let contentInset = UIEdgeInsets(top: .zero, left: .zero, bottom: keyBoardFrame.size.height, right: .zero)
    profileInputScrollView.contentInset = contentInset
    updateCardView(isHidden: true)
  }
  
  @objc private func willHideKeyboard(_ notification: Notification) {
    profileInputScrollView.contentInset = .zero
    updateCardView(isHidden: false)
  }
  
  @objc private func didChangeTextField(_ textField: UITextField) {
    bindTextFieldItem(with: textField)
  }
}

// MARK: - Update Profile UI Methods
private extension SettingProfileViewController {
  func updateName(_ name: String?) {
    guard let name = name else { return }
    
    nameTextField.text = name
    cardView.updateProfile(name: name)
    
    if name.isEmpty == true {
      nameTextField.updateErrorMessage(to: "이름을 입력해주세요.")
      return
    }
    nameTextField.updateSuccessMessage()
  }
  
  func updatePhoneNumber(_ phoneNumber: String?) {
    guard let phoneNumber = phoneNumber else { return }
    
    phoneTextField.text = phoneNumber
    cardView.updateProfile(phone: phoneNumber)
    
    if verifyPhoneNumberFormat(with: phoneNumber) == false {
      phoneTextField.updateErrorMessage(to: "올바른 번호를 입력해주세요.")
      return
    }
    
    phoneTextField.updateSuccessMessage()
  }
  
  func updateEmail(_ email: String?) {
    guard let email = email else { return }
    
    emailTextField.text = email
    cardView.updateProfile(email: email)
    
    if verifyEmailFormat(with: email) == false {
      emailTextField.updateErrorMessage(to: "올바른 이메일을 입력해주세요.")
      return
    }
    
    emailTextField.updateSuccessMessage()
  }
  
  private func verifyEmailFormat(with email: String) -> Bool {
    let regex = "^([a-zA-Z0-9._-])+@[a-zA-Z0-9.-]+.[a-zA-Z]{3,20}$"
    return email.range(of: regex, options: .regularExpression) != nil
  }
  
  private func verifyPhoneNumberFormat(with number: String) -> Bool {
    let regex = "^01[0-1, 7]-[0-9]{3,4}-[0-9]{3,4}"
    return number.range(of: regex, options: .regularExpression) != nil
  }
}

// MARK: - Update Card View Methods
private extension SettingProfileViewController {
  func updateCardView(isHidden: Bool) {
    guard let cardWidthConstraint = cardWidthConstraint, let cardHideWidthConstraint = cardHideWidthConstraint else { return }
    
    if isHidden {
      view.removeConstraint(cardWidthConstraint)
      view.addConstraint(cardHideWidthConstraint)
    } else {
      view.removeConstraint(cardHideWidthConstraint)
      view.addConstraint(cardWidthConstraint)
    }
    
    UIView.animate(withDuration: 1) { [weak self] in
      if isHidden {
        self?.cardView.hide()
      } else {
        self?.cardView.show()
      }
      
      self?.cardView.layoutIfNeeded()
      self?.view.layoutIfNeeded()
    }
  }
}

// MARK: - Configure UI Methods
private extension SettingProfileViewController {
  func configureUI() {
    configureHierarchy()
    makeConstraints()
  }
  
  func configureHierarchy() {
    [titleLabel,cardView, nextFlowButton, profileInputScrollView].forEach(view.addSubview)
    [scrollContentView].forEach(profileInputScrollView.addSubview)
    [inputFormStackView].forEach(scrollContentView.addSubview)
    [nameTextField, phoneTextField, emailTextField, positionTextField]
      .forEach(inputFormStackView.addArrangedSubview)
  }
  
  func makeConstraints() {
    guard let cardWidthConstraint = cardWidthConstraint else { return }
    
    titleLabel.attach {
      $0.leading(equalTo: view.safeAreaLayoutGuide.leadingAnchor, padding: 20)
      $0.trailing(equalTo: view.safeAreaLayoutGuide.trailingAnchor, padding: 20)
      $0.top(equalTo: view.safeAreaLayoutGuide.topAnchor)
    }
    
    cardView.attach {
      $0.top(equalTo: titleLabel.bottomAnchor, padding: 32)
      $0.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor)
      cardWidthConstraint
      $0.height(equalTo: cardView.widthAnchor, multi: 0.6)
    }
    
    nextFlowButton.attach {
      $0.leading(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
      $0.trailing(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
      $0.bottom(equalTo: view.bottomAnchor)
    }
    
    profileInputScrollView.attach {
      $0.top(equalTo: cardView.bottomAnchor, padding: 32)
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
    
    inputFormStackView.attach {
      $0.top(equalTo: scrollContentView.topAnchor, padding: 4)
      $0.leading(equalTo: scrollContentView.leadingAnchor, padding: 4)
      $0.trailing(equalTo: scrollContentView.trailingAnchor, padding: 4)
      $0.bottom(equalTo: scrollContentView.bottomAnchor, padding: 4)
    }
  }
}
