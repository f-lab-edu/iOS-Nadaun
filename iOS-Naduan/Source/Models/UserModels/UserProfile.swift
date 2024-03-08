//
//  UserProfile.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

struct UserProfile: Encodable, Decodable {
  var ID: String?
  var nickName: String?
  var email: String?
  
  mutating func updateID(with id: String) {
    self.ID = id
  }
}
