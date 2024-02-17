//
//  SettingProfileViewModel.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

enum SettingProfileAction {
  case editName(String)
  case editPhone(String)
  case editEmail(String)
  case editPosition(String)
  case updateProfile(profile: UserProfile)
}

class SettingProfileViewModel {
  private let userRepository: UserRepository
  private var name: String? {
    didSet {
      isVerifyNameFormat?(name != nil && (name?.isEmpty == false))
      didChangeName?(name)
    }
  }
  
  private var phoneNumber: String? {
    didSet {
      didChangePhoneNumber?(phoneNumber)
      isVerifyPhoneFormat?(verifyPhoneFormat(phoneNumber))
    }
  }
  
  private var email: String? {
    didSet {
      didChangeEmail?(email)
      isVerifyEmailFormat?(verifyEmailFormat(email))
    }
  }
  
  private var position: String? {
    didSet {
      didChangePosition?(position)
    }
  }
  
  var didChangeName: ((String?) -> Void)?
  var didChangePhoneNumber: ((String?) -> Void)?
  var didChangeEmail: ((String?) -> Void)?
  var didChangePosition: ((String?) -> Void)?
  
  var isVerifyNameFormat: ((Bool) -> Void)?
  var isVerifyPhoneFormat: ((Bool) -> Void)?
  var isVerifyEmailFormat: ((Bool) -> Void)?
  
  var successUpdateProfile: ((UserProfile) -> Void)?
  
  init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }
  
  func bind(to action: SettingProfileAction) {
    switch action {
      case .editName(let name):
        self.name = name
        return
        
      case .editPhone(let phone):
        let newPhone = updatePhoneNumber(to: phone)
        self.phoneNumber = newPhone
        return
        
      case .editEmail(let email):
        self.email = email
        return
        
      case .editPosition(let postion):
        self.position = postion
        return
        
      case .updateProfile(let profile):
        return
    }
  }
}

private extension SettingProfileViewModel {
  func updatePhoneNumber(to number: String) -> String {
    var number = number
    guard let prevText = phoneNumber else { return number }
    
    let isRemove = (prevText.count < number.count)
    let isDashIndex = (number.count == 4 || number.count == 9)
    
    if isRemove && isDashIndex {
      let last = number.removeLast()
      number.append("-")
      number.append(last)
      return number
    }
    
    if (isRemove == false) && isDashIndex {
      number.removeLast()
      return number
    }
    
    return number
  }
  
  func verifyEmailFormat(_ text: String?) -> Bool {
    guard let text = text else { return false }
    
    let regex = "^([a-zA-Z0-9._-])+@[a-zA-Z0-9.-]+.[a-zA-Z]{3,20}$"
    return text.range(of: regex, options: .regularExpression) != nil
  }
  
  func verifyPhoneFormat(_ text: String?) -> Bool {
    guard let text = text else { return false }
    
    let regex = "^01[0-1, 7]-[0-9]{3,4}-[0-9]{3,4}"
    return text.range(of: regex, options: .regularExpression) != nil
  }
}
