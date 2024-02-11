//
//  AgreeTermTableCell.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

class AgreeTermTableCell: UITableViewCell {
  private let checkButton: UIButton = {
    var configuration = UIButton.Configuration.plain()
    configuration.contentInsets = .zero
    configuration.image = UIImage(systemName: "circle")
    configuration.baseBackgroundColor = .clear
    let button = UIButton(configuration: configuration)
    button.configurationUpdateHandler = { button in
      switch button.state {
        case .selected:
          button.configuration?.image = UIImage(systemName: "checkmark.circle.fill")
        case .normal:
          button.configuration?.image = UIImage(systemName: "circle")
        default:
          return
      }
    }
    return button
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendardFont(to: .B2M)
    label.textColor = .black
    return label
  }()
  
  private let seeButton: UIButton = {
    var container = AttributeContainer()
    container.font = UIFont.pretendardFont(to: .B4R)
    
    var configuration = UIButton.Configuration.plain()
    configuration.background.backgroundColor = .clear
    configuration.baseForegroundColor = .body2
    configuration.attributedTitle = AttributedString("보기", attributes: container)
    let button = UIButton(configuration: configuration)
    return button
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bind(to title: String, url: String, action: @escaping () -> Void) {
    titleLabel.text = title
    
    let checkAction = UIAction { [weak self] _ in
      action()
      self?.checkButton.isSelected = (self?.checkButton.isSelected == true) ? false : true
    }
    checkButton.addAction(checkAction, for: .touchUpInside)
    
    let presentWebViewAction = UIAction { _ in
      guard let url = URL(string: url) else { return }
      
      UIApplication.shared.open(url)
    }
    seeButton.addAction(presentWebViewAction, for: .touchUpInside)
  }
  
  private func configureUI() {
    [checkButton, titleLabel, seeButton].forEach(contentView.addSubview)
    
    checkButton.attach {
      $0.leading(equalTo: contentView.leadingAnchor)
      $0.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
      $0.height(equalTo: 24)
      $0.width(equalTo: 24)
    }
    
    titleLabel.attach {
      $0.leading(equalTo: checkButton.trailingAnchor, padding: 8)
      $0.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    }
    
    seeButton.attach {
      $0.trailing(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor)
      $0.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    }
  }
}
