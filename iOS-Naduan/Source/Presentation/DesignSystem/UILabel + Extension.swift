//
//  UILabel + Extension.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

extension UILabel {
  func setTextWithLineHeight(text: String?, lineHeight: CGFloat) {
    guard let text = text else { return }
    
    let style = NSMutableParagraphStyle()
    style.maximumLineHeight = lineHeight
    style.minimumLineHeight = lineHeight
    
    let attributes: [NSAttributedString.Key: Any] = [
      .paragraphStyle: style,
      .baselineOffset: (lineHeight - font.lineHeight) / 4
    ]
    
    let attributeString = NSAttributedString(string: text, attributes: attributes)
    self.attributedText = attributeString
  }
}

class Label: UILabel {
  private let padding: UIEdgeInsets
  
  init(padding: UIEdgeInsets) {
    self.padding = padding
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func drawText(in rect: CGRect) {
    super.drawText(in: rect.inset(by: padding))
  }
  
  override var intrinsicContentSize: CGSize {
    var contentSize = super.intrinsicContentSize
    contentSize.width += padding.left + padding.right
    contentSize.height += padding.top + padding.bottom
    return contentSize
  }
}
