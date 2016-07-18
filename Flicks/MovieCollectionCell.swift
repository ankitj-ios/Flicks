//
//  MovieCollectionCell.swift
//  Flicks
//
//  Created by Ankit Jasuja on 7/17/16.
//  Copyright © 2016 Ankit Jasuja. All rights reserved.
//

import UIKit

class MovieCollectionCell: UICollectionViewCell {
    

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!

    override func awakeFromNib() {
        // Initialization code
        super.awakeFromNib()
    }
}
