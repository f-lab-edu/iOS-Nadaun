//
//  SignUpNextButton.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

class SignUpNextButton: UIButton {
  convenience init(
    title: String,
    isEnable: Bool = false,
    updateHandler: UIButton.ConfigurationUpdateHandler? = nil
  ) {
    var container = AttributeContainer()
    container.font = UIFont.pretendardFont(weight: .bold, size: 18)
    
    let inset = NSDirectionalEdgeInsets(top: 10, leading: .zero, bottom: 40, trailing: .zero)
    var configuration = UIButton.Configuration.daunStyle(with: .basic)
    configuration.background.cornerRadius = .zero
    configuration.contentInsets = inset
    configuration.setTitle(to: title, with: container)
    self.init(configuration: configuration)
    
    isEnabled = isEnable
    automaticallyUpdatesConfiguration = false
    configurationUpdateHandler = updateHandler
  }
}
