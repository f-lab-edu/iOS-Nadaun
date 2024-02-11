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
    return UIButton(configuration: configuration)
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendardFont(to: .B2M)
    label.text = ""
    label.textColor = .black
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bind(to title: String) {
    titleLabel.text = title
  }
  
  func configureUI() {
    [checkButton, titleLabel].forEach(contentView.addSubview)
    
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
  }
}
