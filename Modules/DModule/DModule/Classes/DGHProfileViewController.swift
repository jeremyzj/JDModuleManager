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

class DGHProfileViewController: UIViewController {
    
    let tableArray = [1, 2, 3, 4, 5, 6, 7]
    var profileTable: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true

        let tableView: UITableView = UITableView(frame: .zero, style: .plain)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kCellIdentifier)
        tableView.register(DHProfileHeaderTableViewCell.self, forCellReuseIdentifier: kHeaderCellIdentifier)
        
        self.profileTable = tableView
        
        DGHContributionsGateway.shared.profile = DGHUserGateway.shared.profile
        DGHContributionsGateway.shared.fetchGHContrubution(model: GHApiManager.shared.dghModel!)
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
            if let headerCell = cell as? DHProfileHeaderTableViewCell, let profile = DGHUserGateway.shared.profile {
                headerCell.configureHeader(profile: profile)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath)
            let item = self.tableArray[indexPath.item]
            cell.textLabel?.text = String(item)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 190 : 50
    }
}
