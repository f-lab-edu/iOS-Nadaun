//
//  AgreeTermViewModel.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

class AgreeTermViewModel {
  enum AgreeTermAction {
    case selectTerm
    case selectPrivacy
  }
  
  private var didSelectTerm: Bool = false {
    didSet {
      didSelectAll?(didSelectTerm == true && didSelectPrivacy == true)
    }
  }
  
  private var didSelectPrivacy: Bool = false {
    didSet {
      didSelectAll?(didSelectTerm == true && didSelectPrivacy == true)
    }
  }
  
  var didSelectAll: ((Bool) -> Void)?
  
  func bind(action: AgreeTermAction) {
    switch action {
      case .selectTerm:
        didSelectTerm.toggle()
      case .selectPrivacy:
        didSelectPrivacy.toggle()
    }
  }
}
