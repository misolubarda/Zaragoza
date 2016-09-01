//
//  BusStopCell.swift
//  Zaragoza’s bus info
//
//  Created by Miso Lubarda on 01/09/16.
//  Copyright © 2016 Miso Lubarda. All rights reserved.
//

import UIKit

class BusStopCell: UITableViewCell {
    
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var nameTextView: UITextView!
    @IBOutlet private weak var mapImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameTextView.textContainerInset = UIEdgeInsetsZero
    }
    
    var name: String? {
        didSet {
            nameTextView.text = name
        }
    }
    var number: Int? {
        didSet {
            if number != nil {
                numberLabel.text = "\(number!)"
            } else {
                numberLabel.text = ""
            }
        }
    }
    var imageData: NSData? {
        didSet {
            if let imageData = imageData {
                mapImageView.image = UIImage(data: imageData)
            } else {
                mapImageView.image = nil
            }
        }
    }
}
