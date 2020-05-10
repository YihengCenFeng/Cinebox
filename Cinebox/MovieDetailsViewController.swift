//
//  MovieDetailsViewController.swift
//  Cinebox
//
//  Created by Yiheng Cen Feng on 5/9/20.
//  Copyright © 2020 Yiheng. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

   
    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    var movie:[String:Any]!
    var downloadTask: URLSessionDownloadTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["overview"] as? String
        
        let posterPath = movie["poster_path"] as? String
       
        if (posterPath == nil){
            posterView.image = UIImage(named: "placeholder")
        } else {
            let posterUrl = URL(string: "https://image.tmdb.org/t/p/w185" + posterPath!)
            downloadTask = posterView.loadImage(url: posterUrl!)
        }
        
        let backdropPath = movie["backdrop_path"] as? String
        if (posterPath == nil){
            backdropView.image = UIImage(named: "placeholder")
        } else {
            let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath!)
            downloadTask = backdropView.loadImage(url: backdropUrl!)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
