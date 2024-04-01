//
//  QRShareView.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

class QRView: UIView {
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendardFont(to: .H2B)
    label.textColor = .accent
    label.text = "QR코드 스캐너로 읽어주세요."
    return label
  }()
  
  private let qrImageView = UIImageView()
  
  private let explanationLabel: Label = {
    let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let label = Label(padding: padding)
    label.numberOfLines = .zero
    label.textColor = .disable
    label.font = .pretendardFont(to: .C1R)
    label.layer.cornerRadius = 8
    label.layer.backgroundColor = UIColor.gray02.cgColor
    label.text = TextConstants.explainDescription
    return label
  }()
  
  private var filter = CIFilter(name: "CIQRCodeGenerator")
  
  init() {
    super.init(frame: .zero)
    
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func generateCode(_ value: String) {
    guard let filter = filter,
          let data = value.data(using: .isoLatin1, allowLossyConversion: false) else {
      return
    }
    
    filter.setValue(data, forKey: "inputMessage")
    filter.setValue("M", forKey: "inputCorrectionLevel")
    
    guard let ciImage = filter.outputImage else { return }
    let transformed = ciImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
    self.qrImageView.image = UIImage(ciImage: transformed)
  }
}

private extension QRView {
  func configureUI() {
    configureHierarchy()
    makeConstraints()
  }
  
  func configureHierarchy() {
    [titleLabel, qrImageView, explanationLabel]
      .forEach { addSubview($0) }
  }
  
  func makeConstraints() {
    titleLabel.attach {
      $0.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
      $0.top(equalTo: safeAreaLayoutGuide.topAnchor)
    }
    
    qrImageView.attach {
      $0.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
      $0.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
      $0.height(equalTo: 250)
      $0.width(equalTo: 250)
    }
    
    explanationLabel.attach {
      $0.leading(equalTo: safeAreaLayoutGuide.leadingAnchor, padding: 24)
      $0.trailing(equalTo: safeAreaLayoutGuide.trailingAnchor, padding: 24)
      $0.bottom(equalTo: safeAreaLayoutGuide.bottomAnchor)
    }
  }
}

private extension QRView {
  enum TextConstants {
    static let explainDescription: String = """
    해당 기능을 지원하지 않는 기기입니다. 상대방의 기기에서 QR코드를 스캔해주세요. 상대방의 기기에서 공유가 완료되면, 자동으로 자신의 상대방의 명함이 공유됩니다.
    
    지원 기기 : iPhone 11 이후 모델 (SE 기종 제외)
    """
  }
}
