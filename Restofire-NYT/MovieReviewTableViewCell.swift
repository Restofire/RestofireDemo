//
//  MovieReviewTableViewCell.swift
//  Restofire-NYT
//
//  Created by Rahul Katariya on 02/05/16.
//  Copyright © 2016 Rahul Katariya. All rights reserved.
//

import UIKit

class MovieReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var displayTitleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
