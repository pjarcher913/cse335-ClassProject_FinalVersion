//
//  LocTableCells.swift
//  cse335f18_ClassProject-archer_patrick
//
//  Created by Patrick Archer
//  Copyright © 2018 Patrick Archer - Self. All rights reserved.
//

import Foundation
import UIKit

class LocTableCells: UITableViewCell {
    
    @IBOutlet weak var locTitle: UILabel!
    @IBOutlet weak var locDescription: UILabel!
    @IBOutlet weak var locImage: UIImageView!{
        didSet {
            locImage.layer.cornerRadius = locImage.bounds.width / 2
            locImage.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
