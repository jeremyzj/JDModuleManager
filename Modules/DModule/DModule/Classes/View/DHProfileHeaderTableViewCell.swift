//
//  DHProfileHeaderTableViewCell.swift
//  DModule
//
//  Created by Mac on 2022/6/5.
//

import UIKit
import SnapKit
import SDWebImage

class DHProfileHeaderItemView: UIView {
    var titleLabel: UILabel?
    var numLabel: UILabel?
    var itemType: HeaderItemEnum?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        let titleLal = UILabel()
        titleLal.textColor = UIColor.white
        titleLal.textAlignment = .center
        
        let numLal = UILabel()
        numLal.textColor = UIColor.white
        numLal.textAlignment = .center
        
        self.addSubview(titleLal)
        self.addSubview(numLal)
        
        titleLabel = titleLal
        numLabel = numLal
    }
    
    func setupConstraint() {
        titleLabel?.snp.makeConstraints({ make in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(24)
        })
        numLabel?.snp.makeConstraints({ make in
            make.left.right.top.equalTo(self)
            make.height.equalTo(24)
        })
    }
    
    func updateHeaderItem(item: HeaderItem) {
        titleLabel?.text = item.title
        numLabel?.text = String(item.number)
    }
}

struct HeaderItem {
    let title: String
    let number: Int
}

enum HeaderItemEnum: Int {
    case resp = 0
    case gist
    case follower
    case following
}

class DHProfileHeaderView: UIView {
    
    var headerImageView: UIImageView?
    var headerItem: UIView?
    var nameLabel: UILabel?
    var createTimeLabel: UILabel?
    let itemsTitle: Dictionary<HeaderItemEnum, String> = [HeaderItemEnum.resp : "Respo", HeaderItemEnum.gist: "Gists", HeaderItemEnum.follower: "Follower", HeaderItemEnum.following: "Following"]
    var itemsView: Array<DHProfileHeaderItemView> = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        self.setupUI()
        self.setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        let headerImageView = UIImageView()
        self.addSubview(headerImageView)
        self.headerImageView = headerImageView
        
        let nameLabel = UILabel()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = UIColor.white
        nameLabel.text = "text name"
        self.addSubview(nameLabel)
        self.nameLabel = nameLabel
        
        let createTimeLabel = UILabel()
        createTimeLabel.font = UIFont.systemFont(ofSize: 14)
        createTimeLabel.textColor = UIColor.white
        createTimeLabel.text = "create time label"
        self.addSubview(createTimeLabel)
        self.createTimeLabel = createTimeLabel
        
        let headerItem = UIView()
        self.addSubview(headerItem)
        self.headerItem = headerItem
        
        let itemsTitleSorted = itemsTitle.sorted(by: {$0.0.rawValue < $1.0.rawValue})
        for item in itemsTitleSorted {
            let itemView = DHProfileHeaderItemView()
            headerItem.addSubview(itemView)
            itemView.itemType = item.key
            self.itemsView.append(itemView)
        }
    }
    
    func setupConstraint() {
        self.headerImageView?.snp.makeConstraints({ make in
            make.top.equalTo(30)
            make.left.equalTo(20)
            make.width.height.equalTo(66)
        })
        
        if let headerImageView = self.headerImageView {
            self.nameLabel?.snp.makeConstraints({ make in
                make.left.equalTo(headerImageView.snp.right).offset(15)
                make.top.equalTo(47)
                make.right.equalTo(0)
                make.height.equalTo(17)
            })
        }
        
        if let nameLabel = self.nameLabel {
            self.createTimeLabel?.snp.makeConstraints({ make in
                make.left.equalTo(nameLabel.snp.left)
                make.right.equalTo(0)
                make.height.equalTo(17)
                make.top.equalTo(nameLabel.snp.bottom).offset(5)
            })
        }
        
        if let headerImageView = self.headerImageView {
            self.headerItem?.snp.makeConstraints({ make in
                make.left.right.equalTo(self)
                make.height.equalTo(60)
                make.top.equalTo(headerImageView.snp.bottom).offset(10)
            })
        }
        
        let padding: CGFloat = 20
        let width = (UIScreen.main.bounds.width - 2.0 * padding)  / 4.0
        var index = 0
        for itemView in self.itemsView {
            let left = padding + CGFloat(index) * width
            itemView.snp.makeConstraints { make in
                make.width.equalTo(width)
                make.height.equalTo(45)
                make.left.equalTo(left)
                make.top.equalTo(10)
            }
            index += 1
        }
    }
    
    func updateHeaderWithModel(profile: DGHUserProfile) {
        if let url = URL(string: profile.avatarUrl) {
            self.headerImageView?.sd_setImage(with: url, completed: nil)
        }
        
        self.nameLabel?.text = profile.login
        self.createTimeLabel?.text = "Created at \(profile.createAtDate)"
        
        for itemView in self.itemsView {
            guard let type = itemView.itemType else {
                continue
            }
            let title = itemsTitle[type]
            let number = self.numberOfItem(profile: profile, headerType: type)
            let itemData = HeaderItem(title: title ?? "", number: number)
            itemView.updateHeaderItem(item: itemData)
        }
    }
    
    func numberOfItem(profile:DGHUserProfile, headerType:HeaderItemEnum) -> Int {
        switch headerType {
        case .resp:
            return profile.publicRepos
        case .gist:
            return profile.publicGists
        case .follower:
            return profile.followers
        case .following:
            return profile.following
        }
    }
}

class DHProfileHeaderTableViewCell: UITableViewCell {
    var profileHeaderView : DHProfileHeaderView?
    var contributionView : DHGContributionView?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
        self.setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        let profileHeaderView = DHProfileHeaderView()
        self.addSubview(profileHeaderView)
        self.profileHeaderView = profileHeaderView
        
        let contributionView = DHGContributionView()
        contributionView.layer.masksToBounds = true
        contributionView.layer.cornerRadius = 2.0
        self.addSubview(contributionView)
        self.contributionView = contributionView
    }
    
    func setupConstraint() {
        self.profileHeaderView?.snp.makeConstraints({ make in
            make.top.left.right.equalTo(0)
            make.height.equalTo(190)
        })
        
        self.contributionView?.snp.makeConstraints({ make in
            make.top.equalTo(180)
            make.left.equalTo(11)
            make.right.equalTo(-11)
            make.bottom.equalTo(-10)
        })
    }
    
    func configureHeader(profile: DGHUserProfile) {
        self.profileHeaderView?.updateHeaderWithModel(profile: profile)
    }
    
}
