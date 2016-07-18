//
//  MovieCell.swift
//  Flicks
//
//  Created by Ankit Jasuja on 7/15/16.
//  Copyright © 2016 Ankit Jasuja. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    
    override func awakeFromNib() {
        // Initialization code
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        /* Configure the view for the selected state */
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .None
    }

}
