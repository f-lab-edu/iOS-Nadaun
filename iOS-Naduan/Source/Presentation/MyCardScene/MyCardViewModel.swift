//
//  MyCardViewModel.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

enum MyCardAction {
  case fetchCards
}

class MyCardViewModel {
  private let cardRepository: BusinessCardRepository
  
  private var cards: [BusinessCard] = []
  
  var fetchedCards: (([BusinessCard]) -> Void)?
  
  init(cardRepository: BusinessCardRepository) {
    self.cardRepository = cardRepository
  }
  
  func bind(_ action: MyCardAction) {
    switch action {
      case .fetchCards:
        print("FETCH CARD ACTION")
    }
  }
}
