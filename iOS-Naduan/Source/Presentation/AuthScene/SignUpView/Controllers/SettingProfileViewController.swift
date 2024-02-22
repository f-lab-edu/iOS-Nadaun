//
//  SettingProfileViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

// MARK: - Setting Profile Delegate
protocol SettingProfileDelegate: AnyObject {
  func settingProfile(to controller: UIViewController, didSuccessUpdate profile: UserProfile)
}

// MARK: - Setting Profile View Controller
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
  
  private let scrollContentView: UIStackView = {
    let stackView = UIStackView()
    stackView.distribution = .fillEqually
    stackView.alignment = .fill
    stackView.axis = .vertical
    stackView.spacing = 32
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = UIEdgeInsets(top: 32, left: .zero, bottom: 16, right: .zero)
    return stackView
  }()
  
  private let nameTextField = SignUpTextField(type: .name, to: TextConstants.nameTitle)
  private let emailTextField = SignUpTextField(type: .email, to: TextConstants.emailTitle)
  
  // MARK: - Business Logic Properties
  weak var delegate: SettingProfileDelegate?
  private let viewModel: SettingProfileViewModel
  
  // MARK: - Initializer
  init(viewModel: SettingProfileViewModel) {
    self.viewModel = viewModel
    titleLabel.setTextWithLineHeight(text: "다운에서 사용할\n회원님의 정보를 입력해주세요.", lineHeight: 26)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
    attachButtonActions()
    
    binding()
  }
}

// MARK: - UITextField Delegate Method
extension SettingProfileViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == nameTextField {
      emailTextField.becomeFirstResponder()
    } else {
      textField.endEditing(true)
    }
    
    return true
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
    
    [nameTextField, emailTextField].forEach {
      $0.delegate = self
      $0.addTarget(self, action: #selector(didChangeTextField), for: .editingChanged)
    }
    
    viewModel.didChangeName = { [weak self] name in
      self?.nameTextField.text = name
    }
    
    viewModel.didChangeEmail = { [weak self] email in
      self?.emailTextField.text = email
    }
    
    viewModel.isVerifyAllFormat = { [weak self] isAllCheck in
      self?.nextFlowButton.isEnabled = isAllCheck
    }
    
    viewModel.updateProfileSuccess = { [weak self] userProfile in
      guard let self = self else { return }
      
      DispatchQueue.main.async {
        self.delegate?.settingProfile(to: self, didSuccessUpdate: userProfile)
      }
    }
    
    viewModel.errorOccur = { [weak self] message in
      DispatchQueue.main.async {
        self?.presentErrorAlert(for: message)
      }
    }
  }
  
  @objc private func willShowKeyboard(_ notification: Notification) {
    let informationKey = UIResponder.keyboardFrameEndUserInfoKey
    guard let userInformation = notification.userInfo,
          let keyBoardFrame = userInformation[informationKey] as? CGRect else {
      return
    }
    
    let contentInset = UIEdgeInsets(
      top: .zero,
      left: .zero,
      bottom: keyBoardFrame.size.height,
      right: .zero
    )
    profileInputScrollView.contentInset = contentInset
  }
  
  @objc private func willHideKeyboard(_ notification: Notification) {
    profileInputScrollView.contentInset = .zero
  }
  
  @objc private func didChangeTextField(_ textField: UITextField) {
    guard let textField = textField as? SignUpTextField,
          let text = textField.text,
          let fieldType = SignUpTextField.SignUpFormType(rawValue: textField.tag) else { return }
    
    switch fieldType {
      case .name:
        viewModel.bind(to: .editName(text))
      case .email:
        viewModel.bind(to: .editEmail(text))
      default:
        return
    }
  }
}

// MARK: - View Action Method
private extension SettingProfileViewController {
  func attachButtonActions() {
    let updateAction = UIAction { [weak self] _ in
      self?.viewModel.bind(to: .updateProfile)
    }
    nextFlowButton.addAction(updateAction, for: .touchUpInside)
  }
  
  func presentErrorAlert(for reason: String) {
    let controller = UIAlertController(title: "", message: reason, preferredStyle: .alert)
    let confirmAction = UIAlertAction(title: "확인", style: .default)
    controller.addAction(confirmAction)
    present(controller, animated: true)
  }
}

// MARK: - Configure UI Methods
private extension SettingProfileViewController {
  func configureUI() {
    view.backgroundColor = .systemBackground
    
    configureHierarchy()
    makeConstraints()
  }
  
  func configureHierarchy() {
    [titleLabel, nextFlowButton, profileInputScrollView].forEach(view.addSubview)
    [scrollContentView].forEach(profileInputScrollView.addSubview)
    [nameTextField, emailTextField]
      .forEach(scrollContentView.addArrangedSubview)
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
      $0.bottom(equalTo: nextFlowButton.topAnchor)
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

private extension SettingProfileViewController {
  enum TextConstants {
    static let nameTitle: String = "이름 (필수)"
    static let emailTitle: String = "이메일 (필수)"
  }
}
