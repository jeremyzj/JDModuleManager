//
//  DGHProfileViewController.swift
//  DModule
//
//  Created by Mac on 2022/6/5.
//

import UIKit
import SnapKit

let kCellIdentifier = "kCellIdentifier"
let kHeaderCellIdentifier = "kHeaderCellIdentifier"

struct DGHCell {
    let title: String
    let height: Float
    let value: String
}

class DGHProfileViewController: UIViewController {
    
    let tableArray: Array<DGHCell> = [
        DGHCell(title: "header", height: 315, value: ""),
        DGHCell(title: "Company", height: 45, value: DGHUser.shared.profile?.company ?? ""),
        DGHCell(title: "Email", height: 45, value: DGHUser.shared.profile?.email ?? ""),
        DGHCell(title: "Location", height: 45, value: DGHUser.shared.profile?.location ?? ""),
        DGHCell(title: "About", height: 45, value: "")
    ]
    var profileTable: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor.black
//        self.navigationController?.navigationBar.isHidden = true

        let tableView: UITableView = UITableView(frame: .zero, style: .plain)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DGHProfileTableViewCell.self, forCellReuseIdentifier: kCellIdentifier)
        tableView.register(DHProfileHeaderTableViewCell.self, forCellReuseIdentifier: kHeaderCellIdentifier)
        self.profileTable = tableView
        
    }
}

extension DGHProfileViewController: UITableViewDelegate {
    
}

extension DGHProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.item == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: kHeaderCellIdentifier, for: indexPath)
            if let headerCell = cell as? DHProfileHeaderTableViewCell, let profile = DGHUser.shared.profile {
                headerCell.configureHeader(profile: profile)
            }
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath)
            if let profileCell = cell as? DGHProfileTableViewCell {
                
                let item = self.tableArray[indexPath.item]
                profileCell.itemTitleLabel.text = item.title
                profileCell.itemContentLabel.text = item.value
            }
            
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.tableArray[indexPath.item]
        return CGFloat(item.height)
    }
}
