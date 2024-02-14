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
    
    var url: String {
      switch self {
        case .term:
          return "https://gyoungmin.notion.site/3ece9fe63ae945cd80cc567bef309146?pvs=4"
        case .privacy:
          return "https://gyoungmin.notion.site/fbf1b6f0bad84b96990c7d65a6bcea77?pvs=4"
      }
    }
  }
  
  // View Property
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendardFont(to: .B1M)
    label.textColor = .accent
    label.numberOfLines = .zero
    return label
  }()
  
  private let nextFlowButton: UIButton = {
    var attributes = AttributeContainer()
    attributes.font = UIFont.pretendardFont(weight: .bold, size: 18)
    
    var configuration = UIButton.Configuration.filled()
    configuration.baseBackgroundColor = UIColor.accent
    configuration.background.cornerRadius = .zero
    configuration.attributedTitle = AttributedString("다음", attributes: attributes)
    configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: .zero, bottom: 40, trailing: .zero)
    
    let button = UIButton(configuration: configuration)
    button.automaticallyUpdatesConfiguration = false
    
    button.configurationUpdateHandler = { button in
      switch button.state {
        case .disabled:
          button.configuration?.background.backgroundColor = .disable
        case .normal:
          button.configuration?.background.backgroundColor = .accent
        default:
          return
      }
    }
    button.isEnabled = false
    return button
  }()
  
  private let tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.register(AgreeTermTableCell.self, forCellReuseIdentifier: AgreeTermTableCell.reuseIdentifier)
    tableView.alwaysBounceVertical = false
    tableView.separatorStyle = .none
    tableView.allowsSelection = false
    tableView.estimatedRowHeight = .zero
    return tableView
  }()
  
  // Business Logic Properties
  private let viewModel: AgreeTermViewModel
  
  init(title: String, viewModel: AgreeTermViewModel) {
    self.viewModel = viewModel
    self.titleLabel.setTextWithLineHeight(text: title, lineHeight: 26)
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    
    binding()
  }
}

// MARK: UITableViewDataSource
extension AgreeTermViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return AgreeDocument.allCases.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: AgreeTermTableCell = tableView.dequeueReusableCell(with: indexPath)
    let documents = AgreeDocument.allCases[indexPath.row]
    
    cell.bind(to: documents.description, url: documents.url) { [weak self] in
      switch documents {
        case .term:
          self?.viewModel.bind(action: .selectTerm)
        case .privacy:
          self?.viewModel.bind(action: .selectPrivacy)
      }
    }
    return cell
  }
}

// MARK: Binding Method
private extension AgreeTermViewController {
  func addActions() {
    let nextAction = UIAction { [weak self] _ in
      // TODO: - Action 추가하기
    }
    nextFlowButton.addAction(nextAction, for: .touchUpInside)
  }
  
  func binding() {
    addActions()
    viewModel.isSelectAll = { [weak self] isSelected in
      self?.nextFlowButton.isEnabled = isSelected
    }
  }
}

private extension AgreeTermViewController {
  func configureUI() {
    view.backgroundColor = .systemBackground
    
    configureHierarchy()
    makeConstraints()
  }
  
  func configureHierarchy() {
    [titleLabel, nextFlowButton, tableView].forEach(view.addSubview)
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
    
    tableView.attach {
      $0.top(equalTo: titleLabel.bottomAnchor, padding: 32)
      $0.leading(equalTo: titleLabel.leadingAnchor)
      $0.trailing(equalTo: titleLabel.trailingAnchor)
      $0.bottom(equalTo: nextFlowButton.topAnchor)
    }
  }
}