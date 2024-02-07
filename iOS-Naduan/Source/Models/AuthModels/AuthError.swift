//
//  AuthError.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import Foundation

enum AuthError: Error {
  case credentialMissing
  case IDTokenMissing
  case userMissing
  case unexpected
}
