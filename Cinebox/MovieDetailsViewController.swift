//
//  MovieDetailsViewController.swift
//  Cinebox
//
//  Created by Yiheng Cen Feng on 5/9/20.
//  Copyright © 2020 Yiheng. All rights reserved.
//

import UIKit
import AVFoundation


class MovieDetailsViewController: UIViewController {

   
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    var movie:[String:Any]!
    var downloadTask: URLSessionDownloadTask?
    var audioPlayer: AVAudioPlayer!
    var favorited = false
    
    var favoriteList = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if ((UserDefaults.standard.object(forKey: "favorited")) != nil){
            favoriteList = (UserDefaults.standard.object(forKey: "favorited") as? [[String:Any]])!
            if(findIndex() != -1) {
                favorited = true
                favoriteButton.alpha = 1.0
            }
        }
        loadData()
    }
    
    func loadData() {
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
        if (backdropPath == nil){
            backdropView.image = UIImage(named: "placeholder")
        } else {
            let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath!)
            downloadTask = backdropView.loadImage(url: backdropUrl!)
        }
    }
    
    @IBAction func favoriteButton(_ sender: Any) {
        buttonClicksSound()
        animationScaleEffect(view: favoriteButton, animationTime: 0.4)
        
        if(!favorited){
            favoriteButton.alpha = 1.0
            favorited = true
            favoriteList.append(movie)
        } else {
            favorited = false
            favoriteButton.alpha = 0.5
            favoriteList.remove(at: findIndex())
        }
        UserDefaults.standard.set(favoriteList, forKey: "favorited")
    }
    
    func buttonClicksSound() {
        if let soundURL = Bundle.main.url(forResource: "buttonClicks", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            }
            catch {
                print(error)
            }
            audioPlayer.play()
        } else{
            print("Unable to locate audio file")
        }
    }
    
    func animationScaleEffect(view: UIView, animationTime: Float)
    {
        UIView.animate(withDuration: TimeInterval(animationTime), animations: {
            view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        },completion:{completion in
            UIView.animate(withDuration: TimeInterval(animationTime), animations: { () -> Void in
                view.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        })
    }
    
    func findIndex() -> Int {
        let movieID = movie["id"] as! Int
        if(favoriteList.count != 0) {
            for iterator in 0...(favoriteList.count-1) {
                let favoritedMovieID = favoriteList[iterator]["id"] as! Int
                if (movieID == favoritedMovieID) {
                    return iterator
                }
            }
        }
        return -1
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
