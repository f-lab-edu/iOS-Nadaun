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
  // MARK: - View Properties
  private let titleLabel = SignUpTitleLabel()
  private let nextFlowButton = SignUpNextButton(title: "다음") { button in
    switch button.state {
      case .disabled:
        button.configuration?.background.backgroundColor = .disable
      case .normal:
        button.configuration?.background.backgroundColor = .accent
      default:
        return
    }
  }
  
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
  private let phoneTextField = SignUpTextField(type: .phone, to: "휴대폰 번호", with: "휴대폰 번호를 입력해주세요.")
  private let emailTextField = SignUpTextField(type: .email, to: "이메일", with: "이메일을 입력해주세요.")
  private let positionTextField = SignUpTextField(type: .position, to: "직급", with: "직급을 입력해주세요.")
  
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
    cardHideWidthConstraint = cardView.width(equalTo: titleLabel.widthAnchor, multi: 0.6)
    
    configureUI()
    
    binding()
  }
}

extension SettingProfileViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    updateProfileInCardView()
    textField.endEditing(true)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    updateProfileInCardView()
    return textField.endEditing(true)
  }
  
  private func updateProfileInCardView() {
    guard let name = nameTextField.text,
          let phone = phoneTextField.text,
          let email = emailTextField.text,
          let position = positionTextField.text else { return }
    
    cardView.updateProfile(name: name, phone: phone, email: email, position: position)
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
    
    viewModel.didChangeName = { [weak self] name in
      self?.nameTextField.text = name
    }
    
    viewModel.didChangePhoneNumber = { [weak self] phoneNumber in
      self?.phoneTextField.text = phoneNumber
    }
    
    viewModel.didChangeEmail = { [weak self] email in
      self?.emailTextField.text = email
    }
    
    viewModel.didChangePosition = { [weak self] position in
      self?.positionTextField.text = position
    }
    
    viewModel.isVerifyNameFormat = { [weak self] isFormat in
      self?.nameTextField.updateExplanationLabel(isFormat: isFormat)
    }
    
    viewModel.isVerifyPhoneFormat = { [weak self] isFormat in
      self?.phoneTextField.updateExplanationLabel(isFormat: isFormat)
    }
    
    viewModel.isVerifyEmailFormat = { [weak self] isFormat in
      self?.emailTextField.updateExplanationLabel(isFormat: isFormat)
    }
    
    viewModel.isEnableNextButton = { [weak self] isAllCheck in
      self?.nextFlowButton.isEnabled = (isAllCheck == false)
    }
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
    guard let textField = textField as? SignUpTextField,
          let text = textField.text,
          let fieldType = TextFormType(rawValue: textField.tag) else { return }
    
    switch fieldType {
      case .name:
        viewModel.bind(to: .editName(text))
      case .phone:
        viewModel.bind(to: .editPhone(text))
      case .email:
        viewModel.bind(to: .editEmail(text))
      case .position:
        viewModel.bind(to: .editPosition(text))
    }
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
    
    UIView.animate(
      withDuration: 1,
      animations: { self.view.layoutIfNeeded() },
      completion: { _ in
        isHidden ? self.cardView.hide() : self.cardView.show()
      }
    )
  }
}

// MARK: - View Action Method
private extension SettingProfileViewController {
  func attachActions() {
    
  }
}

// MARK: - Configure UI Methods
private extension SettingProfileViewController {
  func configureUI() {
    view.backgroundColor = .systemBackground
    nextFlowButton.isEnabled = true
    
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
