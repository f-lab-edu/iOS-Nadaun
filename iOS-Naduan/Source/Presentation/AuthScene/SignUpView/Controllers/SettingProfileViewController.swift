//
//  SettingProfileViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

final class SettingProfileViewController: UIViewController, SignUpChildFlowViewController {
  weak var signUpDelegate: SignUpFlowChildControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBlue
  }
}
