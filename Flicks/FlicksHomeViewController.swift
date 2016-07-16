//
//  FlicksHomeViewController.swift
//  Flicks
//
//  Created by Ankit Jasuja on 7/15/16.
//  Copyright © 2016 Ankit Jasuja. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD
import ReachabilitySwift

class FlicksHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var networkErrorView: UIView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var flicksHomeTableView: UITableView!
    var movies = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*reachibility code starts*/
        do {
            let reachability = try Reachability.reachabilityForInternetConnection()
            let isReachable  = reachability.isReachable();
            errorMessageLabel.hidden = true
            if isReachable == false {
                errorMessageLabel.hidden = false
                errorMessageLabel.text = "Network Error"
            }
        } catch {
            print(error)
        }

        /* setting delegate and datasource for tableview */
        flicksHomeTableView.delegate = self
        flicksHomeTableView.dataSource = self
        
        /* pull to refresh */
        let refreshControl =  UIRefreshControl()
        refreshControl.addTarget(<#T##target: AnyObject?##AnyObject?#>, action: <#T##Selector#>, forControlEvents: <#T##UIControlEvents#>)
        
        
        /* calling api to fetch data */
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)

        /* show progress heads up display*/
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)

        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
                                   delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
          completionHandler: { (dataOrNil, response, error) in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            if let data = dataOrNil {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data,
                    options:[]) as? NSDictionary {
                    // cache output from api
                    self.movies = responseDictionary["results"] as! [NSDictionary]
                    // reload table view
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
        /* total cell count */
        return movies.count
    }
    
    /* function called for every cell*/
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        /* current index cell data */
        let movie = movies[indexPath.row] as NSDictionary
        /* get current cell */
        let movieCell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        /* set current cell */
        movieCell.movieTitle.text = movie["title"] as? String
        movieCell.movieDescription.text = movie["overview"] as? String
        let baseUrl = "http://image.tmdb.org/t/p"
        let imageSize = "/w500"
        let filePath = movie["poster_path"] as! String
        let fileUrlWithPath = baseUrl + imageSize + filePath
        movieCell.movieImageView.setImageWithURL(NSURL(string: fileUrlWithPath)!)
        return movieCell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /* get source and destination */
        let sourceCell = sender as! MovieCell
        let destinationViewController = segue.destinationViewController as! FlicksDetailsViewController
        /*pass data from source to destination */
        let indexPath = flicksHomeTableView.indexPathForCell(sourceCell)
        destinationViewController.movie = movies[indexPath!.row]
        
    }

}
