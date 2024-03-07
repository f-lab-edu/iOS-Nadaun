//
//  MyCardViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

final class MyCardViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
  }
}

private extension MyCardViewController {
  func configureUI() {
    view.backgroundColor = .systemBackground
    
    configureNavigationBar()
    
    configureHierarchy()
    makeConstraints()
  }
  
  func configureNavigationBar() {
    let titleLabel = UILabel()
    titleLabel.text = "내 명함"
    titleLabel.font = .pretendardFont(to: .H3B)
    titleLabel.textColor = .accent
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
  }
  
  func configureHierarchy() {
    
  }
  
  func makeConstraints() {
    
  }
}
