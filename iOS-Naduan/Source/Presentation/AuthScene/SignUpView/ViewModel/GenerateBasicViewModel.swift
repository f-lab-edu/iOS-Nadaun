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
  var occurError: ((String) -> Void)?
  
  init(repository: BusinessCardRepository) {
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
        createNewCard()
        return
    }
  }
}

private extension GenerateBasicViewModel {
  func createNewCard() {
    let information = BusinessCardRepository.CompanyInformation(
      company: company,
      department: department,
      position: position
    )
    
    repository.createNewCard(to: information) { [weak self] result in
      switch result {
        case .success:
          self?.generateCardSuccess?()
        case .failure(let error):
          self?.occurError?(error.description)
      }
    }
  }
}
