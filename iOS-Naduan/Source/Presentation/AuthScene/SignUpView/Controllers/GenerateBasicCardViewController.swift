//
//  GenerateBasicCardViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

// MARK: - Generate Basic Card Delegate
protocol GenerateBasicCardDelegate: AnyObject {
  func generateBasicCard(didSuccessUpdate controller: UIViewController)
}

final class GenerateBasicCardViewController: UIViewController {
  // MARK: - View Properties
  private let titleLabel: SignUpTitleLabel = SignUpTitleLabel()
  private let nextFlowButton = SignUpNextButton(title: "완료") { button in
    switch button.state {
      case .disabled:
        button.configuration?.background.backgroundColor = .disable
      case .normal:
        button.configuration?.background.backgroundColor = .accent
      default: return
    }
  }
  private let cardInformationScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    return scrollView
  }()
  
  private let informationContentView: UIStackView = {
    let stackView = UIStackView()
    stackView.distribution = .fillEqually
    stackView.alignment = .fill
    stackView.axis = .vertical
    stackView.spacing = 32
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = UIEdgeInsets(top: 32, left: .zero, bottom: 16, right: .zero)
    return stackView
  }()
  
  private let companyTextField = SignUpTextField(
    type: .company,
    to: TextConstants.companyDescription
  )
  
  private let departmentTextField = SignUpTextField(
    type: .department,
    to: TextConstants.departmentDescription
  )
  
  private let positionTextField = SignUpTextField(
    type: .position,
    to: TextConstants.positionDescription
  )
  
  // MARK: - Business Logic Properties
  weak var delegate: GenerateBasicCardDelegate?
  private let viewModel: GenerateBasicViewModel
  
  // MARK: - Life Cycle
  init(viewModel: GenerateBasicViewModel) {
    self.viewModel = viewModel
    self.titleLabel.setTextWithLineHeight(text: "다운에서\n첫번째 명함을 완성해보세요.", lineHeight: 26)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
    binding()
  }
}

// MARK: - Binding Methods
private extension GenerateBasicCardViewController {
  func binding() {
    bindingView()
    
    viewModel.didFillAll = { [weak self] isEnable in
      self?.nextFlowButton.isEnabled = isEnable
    }
    
    viewModel.didGenerateBasicCardSucceed = { [weak self] in
      guard let self = self else { return }
      
      self.delegate?.generateBasicCard(didSuccessUpdate: self)
    }
    
    viewModel.didOccurError = { [weak self] errorDescription in
      self?.presentErrorAlert(for: errorDescription)
    }
    
    [companyTextField, departmentTextField, positionTextField].forEach {
      $0.addTarget(self, action: #selector(didChangeTextField), for: .editingChanged)
    }
  }
  
  func bindingView() {
    let action = UIAction { [weak self] _ in
      self?.viewModel.bind(action: .generateCard)
    }
    nextFlowButton.addAction(action, for: .touchUpInside)
  }
  
  @objc private func didChangeTextField(_ textField: UITextField) {
    guard let text = textField.text,
          let type = SignUpTextField.SignUpFormType(rawValue: textField.tag) else { return }
    
    switch type {
      case .company:
        viewModel.bind(action: .changeCompany(text))
      case .department:
        viewModel.bind(action: .changeDepartment(text))
      case .position:
        viewModel.bind(action: .changePosition(text))
      default: return
    }
  }
}

// MARK: - View Update Method
private extension GenerateBasicCardViewController {
  func presentErrorAlert(for reason: String) {
    let controller = UIAlertController(title: "", message: reason, preferredStyle: .alert)
    let confirmAction = UIAlertAction(title: "확인", style: .default)
    controller.addAction(confirmAction)
    present(controller, animated: true)
  }
}

// MARK: - Configure View Methods
private extension GenerateBasicCardViewController {
  func configureUI() {
    view.backgroundColor = .systemBackground
    
    configureNavigationBar()
    
    configureHierarchy()
    makeConstraints()
  }
  
  func configureNavigationBar() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "나중에")
  }
  
  func configureHierarchy() {
    [titleLabel, cardInformationScrollView, nextFlowButton].forEach(view.addSubview)
    [informationContentView].forEach(cardInformationScrollView.addSubview)
    [companyTextField, departmentTextField, positionTextField].forEach(informationContentView.addArrangedSubview)
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
    
    cardInformationScrollView.attach {
      $0.top(equalTo: titleLabel.bottomAnchor, padding: 12)
      $0.leading(equalTo: titleLabel.leadingAnchor)
      $0.trailing(equalTo: titleLabel.trailingAnchor)
      $0.bottom(equalTo: nextFlowButton.topAnchor)
    }
    
    informationContentView.attach {
      $0.top(equalTo: cardInformationScrollView.contentLayoutGuide.topAnchor)
      $0.leading(equalTo: cardInformationScrollView.contentLayoutGuide.leadingAnchor)
      $0.trailing(equalTo: cardInformationScrollView.contentLayoutGuide.trailingAnchor)
      $0.bottom(equalTo: cardInformationScrollView.contentLayoutGuide.bottomAnchor)
      $0.width(equalTo: cardInformationScrollView.frameLayoutGuide.widthAnchor)
    }
  }
}

private extension GenerateBasicCardViewController {
  enum TextConstants {
    static let nextDescription: String = "다음에"
    static let companyDescription: String = "회사"
    static let departmentDescription: String = "부서"
    static let positionDescription: String = "직책"
  }
}
