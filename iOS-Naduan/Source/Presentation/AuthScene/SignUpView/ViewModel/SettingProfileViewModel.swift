//
//  SettingProfileViewModel.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

enum SettingProfileAction {
  case editName(String)
  case editPhoneNumber(String)
  case editEmail(String)
  case editPosition(String)
  case updateProfile
}

class SettingProfileViewModel {
  private let userRepository: UserRepository
  private var userProfile: UserProfile {
    didSet {
      nameUpdate?(userProfile.nickName)
      phoneNumberUpdate?(userProfile.phoneNumber)
    }
  }
  
  var nameUpdate: ((String?) -> Void)?
  var phoneNumberUpdate: ((String?) -> Void)?
  
  var successUpdateProfile: ((UserProfile) -> Void)?
  
  init(userRepository: UserRepository, userProfile: UserProfile) {
    self.userRepository = userRepository
    self.userProfile = userProfile
  }
  
  func bind(to action: SettingProfileAction) {
    switch action {
      case .editName(let name):
        userProfile.nickName = name
        return
      case .editPhoneNumber(let number):
        let newNumber = updatePhoneNumber(to: number)
        userProfile.phoneNumber = newNumber
        return
      case .editEmail(let email):
        userProfile.email = email
        return
      case .editPosition(let positionName):
        userProfile.position = positionName
        return
      case .updateProfile:
        return
    }
  }
  

}

private extension SettingProfileViewModel {
  func updatePhoneNumber(to number: String) -> String {
    var number = number
    guard let prevText = userProfile.phoneNumber else { return number }
    
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
