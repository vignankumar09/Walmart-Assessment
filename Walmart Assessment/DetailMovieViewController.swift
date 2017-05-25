//
//  DetailMovieViewController.swift
//  Fun with Movies
//
//  Created by Vignan on 5/24/17.
//  Copyright © 2017 Vignan. All rights reserved.
//

import UIKit

class DetailMovieViewController: UIViewController {
    
    var movie:Movie!
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var originalLang: UILabel!
    @IBOutlet weak var voteCount: UILabel!
    @IBOutlet weak var voteAverage: UILabel!
    @IBOutlet weak var movieDesc: UILabel!
    
    func loadData() {
        movieName.text = movie.movieTitle
        releaseDate.text = movie.releaseDate
        originalLang.text = movie.movieLanguage
        voteCount.text = "\(movie.voteCount!)"
        voteAverage.text = "\(movie.averageVoting!)"
        movieDesc.text = movie.movieOverview
        
    }
    
    func imageSetting() {
        if movie.movieImage != nil {
            let baseURL = "http://image.tmdb.org/t/p/w500"
            let imageurl = "\(baseURL)\(movie.movieImage!)"
            let url = URL(string: imageurl)
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!) 
                DispatchQueue.main.async {
                    self.movieImage.image = UIImage(data: data!)
                }
            }
        } else {
            DispatchQueue.main.async {
                self.movieImage.image = UIImage(named: "image")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        imageSetting()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
