//
//  GenresViewController.swift
//  Cinebox
//
//  Created by Yiheng Cen Feng on 5/7/20.
//  Copyright © 2020 Yiheng. All rights reserved.
//

import UIKit

@objc protocol GenresViewControllerDelegate {
    @objc optional func genresViewController(genresViewController: GenresViewController, selectedGenre genre: String)
}

class GenresViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: GenresViewControllerDelegate?
    
    var genres: [[String:String]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        genres = genresList()
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func genresList() -> [[String:String]] {
        return [["name": "All", "id":""],
                ["name": "Action", "id":"28"],
                ["name": "Adventure", "id":"12"],
                ["name": "Animation", "id":"16"],
                ["name": "Comedy", "id":"35"],
                ["name": "Documentary", "id":"99"],
                ["name": "Drama", "id":"18"],
                ["name": "Family", "id":"10751"],
                ["name": "Fantasy", "id":"14"],
                ["name": "Horror", "id":"27"],
                ["name": "Music", "id":"10402"],
                ["name": "Mystery", "id":"9648"],
                ["name": "Romance", "id":"10749"],
                ["name": "Science Fiction", "id":"878"],
                ["name": "Thriller", "id":"53"]]
    }

}

extension GenresViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
           
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        
        let genre = genres[indexPath.row]["id"]!
       
        delegate?.genresViewController?(genresViewController: self, selectedGenre: genre)
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenreCell", for: indexPath) as! GenreCell
        
        let genre = genres[indexPath.row]
        cell.genreLabel.text = genre["name"]
        
        return cell
    }
}

