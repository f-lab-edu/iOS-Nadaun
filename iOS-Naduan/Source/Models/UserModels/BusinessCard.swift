//
//  BusinessCard.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import Foundation

struct BusinessCard: Encodable, Decodable, Hashable {
  typealias CompanyInformation = (company: String?, department: String?, position: String?)
  
  let cardID: String
  let userID: String
  let name: String
  let email: String
  var company: String?
  var department: String?
  var position: String?
  var phone: String?
  
  var companyDescription: String {
    if let company = company {
      return company + " | " + (department ?? "")
    }
    
    return department ?? ""
  }
  
  static func make(
    cardID: String,
    profile: UserProfile,
    information: CompanyInformation
  ) -> Self {
    return .init(
      cardID: cardID,
      userID: profile.ID ?? "",
      name: profile.nickName ?? "",
      email: profile.email ?? "",
      company: information.company,
      department: information.department,
      position: information.position
    )
  }
}
