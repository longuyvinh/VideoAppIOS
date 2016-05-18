//
//  customCellSwipe.swift
//  Filmily
//
//  Created by macbook on 5/17/16.
//  Copyright © 2016 magic. All rights reserved.
//

import UIKit

class customCellSwipe: UITableViewCell {

    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var labelYear: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
