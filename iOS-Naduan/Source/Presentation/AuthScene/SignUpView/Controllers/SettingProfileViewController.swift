//
//  SettingProfileViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

final class SettingProfileViewController: UIViewController {
  private let profileInputScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    return scrollView
  }()
  
  private let scrollContentView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fillProportionally
    return stackView
  }()
  
  override init(title: String) {
    super.init(title: title)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func configureHierarchy() {
    super.configureHierarchy()
    
    [profileInputScrollView].forEach(view.addSubview)
    [scrollContentView].forEach(profileInputScrollView.addSubview)
  }
  
  override func makeConstraints() {
    super.makeConstraints()
    
    profileInputScrollView.attach {
      $0.top(equalTo: titleLabel.bottomAnchor, padding: 12)
      $0.leading(equalTo: titleLabel.leadingAnchor)
      $0.trailing(equalTo: titleLabel.trailingAnchor)
      $0.bottom(equalTo: nextFlowButton.topAnchor, padding: 12)
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
