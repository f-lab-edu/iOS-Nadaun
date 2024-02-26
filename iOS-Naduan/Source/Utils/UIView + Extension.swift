//
//  UIView + Extension.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

extension UIView {
  var sceneDelegate: SceneDelegate? {
    guard let windowScene = self.window?.windowScene else { return nil }
    return windowScene.delegate as? SceneDelegate
  }
}
