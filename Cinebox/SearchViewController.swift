//
//  SearchViewController.swift
//  Cinebox
//
//  Created by Yiheng Cen Feng on 4/29/20.
//  Copyright © 2020 Yiheng. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var hasSearched = false
    var searchResults = [[String:Any]]()
    var downloadTask: URLSessionDownloadTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.contentInset = UIEdgeInsets(top: 84, left: 0, bottom: 0, right: 0)
    }
    
    func searchURL(searchText: String) -> URL {
        let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=cc1dd3075ce8f7e82e9d87cc00aa19d2&language=en-US&query=" + searchText + "&page=1&include_adult=false")
        return url!
    }
    
    func performSearchRequest(with url: URL){
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                self.searchResults = dataDictionary["results"] as! [[String:Any]]
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Find the selected movie
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = searchResults[indexPath.row]
        
        // Pass the selected movie to the datails view controller
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    // Deselect row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // Only can select rows when there are search results
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if searchResults.count == 0 {
            return nil
        } else {
            return indexPath
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !hasSearched {
            return 0
        } else if searchResults.count == 0 {
            return 1
        } else {
            return searchResults.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        if searchResults.count == 0 {
            let alert = UIAlertController(title: "Movie not found", message: "No movies matched your search", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell

            let movie = searchResults[indexPath.row]
            let title = movie["title"] as! String
            let synopsis = movie["overview"] as! String

            cell.titleLabel.text = title
            cell.synopsisLabel.text = synopsis
            
            let baseUrl = "https://image.tmdb.org/t/p/w185"
            let posterPath = movie["poster_path"] as? String
       
            if (posterPath == nil){
                cell.posterView.image = UIImage(named: "placeholder")
            } else {
                let posterUrl = URL(string: baseUrl + posterPath!)
                downloadTask = cell.posterView.loadImage(url: posterUrl!)
            }
            return cell
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    // Unified the status bar area with the search bar
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            // Dismiss keyboard on search
            searchBar.resignFirstResponder()
            
            hasSearched = true
    
            let url = searchURL(searchText: searchBar.text!.replacingOccurrences(of: " ", with: "%20"))
            performSearchRequest(with: url)
        }
    }
}

