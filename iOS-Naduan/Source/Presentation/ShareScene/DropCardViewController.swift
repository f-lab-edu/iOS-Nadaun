//
//  DropCardViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

import Lottie

class DropCardViewController: UIViewController {
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendardFont(to: .H2B)
    label.textColor = .accent
    label.text = "핸드폰 뒷면을 마주쳐보세요."
    return label
  }()
  
  private let animationBackgroundView: LottieAnimationView = {
    let view = LottieAnimationView(name: "drop")
    view.backgroundBehavior = .continuePlaying
    view.loopMode = .loop
    view.animationSpeed = 0.5
    return view
  }()
  
  private let shareImage: UIImageView = {
    let imageView = UIImageView(image: .handShake)
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let explanationLabel: Label = {
    let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let label = Label(padding: padding)
    label.numberOfLines = .zero
    label.textColor = .disable
    label.text = TextConstants.shareExplanation
    label.font = .pretendardFont(to: .C1M)
    label.layer.cornerRadius = 8
    label.layer.backgroundColor = UIColor.gray01.cgColor
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
    animationBackgroundView.play()
  }
}

private extension DropCardViewController {
  func configureUI() {
    view.backgroundColor = .systemBackground
    
    configureHierarchy()
    makeConstraints()
  }
  
  func configureHierarchy() {
    [titleLabel, animationBackgroundView, shareImage, explanationLabel].forEach(view.addSubview)
  }
  
  func makeConstraints() {
    titleLabel.attach {
      $0.centerXAnchor.constraint(equalTo: view.centerXAnchor)
      $0.top(equalTo: view.safeAreaLayoutGuide.topAnchor, padding: 80)
    }
    
    animationBackgroundView.attach {
      $0.centerXAnchor.constraint(equalTo: view.centerXAnchor)
      $0.top(equalTo: view.safeAreaLayoutGuide.topAnchor)
      $0.leading(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
      $0.trailing(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
      $0.bottom(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    shareImage.attach {
      $0.centerYAnchor.constraint(equalTo: view.centerYAnchor)
      $0.centerXAnchor.constraint(equalTo: view.centerXAnchor)
      $0.height(equalTo: 250)
    }
    
    explanationLabel.attach {
      $0.leading(equalTo: view.leadingAnchor, padding: 24)
      $0.trailing(equalTo: view.trailingAnchor, padding: 24)
      $0.bottom(equalTo: view.safeAreaLayoutGuide.bottomAnchor, padding: 60)
    }
  }
}

private extension DropCardViewController {
  enum TextConstants {
    static let shareExplanation: String = """
    해당 기능은 제한적으로 지원하고 있습니다. 지원되지 않는 기기는 QR 코드 화면이 나옵니다. 두 기기 모두 화면에 머물러야 공유가 됩니다.
    """
  }
}
