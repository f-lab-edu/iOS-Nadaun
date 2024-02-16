//
//  AgreeTermViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

// MARK: - AgreeTermDelegate
protocol AgreeTermDelegate: AnyObject {
  func agreeTerm(isComplete controller: UIViewController)
}

// MARK: - AgreeTermViewController
class AgreeTermViewController: UIViewController {
  // MARK: - AgreeDocument
  private enum AgreeDocument: CustomStringConvertible, CaseIterable {
    case term
    case privacy
    
    var description: String {
      switch self {
        case .term:     return TextConstants.termAgreeComment
        case .privacy:  return TextConstants.privacyAgreeComment
      }
    }
    
    var url: String {
      switch self {
        case .term:     return TextConstants.termURLString
        case .privacy:  return TextConstants.privacyURLString
      }
    }
  }
  
  // MARK: - View Properties
  private let titleLabel = SignUpTitleLabel()
  
  private let nextFlowButton: UIButton = {
    var container = AttributeContainer()
    container.font = UIFont.pretendardFont(weight: .bold, size: 18)
    
    let inset = NSDirectionalEdgeInsets(top: 10, leading: .zero, bottom: 40, trailing: .zero)
    var configuration = UIButton.Configuration.daunStyle(with: .basic)
    configuration.background.cornerRadius = .zero
    configuration.contentInsets = inset
    configuration.setTitle(to: TextConstants.nextFlow, with: container)
    
    let button = UIButton(configuration: configuration)
    button.automaticallyUpdatesConfiguration = false
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
  
  // MARK: - Business Logic Properties
  weak var delegate: AgreeTermDelegate?
  private let viewModel: AgreeTermViewModel
  
  // MARK: - Initializer
  init(viewModel: AgreeTermViewModel) {
    self.viewModel = viewModel
    
    self.titleLabel.setTextWithLineHeight(text: TextConstants.title, lineHeight: 26)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    configureUI()
    
    binding()
  }
}

// MARK: UITableViewDataSource Methods
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
  func binding() {
    addActions()
    viewModel.isSelectAll = { [weak self] isSelected in
      self?.nextFlowButton.isEnabled = isSelected
    }
  }
  
  func addActions() {
    let nextAction = UIAction { [weak self] _ in
      // TODO: - Action 추가하기
      guard let self = self else { return }
      
      self.delegate?.agreeTerm(isComplete: self)
    }
    nextFlowButton.addAction(nextAction, for: .touchUpInside)
    nextFlowButton.configurationUpdateHandler = updateNextButtonConfiguration
  }
  
  func updateNextButtonConfiguration(_ button: UIButton) {
    switch button.state {
      case .disabled:
        button.configuration?.background.backgroundColor = .disable
      case .normal:
        button.configuration?.background.backgroundColor = .accent
      default:
        return
    }
  }
}

// MARK: - Configure UI Methods
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

// MARK: - TextConstants
private extension AgreeTermViewController {
  enum TextConstants {
    static let title: String = "만나서 반가워요 :)\n가입약관을 확인해주세요."
    static let nextFlow: String = "다음"
    
    static let termAgreeComment: String = "다운 서비스 이용 동의 (필수)"
    static let privacyAgreeComment: String = "개인정보 수집 및 이용 안내 (필수)"
    static let termURLString: String = "https://gyoungmin.notion.site/3ece9fe63ae945cd80cc567bef309146?pvs=4"
    static let privacyURLString: String = "https://gyoungmin.notion.site/fbf1b6f0bad84b96990c7d65a6bcea77?pvs=4"
  }
}
