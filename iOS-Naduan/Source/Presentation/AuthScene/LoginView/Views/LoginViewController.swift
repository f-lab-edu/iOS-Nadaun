//
//  LoginViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

final class LoginViewController: UIViewController {
  private let rectangleView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.accent
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let logoLabel: UILabel = {
    let label = UILabel()
    label.text = "똑똑하고\n나다운\n명함"
    label.font = .systemFont(ofSize: 48, weight: .bold)
    label.textColor = .accent
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
  }
}

private extension LoginViewController {
  func configureUI() {
    view.backgroundColor = .systemBackground
    
    configureHierarchy()
    makeConstraints()
  }
  
  func configureHierarchy() {
    [rectangleView, logoLabel].forEach(view.addSubview)
  }
  
  func makeConstraints() {
    let safeArea = view.safeAreaLayoutGuide
    
    NSLayoutConstraint.activate([
      rectangleView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 64),
      rectangleView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
      rectangleView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -64),
      rectangleView.heightAnchor.constraint(equalToConstant: 20),
      
      logoLabel.leadingAnchor.constraint(equalTo: rectangleView.leadingAnchor),
      logoLabel.topAnchor.constraint(equalTo: rectangleView.bottomAnchor, constant: 16),
      logoLabel.trailingAnchor.constraint(equalTo: rectangleView.trailingAnchor)
    ])
  }
}
