//
//  MyCardCollectionViewCell.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

// MARK: MyCardCollectionViewCell Delegate
protocol MyCardCollectionViewCellDelegate: AnyObject {
  func myCardCollectionViewCell(_ cell: MyCardCollectionViewCell, didSelectShare card: BusinessCard)
}

// MARK: MyCardCollectionViewCell
class MyCardCollectionViewCell: UICollectionViewCell {
  // MARK: - View Properties
  private let cardView = CardView()
  
  private var card: BusinessCard?
  private var gesture: UIPanGestureRecognizer?
  weak var delegate: MyCardCollectionViewCellDelegate?
  
  // MARK: - Initializer
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    cardView.reset()
  }
  
  // MARK: - Binding Method
  func bind(with card: BusinessCard) {
    self.card = card
    cardView.bind(to: card)
    
    let cardGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler))
    gesture = cardGesture
    gesture?.delegate = self
    addGestureRecognizer(cardGesture)
  }
  
  @objc private func panGestureHandler(_ sender: UIPanGestureRecognizer) {
    switch sender.state {
      case .changed:
        let translation = sender.translation(in: self)
        
        if translation.y > .zero { 
          sender.setTranslation(.zero, in: self)
          return
        }
        
        let changedY = self.center.y + translation.y
        self.center = CGPoint(x: center.x, y: changedY)
        sender.setTranslation(.zero, in: self)
      case .ended:
        guard let superview = superview, let card = card else { return }
        
        let isSendCard = (frame.minY + 100) < .zero
        
        UIView.animate(withDuration: 0.2) { [weak self] in
          self?.frame.origin.y = superview.frame.minY
        }
        
        self.delegate?.myCardCollectionViewCell(self, didSelectShare: card)
        
      default: break
    }
  }
}

extension MyCardCollectionViewCell: UIGestureRecognizerDelegate {
  override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    guard let gesture = gesture else { return false }
    return gesture.velocity(in: self).y.magnitude > gesture.velocity(in: self).x.magnitude
  }
}

private extension MyCardCollectionViewCell {
  func configureUI() {
    configureAttributes()
    configureHierarchy()
    makeConstraints()
  }
  
  func configureAttributes() {
    layer.cornerRadius = 8
    layer.backgroundColor = UIColor.white.cgColor
    layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
    layer.shadowRadius = 8
    layer.shadowOpacity = 1
    layer.shadowOffset = CGSize(width: 1, height: 1)
    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
  }
  
  func configureHierarchy() {
    contentView.addSubview(cardView)
  }
  
  func makeConstraints() {
    cardView.attach {
      $0.top(equalTo: contentView.topAnchor)
      $0.leading(equalTo: contentView.leadingAnchor)
      $0.trailing(equalTo: contentView.trailingAnchor)
      $0.bottom(equalTo: contentView.bottomAnchor)
    }
  }
}

private extension MyCardCollectionViewCell {
  enum Constants {
    static let shareActionID = UIAction.Identifier("SHARE")
  }
}
