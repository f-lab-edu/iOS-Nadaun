//
//  MyCardViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit
import FirebaseAuth

final class MyCardViewController: UIViewController {
  private let loadingIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .medium)
    return indicator
  }()
  private var collectionView: UICollectionView? = nil
  private var dataSource: UICollectionViewDiffableDataSource<Int, BusinessCard>?
  
  private let viewModel: MyCardViewModel
  
  init(viewModel: MyCardViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    generateCollectionView()
    configureUI()
    
    binding()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    viewModel.bind(.fetchCards)
  }
}

private extension MyCardViewController {
  func binding() {
    viewModel.didChangeRenderState = { [weak self] renderState in
      self?.updateIndicatorState(to: renderState == .loading)
    }
    
    viewModel.fetchedCards = { [weak self] cards in
      self?.updateSnapshot(with: cards)
    }
  }
  
  private func updateIndicatorState(to isAnimating: Bool) {
    self.collectionView?.isHidden = isAnimating
    self.loadingIndicator.isHidden = (isAnimating == false)
    
    if isAnimating {
      loadingIndicator.startAnimating()
    } else {
      loadingIndicator.stopAnimating()
    }
  }
  
  private func updateSnapshot(with items: [BusinessCard]) {
    var snapshot = dataSource?.snapshot() ?? .init()
    
    if snapshot.numberOfSections <= 0 {
      snapshot.appendSections([0])
    }
    
    let notContainItems = items.filter { snapshot.itemIdentifiers.contains($0) == false }
    
    if notContainItems.isEmpty { return }
    
    snapshot.appendItems(notContainItems)
    dataSource?.apply(snapshot)
  }
}

// MARK: Configure CollectionView Methods
private extension MyCardViewController {
  func generateCollectionView() {
    let layout = generateCollectionViewLayout()
    
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView?.isScrollEnabled = false
    
    if let collectionView = collectionView {
      dataSource = generateDataSource(to: collectionView)
    }
  }
  
  func generateDataSource(
    to collectionView: UICollectionView
  ) -> UICollectionViewDiffableDataSource<Int, BusinessCard> {
    let registration = UICollectionView
      .CellRegistration<MyCardCollectionViewCell, BusinessCard> { cell, _, card in
        cell.configure(with: card)
      }
    
    return UICollectionViewDiffableDataSource(
      collectionView: collectionView
    ) { collectionView, indexPath, itemIdentifier in
      return collectionView.dequeueConfiguredReusableCell(
        using: registration, for: indexPath, item: itemIdentifier
      )
    }
  }
  
  func generateAnimationSection(with group: NSCollectionLayoutGroup) -> NSCollectionLayoutSection {
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPagingCentered
    
    section.visibleItemsInvalidationHandler = { items, point, environment in
      items.enumerated().forEach { index, item in
        let distanceFromCenter = abs((item.frame.midX - point.x) - environment.container.contentSize.width / 2)
        let minScale = 0.9
        let maxScale = (1.0 - (distanceFromCenter / environment.container.contentSize.width))
        let scale = max(minScale, maxScale)
        item.transform = CGAffineTransform(scaleX: scale, y: scale)
      }
    }
    
    return section
  }
  
  func generateCollectionViewLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8),
                                           heightDimension: .fractionalHeight(0.8))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let section = generateAnimationSection(with: group)
    return UICollectionViewCompositionalLayout { _, environment in
      let container = environment.container
      section.contentInsets = NSDirectionalEdgeInsets(top: container.contentSize.height * 0.1,
                                                      leading: .zero, bottom: .zero, trailing: .zero)
      return section
    }
  }
}

private extension MyCardViewController {
  func configureUI() {
    view.backgroundColor = .systemBackground
    
    configureNavigationBar()
    
    configureHierarchy()
    makeConstraints()
  }
  
  func configureNavigationBar() {
    let titleLabel = UILabel()
    titleLabel.text = "내 명함"
    titleLabel.font = .pretendardFont(to: .H3B)
    titleLabel.textColor = .accent
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
  }
  
  func configureHierarchy() {
    guard let collectionView = collectionView else { return }
    [loadingIndicator, collectionView].forEach(view.addSubview)
  }
  
  func makeConstraints() {
    guard let collectionView = collectionView else { return }
    
    collectionView.attach {
      $0.top(equalTo: view.safeAreaLayoutGuide.topAnchor)
      $0.leading(equalTo: view.leadingAnchor)
      $0.trailing(equalTo: view.trailingAnchor)
      $0.bottom(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    loadingIndicator.attach {
      $0.centerXAnchor.constraint(equalTo: view.centerXAnchor)
      $0.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    }
  }
}
