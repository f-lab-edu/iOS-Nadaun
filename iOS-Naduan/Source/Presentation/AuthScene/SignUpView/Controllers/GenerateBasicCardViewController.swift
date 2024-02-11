//
//  GenerateBasicCardViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

final class GenerateBasicCardViewController: UIViewController, SignUpChildFlowViewController {
  weak var signUpDelegate: SignUpFlowChildControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .gray
  }
}
