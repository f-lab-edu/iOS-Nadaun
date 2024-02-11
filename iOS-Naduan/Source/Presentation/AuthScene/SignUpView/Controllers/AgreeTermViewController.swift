//
//  AgreeTermViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

class AgreeTermViewController: UIViewController {
  // Private Type
  private enum AgreeDocument: CustomStringConvertible, CaseIterable {
    case term
    case privacy
    
    var description: String {
      switch self {
        case .term:
          return "다운 서비스 이용 동의 (필수)"
        case .privacy:
          return "개인정보 수집 및 이용 안내 (필수)"
      }
    }
  }
  
  // Delegate Property
  weak var signUpDelegate: SignUpFlowChildControllerDelegate?
  
  // View Property
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendardFont(to: .B1M)
    label.textColor = .accent
    label.numberOfLines = .zero
    label.setTextWithLineHeight(text: "만나서 반가워요 :)\n가입약관을 확인해주세요.", lineHeight: 26)
    return label
  }()
  
  private let tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.register(AgreeTermTableCell.self, forCellReuseIdentifier: AgreeTermTableCell.reuseIdentifier)
    tableView.alwaysBounceVertical = false
    tableView.separatorStyle = .none
    tableView.allowsSelection = false
    return tableView
  }()
  
  // Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    
    configureUI()
  }
}

// MARK: UITableViewDataSource
extension AgreeTermViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return AgreeDocument.allCases.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: AgreeTermTableCell = tableView.dequeueReusableCell(with: indexPath)
    let document = AgreeDocument.allCases[indexPath.row]
    cell.bind(to: document.description)
    return cell
  }
}

// MARK: Configure UI
private extension AgreeTermViewController {
  func configureUI() {
    view.backgroundColor = .systemBackground
    
    configureHierarchy()
    makeConstraints()
  }
  
  func configureHierarchy() {
    [titleLabel, tableView].forEach(view.addSubview)
  }
  
  func makeConstraints() {
    titleLabel.attach {
      $0.leading(equalTo: view.safeAreaLayoutGuide.leadingAnchor, padding: 20)
      $0.trailing(equalTo: view.safeAreaLayoutGuide.trailingAnchor, padding: 20)
      $0.top(equalTo: view.safeAreaLayoutGuide.topAnchor)
    }
    
    tableView.attach {
      $0.top(equalTo: titleLabel.bottomAnchor, padding: 32)
      $0.leading(equalTo: titleLabel.leadingAnchor)
      $0.trailing(equalTo: titleLabel.trailingAnchor)
      $0.bottom(equalTo: view.safeAreaLayoutGuide.bottomAnchor, padding: 50)
    }
  }
}
