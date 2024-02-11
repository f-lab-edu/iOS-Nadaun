//
//  AgreeTermViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

class AgreeTermViewController: UIViewController {
  weak var signUpDelegate: SignUpFlowChildControllerDelegate?
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendardFont(to: .B1M)
    label.textColor = .accent
    label.numberOfLines = .zero
    label.setTextWithLineHeight(text: "만나서 반가워요 :)\n가입약관을 확인해주세요.", lineHeight: 26)
    return label
  }()
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
  }
}

private extension AgreeTermViewController {
  func configureUI() {
    view.backgroundColor = .systemBackground
    
    configureHierarchy()
    makeConstraints()
  }
  
  func configureHierarchy() {
    [titleLabel].forEach(view.addSubview)
  }
  
  func makeConstraints() {
    titleLabel.attach {
      $0.leading(equalTo: view.safeAreaLayoutGuide.leadingAnchor, padding: 20)
      $0.trailing(equalTo: view.safeAreaLayoutGuide.trailingAnchor, padding: 20)
      $0.top(equalTo: view.safeAreaLayoutGuide.topAnchor)
    }
  }
}
