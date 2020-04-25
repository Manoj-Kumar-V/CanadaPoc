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
    
    var rows: [row] = []
    let cellIdentifier = "myCell"
    var myTableView: UITableView  = UITableView()
    var responseFromApi : CanadaResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Make api call and assign the response.
        apiHandler.shared.makeApiCall(onSuccess: { (response) in
            self.responseFromApi = response
            guard let rows = self.responseFromApi?.rows else {return}
            self.rows = rows
            DispatchQueue.main.async {
                self.myTableView.reloadData()
            }
        }) { (error) in
            print("Error")
        }
        self.navigationItem.title = self.responseFromApi?.title
        myTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get main screen bounds
        let screenSize: CGRect = UIScreen.main.bounds
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        myTableView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        myTableView.dataSource = self
        myTableView.delegate = self
        
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        self.view.addSubview(myTableView)
        
    }
    
    // MARK: TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath)
        cell.textLabel?.text = self.rows[indexPath.row].title
        cell.detailTextLabel?.text = self.rows[indexPath.row].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        let sectionName = self.responseFromApi?.title
        return sectionName
    }
    
}
