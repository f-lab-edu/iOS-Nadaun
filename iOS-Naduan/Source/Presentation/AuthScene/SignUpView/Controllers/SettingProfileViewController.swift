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
  
  private let scrollContentView: UIStackView = {
    let stackView = UIStackView()
    stackView.distribution = .fillProportionally
    stackView.alignment = .fill
    stackView.axis = .vertical
    stackView.spacing = 32
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = UIEdgeInsets(top: 32, left: .zero, bottom: 16, right: .zero)
    return stackView
  }()
  
  private let nameTextField = SignUpTextField(type: .name, to: "이름 (필수)")
  private let emailTextField = SignUpTextField(type: .email, to: "이메일 (필수)")
  
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

extension SettingProfileViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    textField.endEditing(true)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return textField.endEditing(true)
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
    
    viewModel.isEnableNextButton = { [weak self] isAllCheck in
      self?.nextFlowButton.isEnabled = isAllCheck
    }
    
    viewModel.updateProfileSuccess = { [weak self] userProfile in
      guard let self = self else { return }
      delegate?.settingProfile(to: self, didSuccessUpdate: userProfile)
    }
    
    viewModel.updateProfileFailure = { [weak self] _ in
      self?.presentErrorAlert(for: "프로필 설정 중 예기치 못한 에러가 발생하였습니다. 잠시후 다시 시도해주세요.")
    }
  }
  
  @objc private func willShowKeyboard(_ notification: Notification) {
    guard let userInformation = notification.userInfo,
          let keyBoardFrame = userInformation[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
      return
    }
    
    let contentInset = UIEdgeInsets(top: .zero, left: .zero, bottom: keyBoardFrame.size.height, right: .zero)
    profileInputScrollView.contentInset = contentInset
  }
  
  @objc private func willHideKeyboard(_ notification: Notification) {
    profileInputScrollView.contentInset = .zero
  }
  
  @objc private func didChangeTextField(_ textField: UITextField) {
    guard let textField = textField as? SignUpTextField,
          let text = textField.text,
          let fieldType = TextFormType(rawValue: textField.tag) else { return }
    
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
    nextFlowButton.isEnabled = true
    
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

#if DEBUG
import SwiftUI
import FirebaseAuth

struct SettingProfile_Previews: PreviewProvider {
  static var previews: some View {
    UIViewControllerPreview {
      let repositiory = UserRepository(store: .firestore())
      let viewModel = SettingProfileViewModel(userRepository: repositiory)
      let controller = SettingProfileViewController(viewModel: viewModel)
      return controller
    }
  }
}
#endif
