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
  case updateProfile
}

class SettingProfileViewModel {
  typealias FormatCheckFormat = (isNameFormat: Bool, isPhoneFormat: Bool, isEmailFormat: Bool)
  private let userRepository: UserRepository
  private var name: String? {
    didSet {
      didChangeName?(name)
      verifyNameFormat(name)
    }
  }
  
  private var phoneNumber: String? {
    didSet {
      didChangePhoneNumber?(phoneNumber)
      verifyPhoneFormat(phoneNumber)
    }
  }
  
  private var email: String? {
    didSet {
      didChangeEmail?(email)
      verifyEmailFormat(email)
    }
  }
  
  private var position: String? {
    didSet {
      didChangePosition?(position)
    }
  }
  
  private var checkedAllFormat: FormatCheckFormat {
    didSet {
      let result = (checkedAllFormat.isNameFormat && checkedAllFormat.isPhoneFormat && checkedAllFormat.isEmailFormat)
      isEnableNextButton?(result)
    }
  }
  
  var didChangeName: ((String?) -> Void)?
  var didChangePhoneNumber: ((String?) -> Void)?
  var didChangeEmail: ((String?) -> Void)?
  var didChangePosition: ((String?) -> Void)?
  
  var isVerifyNameFormat: ((Bool) -> Void)?
  var isVerifyPhoneFormat: ((Bool) -> Void)?
  var isVerifyEmailFormat: ((Bool) -> Void)?
  
  var isEnableNextButton: ((Bool) -> Void)?
  var successUpdateProfile: ((UserProfile) -> Void)?
  
  init(userRepository: UserRepository) {
    self.userRepository = userRepository
    self.checkedAllFormat = (false, false, false)
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
        
      case .updateProfile:
        uploadProfile()
        return
    }
  }
}

private extension SettingProfileViewModel {
  func uploadProfile() {
    let userProfile = UserProfile(nickName: name, email: email, phoneNumber: phoneNumber, position: position)
    userRepository.updateUserProfile(to: userProfile) { result in
      switch result {
        case .success:
          print("UPLOAD PROFILE SUCCESS")
          return
        case .failure:
          print("UPLOAD PROFILE FAILURE")
          return
      }
    }
  }
}

// MARK: - Profile Formatting Method
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
  
  func verifyNameFormat(_ text: String?) {
    let result = name != nil && (name?.isEmpty == false)
    checkedAllFormat.isNameFormat = result
    isVerifyNameFormat?(result)
  }
  
  func verifyPhoneFormat(_ text: String?) {
    var result: Bool = false
    
    if let text = text {
      let regex = "^01[0-1, 7]-[0-9]{3,4}-[0-9]{3,4}"
      result = (text.range(of: regex, options: .regularExpression) != nil)
    }
    
    checkedAllFormat.isPhoneFormat = result
    isVerifyPhoneFormat?(result)
  }
  
  func verifyEmailFormat(_ text: String?) {
    var result: Bool = false
    
    if let text = text {
      let regex = "^([a-zA-Z0-9._-])+@[a-zA-Z0-9.-]+.[a-zA-Z]{3,20}$"
      result = (text.range(of: regex, options: .regularExpression) != nil)
    }
    
    checkedAllFormat.isEmailFormat = result
    isVerifyEmailFormat?(result)
  }
}
