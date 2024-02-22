//
//  SettingProfileViewModel.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

// MARK: - Setting Profile Action
enum SettingProfileAction {
  case editName(String)
  case editEmail(String)
  case updateProfile
}

// MARK: - Setting Profile ViewModel
class SettingProfileViewModel {
  // MARK: - Business Logic Properties
  private let userRepository: UserRepository
  
  // MARK: - Binding Properties
  private var name: String? {
    didSet {
      didChangeName?(name)
      isVerifyAllFormat?(name?.isEmpty == false && verifyEmailFormat())
    }
  }
  
  private var email: String? {
    didSet {
      didChangeEmail?(email)
      isVerifyAllFormat?(name?.isEmpty == false && verifyEmailFormat())
    }
  }
  
  // 사용자 정보 변경 속성
  var didChangeName: ((String?) -> Void)?
  var didChangeEmail: ((String?) -> Void)?
  
  // 버튼 사용 가능성 속성
  var isVerifyAllFormat: ((Bool) -> Void)?
  
  // 프로필 업데이트 결과 속성
  var updateProfileSuccess: ((UserProfile) -> Void)?
  var errorOccur: ((String) -> Void)?
  
  // MARK: - Initializer
  init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }
  
  // MARK: - Binding Methods
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

// MARK: - Upload Profile Methods
private extension SettingProfileViewModel {
  func uploadProfile() {
    let userProfile = UserProfile(nickName: name, email: email)
    userRepository.createUserProfile(to: userProfile) { [weak self] result in
      switch result {
        case .success:
          self?.updateProfileSuccess?(userProfile)
        case .failure(let error):
          self?.errorOccur?(error.description)
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
