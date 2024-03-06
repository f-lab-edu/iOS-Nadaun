//
//  BusinessCard.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

struct BusinessCard: Encodable {
  let id: String
  let name: String
  let email: String
  var company: String?
  var department: String?
  var position: String?
  
  static func make(
    profile: UserProfile,
    company: String? = nil,
    department: String? = nil,
    position: String? = nil
  ) -> Self {
    return .init(
      id: profile.ID ?? "",
      name: profile.nickName ?? "",
      email: profile.email ?? "",
      company: company,
      department: department,
      position: position
    )
  }
}
