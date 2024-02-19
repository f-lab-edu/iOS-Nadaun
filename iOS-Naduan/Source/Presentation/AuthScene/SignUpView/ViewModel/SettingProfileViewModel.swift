//
//  SettingProfileViewModel.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

enum SettingProfileAction {
  case editName(String)
  case editEmail(String)
  case updateProfile
}

class SettingProfileViewModel {
  typealias FormatCheckFormat = (isNameFormat: Bool, isPhoneFormat: Bool, isEmailFormat: Bool)
  private let userRepository: UserRepository
  private var name: String? {
    didSet {
      didChangeName?(name)
      isEnableNextButton?(name?.isEmpty == false && verifyEmailFormat())
    }
  }
  
  private var email: String? {
    didSet {
      didChangeEmail?(email)
      isEnableNextButton?(name?.isEmpty == false && verifyEmailFormat())
    }
  }
  
  var didChangeName: ((String?) -> Void)?
  var didChangeEmail: ((String?) -> Void)?
  
  var isEnableNextButton: ((Bool) -> Void)?
  
  var updateProfileSuccess: ((UserProfile) -> Void)?
  var updateProfileFailure: ((Error) -> Void)?
  
  init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }
  
  func bind(to action: SettingProfileAction) {
    switch action {
      case .editName(let name):
        self.name = name
        return
        
      case .editEmail(let email):
        self.email = email
        return
        
      case .updateProfile:
        uploadProfile()
        return
    }
  }
}

private extension SettingProfileViewModel {
  func uploadProfile() {
    let userProfile = UserProfile(nickName: name, email: email)
    userRepository.updateUserProfile(to: userProfile) { [weak self, userProfile] result in
      switch result {
        case .success:
          self?.updateProfileSuccess?(userProfile)
        case .failure(let error):
          self?.updateProfileFailure?(error)
      }
    }
  }
}

// MARK: - Profile Formatting Method
private extension SettingProfileViewModel {
  func verifyEmailFormat() -> Bool {
    if let email = email {
      let regex = "^([a-zA-Z0-9._-])+@[a-zA-Z0-9.-]+.[a-zA-Z]{3,20}$"
      return (email.range(of: regex, options: .regularExpression) != nil)
    }
    
    return false
  }
}
