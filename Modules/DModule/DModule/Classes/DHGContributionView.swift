//
//  DHGContributionView.swift
//  DModule
//
//  Created by Mac on 2022/6/21.
//

import UIKit
import SnapKit


let Font_PingFangSCSemiBold = "PingFang-SC-SemiBold"

class DHGContributionView: UIView {
    
    private var dataArray: [DGHContributionModel] = []
    private let gateway : DGHContributionsGateway = DGHContributionsGateway()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Font_PingFangSCSemiBold, size: 12)
        label.textColor = UIColor(named: "LabelColor2")
        label.text = "Contributions"
        label.isUserInteractionEnabled = false
        label.textAlignment = .left
        return label
    }()
    
    // view
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.estimatedItemSize = CGSize(width: 10, height: 10)
        collectionViewLayout.minimumInteritemSpacing = 2
        collectionViewLayout.minimumLineSpacing = 2
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupData()
        self.setupUI()
        collectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupData()
        self.setupUI()
    }
    
    func setupData() {
        gateway.fetchGHContrubution() {
            [weak self] in
            self?.dataArray = $0
            self?.collectionView.performBatchUpdates { [weak self] in
                self?.collectionView.reloadData()
            } completion: { [weak self] _ in
                guard let self = self else {return}
                let count = self.dataArray.count
                if count > 0 && self.collectionView.contentOffset.x <= 0 {
                    let indexPath = IndexPath(row: count - 1, section: 0)
                    self.collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.right, animated: false)
                }
            }
        }
    }
    
    func setupUI() {
        self.backgroundColor = UIColor(named: "ContributionBackColor")
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalTo(5)
            make.height.equalTo(15)
            make.right.equalTo(0)
        }
        
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.left.right.bottom.equalTo(0)
        }
        collectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    deinit {
        collectionView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        self.setNeedsUpdateConstraints()
    }
}

extension DHGContributionView: UICollectionViewDelegate {
    
}

extension DHGContributionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        collectionViewCell.layer.masksToBounds = true
        collectionViewCell.layer.cornerRadius = 2.0
        let contributionData = self.dataArray[indexPath.row]
        switch contributionData.level {
        case 0:
            collectionViewCell.backgroundColor = UIColor(named: "ContributionColor1")
        case 1:
            collectionViewCell.backgroundColor = UIColor(named: "ContributionColor2")
        case 2:
            collectionViewCell.backgroundColor = UIColor(named: "ContributionColor3")
        case 3:
            collectionViewCell.backgroundColor = UIColor(named: "ContributionColor4")
        case 4:
            collectionViewCell.backgroundColor = UIColor(named: "ContributionColor5")
        default:
            collectionViewCell.backgroundColor = UIColor(named: "ContributionColor1")
        }
        return collectionViewCell
    }
}
