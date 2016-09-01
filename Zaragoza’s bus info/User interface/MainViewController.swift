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
    
    private let busStopCellIdentifier = "BusStopCell"
    private var busStops = [BusStop]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 150
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let request = BusStopsAPIRequest()
        
        request.executeWithCompletion { [weak self] (response: () throws -> [BusStop]) in
            do {
                self?.busStops = try response()
                self?.tableView.reloadData()
                self?.updateCellsWithImages()
            } catch _ {
                
                // REMARK: Would use UIAlertController or preferably centralize alert handling.
                UIAlertView(title: "Error", message: "Something went wrong", delegate: nil, cancelButtonTitle: "OK").show()
            }
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(busStopCellIdentifier, forIndexPath: indexPath) as! BusStopCell
        
        let busStop = busStops[indexPath.row]
        
        cell.name = busStop.name
        cell.number = busStop.number
        cell.imageData = busStop.mapImage
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busStops.count
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            updateCellsWithImages()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        updateCellsWithImages()
    }

    func updateCellsWithImages() {
        
        debugPrint("end scrolling")
        
        guard let visibleIndexPaths = self.tableView.indexPathsForVisibleRows else {
            return
        }
        
        let visibleBusStops = visibleIndexPaths.map { (indexPath) -> BusStop in
            return busStops[indexPath.row]
        }
        
        for busStop in visibleBusStops {
            busStop.getImageWithCompletion{ [weak self] (image) in
                self?.tableView.reloadData()
            }
        }
    }
}
