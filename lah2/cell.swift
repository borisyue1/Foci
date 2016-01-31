//
//  cell.swift
//  lah2
//
//  Created by Shivam Dave on 1/31/16.
//  Copyright © 2016 ShivamDave. All rights reserved.
//

import UIKit

class cell: UITableViewCell {
    
    
    @IBOutlet var username: UILabel!
    
    
    @IBOutlet var address: UILabel!
    
    
    @IBOutlet var rating: UIImageView!
    
    
    @IBOutlet var message: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
