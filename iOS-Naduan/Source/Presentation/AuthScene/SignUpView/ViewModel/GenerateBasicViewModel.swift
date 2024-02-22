//
//  GenerateBasicViewModel.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

enum GenerateBasicAction {
  case changeCompany(String)
  case changeDepartment(String)
  case changePosition(String)
  case generateCard
}

class GenerateBasicViewModel {
  private let profile: UserProfile
  private let repository: BusinessCardRepository
  
  private var company: String? {
    didSet {
      isVerifyAllFormat?(isEditOver)
    }
  }
  
  private var department: String? {
    didSet {
      isVerifyAllFormat?(isEditOver)
    }
  }
  
  private var position: String? {
    didSet {
      isVerifyAllFormat?(isEditOver)
    }
  }
  
  private var isEditOver: Bool {
    let isFillCompany = (company?.isEmpty == false)
    let isFillDepartment = (department?.isEmpty == false)
    let isFillPosition = (position?.isEmpty == false)
    return isFillCompany || isFillDepartment || isFillPosition
  }
  
  var isVerifyAllFormat: ((Bool) -> Void)?
  var generateCardSuccess: (() -> Void)?
  var generateCardFailure: ((Error) -> Void)?
  
  init(profile: UserProfile, repository: BusinessCardRepository) {
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
        
      case .changePosition(let position):
        self.position = position
        return
        
      case .generateCard:
        // TODO: - Generate Card Method Call
        return
    }
  }
}
