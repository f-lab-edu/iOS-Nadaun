//
//  UITableView + Extension.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

protocol Reusable: AnyObject {
  static var reuseIdentifier: String { get }
}

extension Reusable {
  static var reuseIdentifier: String {
    return String(describing: self)
  }
}

extension UITableViewCell: Reusable { }

extension UITableView {
  func dequeueReusableCell<T: UITableViewCell>(with indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
      return T()
    }
    
    return cell
  }
}

extension UICollectionViewCell: Reusable { }
