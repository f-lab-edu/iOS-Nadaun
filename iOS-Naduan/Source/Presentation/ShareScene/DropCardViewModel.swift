//
//  DropCardViewModel.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

enum CardShareState {
  case sharing
  case success(BusinessCard)
  case failure
}

enum DropCardAction {
  case startShare
  case stopShare
}

class DropCardViewModel {
  private let shareCard: BusinessCard
  private let shareCardRepository: ShareCardRepository
  
  private var receivedCard: BusinessCard? {
    didSet {
      if let receivedCard = receivedCard {
        didChangeCardShareState?(.success(receivedCard))
      }
    }
  }
  
  var didReceiveCard: ((BusinessCard) -> Void)?
  var didChangeCardShareState: ((CardShareState) -> Void)?
  
  init(shareCard: BusinessCard, shareCardRepository: ShareCardRepository) {
    self.shareCard = shareCard
    self.shareCardRepository = shareCardRepository
  }
  
  func bind(with action: DropCardAction) {
    switch action {
      case .startShare:
        didChangeCardShareState?(.sharing)
        shareCardRepository.shareCards(with: shareCard) { [weak self] result in
          switch result {
            case .success(let card):
              self?.receivedCard = card
            case .failure:
              self?.didChangeCardShareState?(.failure)
          }
        }
      case .stopShare:
        shareCardRepository.stopShare()
    }
  }
}
