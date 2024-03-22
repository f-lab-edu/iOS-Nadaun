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
    label.font = .pretendardFont(to: .C1R)
    label.layer.cornerRadius = 8
    label.layer.backgroundColor = UIColor.gray02.cgColor
    label.text = TextConstants.shareExplanation
    return label
  }()
  
  private let cardView: CardView = {
    let cardView = CardView()
    cardView.layer.cornerRadius = 8
    cardView.layer.backgroundColor = UIColor.white.cgColor
    cardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
    cardView.layer.shadowRadius = 8
    cardView.layer.shadowOpacity = 1
    cardView.layer.shadowOffset = CGSize(width: 1, height: 1)
    cardView.isHidden = true
    return cardView
  }()
  
  private let viewModel: DropCardViewModel
  
  init(viewModel: DropCardViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable, message: "스토리보드로 생성할 수 없습니다.")
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
    animationBackgroundView.play()
    binding()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    viewModel.bind(with: .startShare)
  }
}

private extension DropCardViewController {
  func binding() {
    viewModel.didReceiveCard = { [weak self] card in
      print(card)
      DispatchQueue.main.async {
        self?.titleLabel.isHidden = true
        self?.animationBackgroundView.stop()
        self?.animationBackgroundView.isHidden = true
        self?.explanationLabel.isHidden = true
        self?.shareImage.isHidden = true
        self?.cardView.isHidden = false
        self?.cardView.bind(to: card)
      }
    }
  }
}

private extension DropCardViewController {
  func configureUI() {
    view.backgroundColor = .systemBackground
    
    configureHierarchy()
    makeConstraints()
  }
  
  func configureHierarchy() {
    [
      titleLabel, animationBackgroundView, shareImage, explanationLabel,
      cardView
    ].forEach(view.addSubview)
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
      $0.bottom(equalTo: view.safeAreaLayoutGuide.bottomAnchor, padding: 24)
    }
    
    cardView.attach {
      $0.centerXAnchor.constraint(equalTo: view.centerXAnchor)
      $0.centerYAnchor.constraint(equalTo: view.centerYAnchor)
      $0.leading(equalTo: view.safeAreaLayoutGuide.leadingAnchor, padding: 32)
      $0.trailing(equalTo: view.safeAreaLayoutGuide.trailingAnchor, padding: 32)
      $0.height(equalTo: view.safeAreaLayoutGuide.heightAnchor, multi: 0.7)
    }
  }
}

private extension DropCardViewController {
  enum TextConstants {
    static let shareExplanation: String = """
    해당 기능은 UWB 기능을 지원하는 기기에서만 가능합니다. 지원되지 않는 기기는 QR 코드 화면이 나옵니다. 두 기기 모두 화면에 머물러야 공유가 가능합니다.
    
    지원 기기 : iPhone 11 이후 모델 (SE 기종 제외)
    """
  }
}
