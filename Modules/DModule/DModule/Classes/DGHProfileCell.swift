//
//  DGHProfileCell.swift
//  DModule
//
//  Created by Mac on 2022/6/22.
//

import UIKit
import SnapKit

class DGHProfileTableViewCell: UITableViewCell {

    lazy var itemTitleLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor(named: "LabelColor1")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    lazy var itemContentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "LabelColor2")
        label.font = UIFont.systemFont(ofSize: 13)
         return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {


        self.contentView.addSubview(itemTitleLabel)
        self.contentView.addSubview(itemContentLabel)

        itemTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
            make.top.bottom.equalTo(0)
        }

        itemContentLabel.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.centerY.equalToSuperview()
            make.top.bottom.equalTo(0)
        }
    }

}
