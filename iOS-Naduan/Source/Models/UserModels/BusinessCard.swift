//
//  BusinessCard.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

struct BusinessCard: Encodable {
  typealias CompanyInformation = (company: String?, department: String?, position: String?)
  
  let id: String
  let name: String
  let email: String
  var company: String?
  var department: String?
  var position: String?
  
  static func make(
    profile: UserProfile,
    information: CompanyInformation
  ) -> Self {
    return .init(
      id: profile.ID ?? "",
      name: profile.nickName ?? "",
      email: profile.email ?? "",
      company: information.company,
      department: information.department,
      position: information.position
    )
  }
}
