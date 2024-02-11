//
//  SignUpFlowChildControllerDelegate.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

protocol SignUpFlowChildControllerDelegate: AnyObject {
  func signUpFlowChild(to controller: UIViewController, didSuccess item: Any)
  func signUpFlowChild(to controller: UIViewController, didFailure error: Error)
}

protocol SignUpChildFlowViewController: UIViewController {
  var signUpDelegate: SignUpFlowChildControllerDelegate? { get set }
}
