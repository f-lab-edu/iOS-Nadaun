//
//  MyCardViewController.swift
//  iOS-Naduan
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit
import FirebaseAuth

final class MyCardViewController: UIViewController {
  private var collectionView: UICollectionView? = nil
  private var dataSource: UICollectionViewDiffableDataSource<Int, Int>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    generateCollectionView()
    configureUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    let items = Array(1...100)
    
    var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
    snapshot.appendSections([0])
    snapshot.appendItems(items)
    dataSource?.apply(snapshot, animatingDifferences: true)
  }
}

extension MyCardViewController: UICollectionViewDelegate {
  
}

// MARK: Configure CollectionView Methods
private extension MyCardViewController {
  func generateCollectionView() {
    let layout = generateCollectionViewLayout()
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView?.delegate = self
    collectionView?.isScrollEnabled = false
    
    if let collectionView = collectionView {
      dataSource = generateDataSource(to: collectionView)
    }
  }
  
  func generateDataSource(
    to collectionView: UICollectionView
  ) -> UICollectionViewDiffableDataSource<Int, Int> {
    let registration = UICollectionView
      .CellRegistration<MyCardCollectionViewCell, Int> { cell, indexPath, itemIdentifier in
        cell.configure(with: itemIdentifier)
        //        return
      }
    
    return UICollectionViewDiffableDataSource(
      collectionView: collectionView
    ) { collectionView, indexPath, itemIdentifier in
      return collectionView.dequeueConfiguredReusableCell(
        using: registration, for: indexPath, item: itemIdentifier
      )
    }
  }
  
  func generateCollectionViewLayout() -> UICollectionViewLayout {
    return UICollectionViewCompositionalLayout { sectionIndex, environment in
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                            heightDimension: .fractionalHeight(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 4, bottom: 10, trailing: 4)
      
      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.75),
                                             heightDimension: .fractionalHeight(0.8))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      
      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .groupPagingCentered
      let container = environment.container
      section.contentInsets = NSDirectionalEdgeInsets(top: container.contentSize.height * 0.1,
                                                      leading: .zero, bottom: .zero, trailing: .zero)
      
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
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: .remove, primaryAction: .init(handler: { [weak self] _ in
      try? Auth.auth().signOut()
    }))
  }
  
  func configureHierarchy() {
    guard let collectionView = collectionView else { return }
    view.addSubview(collectionView)
  }
  
  func makeConstraints() {
    guard let collectionView = collectionView else { return }
    
    collectionView.attach {
      $0.top(equalTo: view.safeAreaLayoutGuide.topAnchor)
      $0.leading(equalTo: view.leadingAnchor)
      $0.trailing(equalTo: view.trailingAnchor)
      $0.bottom(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    }
  }
}
