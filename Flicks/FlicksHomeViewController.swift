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

class FlicksHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var networkErrorView: UIView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var flicksHomeTableView: UITableView!
    var movies = [NSDictionary]()
    var filteredMovies = [NSDictionary]()
    let refreshControl =  UIRefreshControl()
    var endPointSuffix : String = "now_playing"
    
    @IBOutlet weak var searchBar: UISearchBar!
    var isSearchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*reachibility code starts*/
        handleNetworkReachability()

        /* setting delegate and datasource for tableview */
        flicksHomeTableView.delegate = self
        flicksHomeTableView.dataSource = self
        
        /* for search */
        searchBar.delegate = self
        searchBar.placeholder = "Movie Title"
        
        /* pull to refresh */
        refreshControl.addTarget(self, action: #selector(onPullToRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.flicksHomeTableView.insertSubview(refreshControl, atIndex: 0)
        
        /* movies data fetch for home screen */
        fetchMoviesData(createRequest())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // =============================    Validation & Error Handling   =========================================
    func handleNetworkReachability() -> Void {
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
    }
    
    // =============================   Fetching Movies Data   =========================================
    
    func createRequest() -> NSURLRequest {
        /* calling api to fetch data */
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endPointSuffix)?api_key=\(apiKey)")
        return NSURLRequest(URL: url!)
    }

    func fetchMoviesData(request : NSURLRequest) -> Void {
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
                        self.movies = responseDictionary["results"] as! [NSDictionary]
                        self.postDataFetch()
                    }
                }
        });
        task.resume()
    }
    
    func postDataFetch() -> Void {
        // reload table view
        self.flicksHomeTableView.reloadData()
        // end refresh control spinner
        refreshControl.endRefreshing()
    }
    
    // =============================    Search Bar Methods    =========================================
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        isSearchActive = true;
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        isSearchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        isSearchActive = false;
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        postDataFetch()
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        isSearchActive = false;
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMovies = movies.filter ({ (movie) -> Bool in
            let movieTitle = movie["title"] as! String
            if movieTitle.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                return true
            } else {
                return false
            }
        })
        postDataFetch()
    }
    // =============================    Table View Methods    =========================================

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isSearchActive) {
            return filteredMovies.count
        }
        /* total cell count */
        return movies.count
    }
    
    /* function called for every cell*/
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var moviesToLoad : [NSDictionary]
        if (isSearchActive) {
            moviesToLoad = filteredMovies
        } else {
            moviesToLoad = movies
        }
        /* current index cell data */
        let movie = moviesToLoad[indexPath.row] as NSDictionary
        /* get current cell */
        let movieCell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        /* set current cell */
        movieCell.movieTitle.text = movie["title"] as? String
        movieCell.movieDescription.text = movie["overview"] as? String
        
        let baseUrl = "http://image.tmdb.org/t/p"
        
        let imageSize = "/w45"
        let originalImageSize = "/original"
        
        let filePath = movie["poster_path"] as! String
        
        let fileUrlWithPath = baseUrl + imageSize + filePath
        let originalImageSizeUrl = baseUrl + originalImageSize + filePath

        let imageRequest = NSURLRequest(URL: NSURL(string: fileUrlWithPath)!)
        let originalImageRequest = NSURLRequest(URL: NSURL(string: originalImageSizeUrl)!)
            
        movieCell.movieImageView.setImageWithURLRequest(
            imageRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                /* imageResponse will be nil if the image is cached */
                if imageResponse != nil {
                    /*Image was NOT cached, fade in image */
                    movieCell.movieImageView.alpha = 0.0
                    movieCell.movieImageView.image = image
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        movieCell.movieImageView.alpha = 1.0
                        }, completion : { (success) -> Void in
                            // The AFNetworking ImageView Category only allows one request to be sent at a time
                            // per ImageView. This code must be in the completion block.
                            movieCell.movieImageView.setImageWithURLRequest(
                                originalImageRequest,
                                placeholderImage: image,
                                success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                    movieCell.movieImageView.image = largeImage
                                },
                                failure: { (request, response, error) -> Void in
                                    // do something for the failure condition of the large image request
                                    // possibly setting the ImageView's image to a default image
                            })
                        }
                    )
                } else {
                    /* Image was cached so just update the image */
                    movieCell.movieImageView.setImageWithURLRequest(
                        originalImageRequest,
                        placeholderImage: image,
                        success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                            if largeImageResponse != nil {
                                /* large image was cached so just update the image */
//                                movieCell.movieImageView.image = image
                                movieCell.movieImageView.alpha = 0.0
                                movieCell.movieImageView.image = largeImage
                                UIView.animateWithDuration(0.3, animations: { () -> Void in
                                    movieCell.movieImageView.alpha = 1.0
                                })
                            } else {
                                /* large image was cached so just update the image */
                                movieCell.movieImageView.image = largeImage;
                            }
                            movieCell.movieImageView.image = largeImage
                        },
                        failure: { (request, response, error) -> Void in
                            // do something for the failure condition of the large image request
                            // possibly setting the ImageView's image to a default image
                    })

                }
            },
            failure: { (imageRequest, imageResponse, error) -> Void in
                print(error)
        })
        return movieCell
    }

    // =============================    Segue Methods    =========================================

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /* get source and destination */
        let sourceCell = sender as! MovieCell
        let destinationViewController = segue.destinationViewController as! FlicksDetailsViewController
        /*pass data from source to destination */
        let indexPath = flicksHomeTableView.indexPathForCell(sourceCell)
        destinationViewController.movie = movies[indexPath!.row]
    }

    // =============================    Pull To Refresh Methods    =========================================

    func onPullToRefresh(refreshControl: UIRefreshControl) {
        fetchMoviesData(createRequest())
    }
}
