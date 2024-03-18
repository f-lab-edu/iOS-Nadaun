//
//  DropCardViewModel.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

enum DropCardAction {
  case startShare
}

class DropCardViewModel {
  private let shareCard: BusinessCard
  private let shareCardRepository: ShareCardRepository
  
  private var receivedCard: BusinessCard? {
    didSet {
      if let receivedCard = receivedCard {
        didReceiveCard?(receivedCard)
      }
    }
  }
  
  var didReceiveCard: ((BusinessCard) -> Void)?
  
  init(shareCard: BusinessCard, shareCardRepository: ShareCardRepository) {
    self.shareCard = shareCard
    self.shareCardRepository = shareCardRepository
  }
  
  func bind(with action: DropCardAction) {
    switch action {
      case .startShare:
        shareCardRepository.shareCards(with: shareCard.cardID) { [weak self] in
          self?.receivedCard = $0
        }
    }
  }
}
