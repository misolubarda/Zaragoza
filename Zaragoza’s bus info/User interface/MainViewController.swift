//
//  MainViewController.swift
//  Zaragoza’s bus info
//
//  Created by Miso Lubarda on 01/09/16.
//  Copyright © 2016 Miso Lubarda. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: MainViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = MainViewModel(tableView: self.tableView)        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let request = BusStopsAPIRequest()
        
        request.executeWithCompletion { [weak self] (response: () throws -> [BusStop]) in
            do {
                self?.viewModel?.busStops = try response()
            } catch _ {
                
                // REMARK: Would use UIAlertController or preferably centralize alert handling.
                UIAlertView(title: "Error", message: "Something went wrong", delegate: nil, cancelButtonTitle: "OK").show()
            }
        }
    }
    
}

