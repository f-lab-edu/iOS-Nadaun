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
      didFillAll?(isAllDataFilled)
    }
  }
  
  private var department: String? {
    didSet {
      didFillAll?(isAllDataFilled)
    }
  }
  
  private var position: String? {
    didSet {
      didFillAll?(isAllDataFilled)
    }
  }
  
  private var isAllDataFilled: Bool {
    let isCompanyFilled = (company?.isEmpty == false)
    let isDepartmentFilled = (department?.isEmpty == false)
    let isPositionFilled = (position?.isEmpty == false)
    return isCompanyFilled || isDepartmentFilled || isPositionFilled
  }
  
  var didFillAll: ((Bool) -> Void)?
  var didGenerateBasicCardSucceed: (() -> Void)?
  var didOccurError: ((String) -> Void)?
  
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
          self?.didGenerateBasicCardSucceed?()
        case .failure(let error):
          self?.didOccurError?(error.description)
      }
    }
  }
}
