//
//  DropCardViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

class DropCardViewController: UIViewController {
  private let shareImage: UIImageView = {
    let imageView = UIImageView(image: .handShake)
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
  }
}

private extension DropCardViewController {
  func configureUI() {
    view.backgroundColor = .systemBackground
    
    configureHierarchy()
    makeConstraints()
  }
  
  func configureHierarchy() {
    [shareImage].forEach(view.addSubview)
  }
  
  func makeConstraints() {
    shareImage.attach {
      $0.centerYAnchor.constraint(equalTo: view.centerYAnchor)
      $0.centerXAnchor.constraint(equalTo: view.centerXAnchor)
      $0.height(equalTo: 250)
    }
  }
}
