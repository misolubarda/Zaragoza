//
//  MainViewModel.swift
//  Zaragoza’s bus info
//
//  Created by Miso Lubarda on 02/09/16.
//  Copyright © 2016 Miso Lubarda. All rights reserved.
//

import UIKit


/// This class is not real view model as in actual MVVM pattern. It just contains part of view model.
class MainViewModel: NSObject {
    
    /// Bus stop cell identifier
    private let busStopCellIdentifier = "BusStopCell"
    /// Weak reference to table view to
    private weak var tableView: UITableView?
    /// Timer to refresh bus stop async data (i.e. time of arrival)
    private var refreshTimer: NSTimer?

    /// Array of bus stops.
    var busStops = [BusStop]() {
        didSet {
            tableView?.reloadData()
            updateCellsWithAsyncData()
        }
    }
    
    init(tableView: UITableView?) {
        super.init()
        
        self.tableView = tableView
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.estimatedRowHeight = 150
        self.tableView?.rowHeight = UITableViewAutomaticDimension
    }
    
    /**
     This function asynchoronously updates bus stop images and arrival times. It issues requests only for visible cells and reloads table view on evey response.
     */
    func updateCellsWithAsyncData() {
        
        debugPrint("UPDATING")
        
        // Creating refresh timer to update arrival time if user not active for 1 minute.
        self.refreshTimer?.invalidate()
        self.refreshTimer = nil
        
        self.refreshTimer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: #selector(updateCellsWithAsyncData), userInfo: nil, repeats: false)
        
        // Updating for visible cells only
        guard let visibleIndexPaths = self.tableView?.indexPathsForVisibleRows else {
            return
        }
        
        let visibleBusStops = visibleIndexPaths.map { (indexPath) -> BusStop in
            return busStops[indexPath.row]
        }
        
        // Issuing requests for visible bus stops for images and arrival times.
        for busStop in visibleBusStops {
            
            // Making tradeoff between paralel / serial requests. Decided for paralel requests due to shorter response time and small processing cost to reload cells.
            
            busStop.getImageWithCompletion { [weak self] _ in
                self?.tableView?.reloadData()
            }
            
            busStop.getNextArrivalWithCompletion { [weak self] _ in
                self?.tableView?.reloadData()
            }
        }
    }

}

extension MainViewModel: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(busStopCellIdentifier, forIndexPath: indexPath) as! BusStopCell
        
        let busStop = busStops[indexPath.row]
        
        cell.name = busStop.name
        cell.number = busStop.number
        cell.imageData = busStop.mapImage
        cell.arrival = busStop.busArrival?.estimate
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busStops.count
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // Updating cells when user ends dragging without deceleration.
        if !decelerate {
            updateCellsWithAsyncData()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        // Updating cells when table view ends decelerating.
        updateCellsWithAsyncData()
    }
}
