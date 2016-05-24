//
//  CollectionViewCell.swift
//  Filmily
//
//  Created by macbook on 5/19/16.
//  Copyright © 2016 magic. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellPoster: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellYear: UILabel!
    
    let kLabelVerticalInsets: CGFloat = 8.0
    let kLabelHorizontalInsets: CGFloat = 8.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization coded
        self.layer.masksToBounds = true
    }
    
    // In layoutSubViews, need set preferredMaxLayoutWidth for multiple lines label
    override func layoutSubviews() {
        super.layoutSubviews()
        // Set what preferredMaxLayoutWidth you want
        //contentLabel.preferredMaxLayoutWidth = self.bounds.width - 2 * kLabelHorizontalInsets
    }
    
    func configCell(title: String, year: String) {
        
        cellTitle.text = title
        cellYear.text = year
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}
