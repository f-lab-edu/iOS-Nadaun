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
  
  private var cards: [BusinessCard] = [] {
    didSet {
      fetchedCards?(cards)
    }
  }
  
  var fetchedCards: (([BusinessCard]) -> Void)?
  
  init(cardRepository: BusinessCardRepository) {
    self.cardRepository = cardRepository
  }
  
  func bind(_ action: MyCardAction) {
    switch action {
      case .fetchCards:
        fetchMyCards()
    }
  }
}

private extension MyCardViewModel {
  func fetchMyCards() {
    cardRepository.fetchCards { result in
      switch result {
        case .success(let fetchedCards):
          self.cards = fetchedCards
        case .failure(let error):
          return
      }
    }
  }
}
