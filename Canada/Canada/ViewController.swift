//
//  ViewController.swift
//  Canada
//
//  Created by Manoj on 25/04/20.
//  Copyright © 2020 Manoj. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var rows: [Row] = []
    let cellIdentifier = "myCell"
    var myTableView: UITableView  = UITableView()
    var responseFromApi : CanadaResponse?
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.register(CanadaTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        //Make api call and assign the response.
        apiHandler.shared.makeApiCall(onSuccess: { (response) in
            self.responseFromApi = response
            guard let rows = self.responseFromApi?.rows else {return}
            self.rows = rows
            DispatchQueue.main.async {
                self.myTableView.reloadData()
                if let titleStr = self.responseFromApi?.title {
                    self.navigationItem.title = titleStr
                }
            }
        }) { (error) in
            print("Error")
        }
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    @objc func refresh(_ sender: AnyObject) {
        myTableView.reloadData()
        refreshControl.endRefreshing()
    }
    func configureTableView(){
        self.view.addSubview(myTableView)
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        myTableView.estimatedRowHeight = 200
        myTableView.rowHeight = UITableView.automaticDimension
        myTableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        myTableView.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor).isActive = true
        myTableView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor).isActive = true
        myTableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        myTableView.dataSource = self
        myTableView.delegate = self
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("PULL_TO_REFRESH", comment: "PULL_TO_REFRESH"))
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        myTableView.addSubview(refreshControl)
        myTableView.tableFooterView = UIView()
        myTableView.register(CanadaTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
// MARK: TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! CanadaTableViewCell
        cell.canadaCell = self.rows[indexPath.row]
        return cell
    }
}
