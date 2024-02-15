//
//  GenerateBasicCardViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

protocol GenerateBasicCardDelegate: AnyObject {
  func generateBasicCard(to controller: UIViewController, didSuccessUpdate card: BusinessCard)
}

final class GenerateBasicCardViewController: UIViewController {
  weak var delegate: GenerateBasicCardDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .gray
  }
}
