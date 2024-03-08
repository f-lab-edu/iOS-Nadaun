//
//  MyCardViewModel.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

enum MyCardAction {
  case fetchCards
}

enum RenderState {
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
  
  private var renderState: RenderState = .loading {
    didSet {
      didChangeRenderState?(renderState)
    }
  }
  
  var didChangeRenderState: ((RenderState) -> Void)?
  var fetchedCards: (([BusinessCard]) -> Void)?
  
  init(cardRepository: BusinessCardRepository) {
    self.cardRepository = cardRepository
  }
  
  func bind(_ action: MyCardAction) {
    switch action {
      case .fetchCards:
        renderState = .loading
        fetchMyCards()
    }
  }
}

private extension MyCardViewModel {
  func fetchMyCards() {
    cardRepository.fetchCards { [weak self] result in
      switch result {
        case .success(let fetchedCards):
          self?.cards = fetchedCards
        case .failure(let error):
          return
      }
      self?.renderState = .complete
    }
  }
}
