//
//  FlicksHomeViewController.swift
//  Flicks
//
//  Created by Ankit Jasuja on 7/15/16.
//  Copyright © 2016 Ankit Jasuja. All rights reserved.
//

import UIKit
import AFNetworking

class FlicksHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var flicksHomeTableView: UITableView!
    var movies = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flicksHomeTableView.delegate = self
        flicksHomeTableView.dataSource = self
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
                                   delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
          completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data,
                    options:[]) as? NSDictionary {
                    //                    NSLog("response: \(responseDictionary)")
                    self.movies = responseDictionary["results"] as! [NSDictionary]
                    self.flicksHomeTableView.reloadData()
                }
                
            }
        });
        task.resume()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let movie = movies[indexPath.row] as NSDictionary
        
        let movieCell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        movieCell.movieTitle.text = movie["title"] as? String
        movieCell.movieDescription.text = movie["overview"] as? String
        let baseUrl = "http://image.tmdb.org/t/p"
        let imageSize = "/w500"
        let filePath = movie["poster_path"] as! String
        let fileUrlWithPath = baseUrl + imageSize + filePath
        movieCell.movieImageView.setImageWithURL(NSURL(string: fileUrlWithPath)!)
        return movieCell
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
