//
//  FlicksDetailsViewController.swift
//  Flicks
//
//  Created by Ankit Jasuja on 7/15/16.
//  Copyright © 2016 Ankit Jasuja. All rights reserved.
//

import UIKit

class FlicksDetailsViewController: UIViewController {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    
    
    var movie : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTitleLabel.text = movie["title"] as? String
        movieDescriptionLabel.text = movie["overview"] as? String
        let baseUrl = "http://image.tmdb.org/t/p"
        let imageSize = "/original"
        let filePath = movie["poster_path"] as! String
        let fileUrlWithPath = baseUrl + imageSize + filePath
        movieImageView.setImageWithURL(NSURL(string: fileUrlWithPath)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
