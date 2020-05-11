//
//  FavoritesViewController.swift
//  Cinebox
//
//  Created by Yiheng Cen Feng on 5/10/20.
//  Copyright © 2020 Yiheng. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var favorites = [[String:Any]]()
    var downloadTask: URLSessionDownloadTask?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        if ((UserDefaults.standard.object(forKey: "favorited")) != nil){
            favorites = (UserDefaults.standard.object(forKey: "favorited") as? [[String:Any]])!
            tableView.reloadData()
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Find the selected movie
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = favorites[indexPath.row]
        
        // Pass the selected movie to the datails view controller
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    // Deselect row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // Delete row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          favorites.remove(at: indexPath.row)
        
          tableView.deleteRows(at: [indexPath], with: .automatic)
          UserDefaults.standard.set(favorites, forKey: "favorited")
      }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (favorites.count != 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell

            let favorite = favorites[indexPath.row]
            let title = favorite["title"] as! String
            let synopsis = favorite["overview"] as! String

            cell.titleLabel.text = title
            cell.synopsisLabel.text = synopsis

            let baseUrl = "https://image.tmdb.org/t/p/w185"
            let posterPath = favorite["poster_path"] as? String

            if (posterPath == nil){
                cell.posterView.image = UIImage(named: "placeholder")
            } else {
                let posterUrl = URL(string: baseUrl + posterPath!)
                downloadTask = cell.posterView.loadImage(url: posterUrl!)
            }

            return cell
        }
        return UITableViewCell()
    }
}

