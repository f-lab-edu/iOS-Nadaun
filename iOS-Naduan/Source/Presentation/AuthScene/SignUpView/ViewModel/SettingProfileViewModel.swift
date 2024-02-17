//
//  SettingProfileViewModel.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

enum SettingProfileAction {
  case editPhoneNumber(String)
  case updateProfile(profile: UserProfile)
}

class SettingProfileViewModel {
  private let userRepository: UserRepository
  private var phoneNumber: String? {
    didSet {
      phoneNumberUpdate?(phoneNumber)
    }
  }
  
  var phoneNumberUpdate: ((String?) -> Void)?
  var successUpdateProfile: ((UserProfile) -> Void)?
  
  init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }
  
  func bind(to action: SettingProfileAction) {
    switch action {
      case .editPhoneNumber(let number):
        let newNumber = updatePhoneNumber(to: number)
        phoneNumber = newNumber
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
}
