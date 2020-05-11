//
//  MoviesViewController.swift
//  Cinebox
//
//  Created by Yiheng Cen Feng on 5/2/20.
//  Copyright © 2020 Yiheng. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, GenresViewControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies = [[String:Any]]()
    var downloadTask: URLSessionDownloadTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let url = filterURL(filterText: "")
        performFilterRequest(with: url)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
               
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
               
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 3
        layout.itemSize = CGSize(width: width, height: width * 1.7)
    }
    
    func filterURL(filterText: String) -> URL {
        let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=cc1dd3075ce8f7e82e9d87cc00aa19d2&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&with_genres=" + filterText)
        return url!
    }
    
    func performFilterRequest(with url: URL){
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                self.movies = dataDictionary["results"] as! [[String:Any]]
                self.collectionView.reloadData()
            }
        }
        task.resume()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieDetails" {
            // Find the selected movie
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView.indexPath(for: cell)!
            let movie = movies[indexPath.item]
            
            // Pass the selected movie to the datails view controller
            let detailsViewController = segue.destination as! MovieDetailsViewController
            detailsViewController.movie = movie
            
            collectionView.deselectItem(at: indexPath, animated: true)
        } else {
            let navigationController = segue.destination as! UINavigationController
            let genresViewController = navigationController.topViewController as! GenresViewController
            
            genresViewController.delegate = self
        }
        
    }
    
    func genresViewController(genresViewController: GenresViewController, selectedGenre genre: String) {
        let url = filterURL(filterText: genre)
        performFilterRequest(with: url)
        collectionView.reloadData()
    }

}

extension MoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = movies[indexPath.item]
        let title = movie["title"] as? String
        
        cell.titleLabel.text = title

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
