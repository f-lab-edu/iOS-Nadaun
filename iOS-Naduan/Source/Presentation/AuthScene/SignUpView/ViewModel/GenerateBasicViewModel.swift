//
//  GenerateBasicViewModel.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

enum GenerateBasicAction {
  case changeCompany(String)
  case changeDepartment(String)
  case generateCard
}

class GenerateBasicViewModel {
  private let profile: UserProfile
  private let repository: UserRepository
  
  private var company: String? {
    didSet {
      
    }
  }
  
  private var department: String? {
    didSet {
      
    }
  }
  
  private var position: String? {
    didSet {
      
    }
  }
  
  var generateCardSuccess: (() -> Void)?
  var generateCardFailure: ((Error) -> Void)?
  
  init(profile: UserProfile, repository: UserRepository) {
    self.profile = profile
    self.repository = repository
  }
  
  func bind(action: GenerateBasicAction) {
    switch action {
      case .changeCompany(let company):
        self.company = company
        return
      case .changeDepartment(let department):
        self.department = department
        return
      case .generateCard:
        // TODO: - Generate Card Method Call
        return
    }
  }
}
