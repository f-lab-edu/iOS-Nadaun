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
  private let nextFlowButton = SignUpNextButton(title: "완료", isEnable: false) { button in
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
  
  private let companyLabel = SignUpTextField(type: .company, to: "회사")
  private let departmentLabel = SignUpTextField(type: .department, to: "부서")
  private let positionLabel = SignUpTextField(type: .position, to: "직책")
  
  init() {
    self.titleLabel.setTextWithLineHeight(text: "다운에서\n첫번째 명함을 완성해보세요.", lineHeight: 26)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
  }
}

private extension GenerateBasicCardViewController {
  func configureUI() {
    view.backgroundColor = .systemBackground

    configureHierarchy()
    makeConstraints()
  }
  
  func configureHierarchy() {
    [titleLabel, cardInformationScrollView, nextFlowButton].forEach(view.addSubview)
    [informationContentView].forEach(cardInformationScrollView.addSubview)
    [companyLabel, departmentLabel, positionLabel].forEach(informationContentView.addArrangedSubview)
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
