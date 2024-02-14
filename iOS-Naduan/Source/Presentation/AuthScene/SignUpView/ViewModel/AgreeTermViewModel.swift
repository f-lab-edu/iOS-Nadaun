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
  
  private var isSelectTerm: Bool = false {
    didSet {
      isSelectAll?(isSelectTerm == true && isSelectPrivacy == true)
    }
  }
  
  private var isSelectPrivacy: Bool = false {
    didSet {
      isSelectAll?(isSelectTerm == true && isSelectPrivacy == true)
    }
  }
  
  var isSelectAll: ((Bool) -> Void)?
  
  func bind(action: AgreeTermAction) {
    switch action {
      case .selectTerm:
        isSelectTerm.toggle()
      case .selectPrivacy:
        isSelectPrivacy.toggle()
    }
  }
}