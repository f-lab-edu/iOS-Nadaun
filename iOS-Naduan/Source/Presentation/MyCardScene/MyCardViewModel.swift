//
//  MyCardViewModel.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

enum MyCardAction {
  case fetchCards
}

enum CardFetchState {
  case loading
  case complete
}

class MyCardViewModel {
  private let cardRepository: BusinessCardRepository
  
  private var cards: [BusinessCard] = [] {
    didSet {
      fetchedCards?(cards)
    }
  }
  
  private var cardFetchState: CardFetchState = .loading {
    didSet {
      didChangeFetchState?(cardFetchState)
    }
  }
  
  var didChangeFetchState: ((CardFetchState) -> Void)?
  var fetchedCards: (([BusinessCard]) -> Void)?
  
  init(cardRepository: BusinessCardRepository) {
    self.cardRepository = cardRepository
  }
  
  func bind(_ action: MyCardAction) {
    switch action {
      case .fetchCards:
        cardFetchState = .loading
        fetchMyCards()
    }
  }
}

private extension MyCardViewModel {
  func fetchMyCards() {
    cardRepository.fetchCards { [weak self] result in
      if case let .success(fetchedCards) = result {
        self?.cards = fetchedCards
      }
      
      self?.cardFetchState = .complete
    }
  }
}
