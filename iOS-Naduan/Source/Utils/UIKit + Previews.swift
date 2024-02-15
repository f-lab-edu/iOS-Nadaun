//
//  UIKit + Previews.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

#if DEBUG

import SwiftUI

public struct UIViewPreview<View: UIView>: UIViewRepresentable {
  public let view: View
  
  public init(_ builder: () -> View) {
    self.view = builder()
  }
  
  public func makeUIView(context: Context) -> UIView {
    return view
  }
  
  public func updateUIView(_ uiView: UIView, context: Context) {
    view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
  }
}

#endif
