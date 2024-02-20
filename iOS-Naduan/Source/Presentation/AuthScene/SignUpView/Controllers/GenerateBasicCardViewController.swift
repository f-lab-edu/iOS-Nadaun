//
//  GenerateBasicCardViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

protocol GenerateBasicCardDelegate: AnyObject {
  func generateBasicCard(to controller: UIViewController, didSuccessUpdate card: BusinessCard)
}

final class GenerateBasicCardViewController: UIViewController {
  weak var delegate: GenerateBasicCardDelegate?
  
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
  
  private let companyTextField = SignUpTextField(type: .company, to: "회사")
  private let departmentTextField = SignUpTextField(type: .department, to: "부서")
  private let positionTextField = SignUpTextField(type: .position, to: "직책")
  
  private let viewModel: GenerateBasicViewModel
  
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

private extension GenerateBasicCardViewController {
  func binding() {
    bindingView()
    
    viewModel.nextButtonEnable = { [weak self] isEnable in
      self?.nextFlowButton.isEnabled = isEnable
    }
    
    viewModel.generateCardSuccess = { [weak self] in
      // TODO: - Success Method Binding
    }
    
    viewModel.generateCardFailure = { [weak self] error in
      // TODO: - Failure Method Binding
    }
    
    [companyTextField, departmentTextField, positionTextField].forEach {
      $0.addTarget(self, action: #selector(didChangeTextField), for: .editingChanged)
    }
  }
  
  func bindingView() {
    let action = UIAction { _ in
      // TODO: - 업데이트 메서드
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
