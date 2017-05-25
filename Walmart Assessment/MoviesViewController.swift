//
//  ViewController.swift
//  Fun with Movies
//
//  Created by Vignan on 5/24/17.
//  Copyright © 2017 Vignan. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class MoviesViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    var itemsPerRow: CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    
    var jsonArray :NSMutableArray=[]
    var movies:[Movie] = []
    var imageCache = [String:UIImage]()
    
    func jsonParsingFromURL () {
        jsonArray.removeAllObjects()
        movies.removeAll()
        let searchText = searchBar.text! == "" ? " " : searchBar.text!
        var url = " "
        if searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) != nil{
            let encodedString = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            let apiKey = "142e98d90c5d2641489532ffbfa53bdf"
            url = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=en-US&query=\(encodedString)&page=1&include_adult=false"
        }
        
        Alamofire.request("\(url)").responseJSON { response in
            if let JSON = response.result.value {
                for i in 0  ..< ((JSON as AnyObject).value(forKey: "results") as! NSArray).count
                {
                    self.jsonArray.add(((JSON as AnyObject).value(forKey: "results") as! NSArray) .object(at: i))
                }
                self.movieCollectionView .reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = view.frame.width
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: 170.0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jsonArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        collectMovies(index: indexPath.row)
        let baseURL = "http://image.tmdb.org/t/p/w500"
        var imageurl = ""
        var url:URL!
        if movies[indexPath.row].movieImage != nil {
            imageurl = "\(baseURL)\(movies[indexPath.row].movieImage!)"
            url = URL(string: imageurl)
            cell.movieImage.sd_setImage(with: url, placeholderImage: UIImage(named: "image"))
        } else {
            cell.movieImage.image = UIImage(named: "image")
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "allMoviesSegue" {
            if let detailMovieTVC = segue.destination as? DetailMovieViewController {
                let indexPath = movieCollectionView.indexPath(for: sender as! UICollectionViewCell)
                detailMovieTVC.movie = movies[(indexPath?.row)!]
            }
        }
    }
    
    // Collecting movies
    func collectMovies(index:Int) {
        let movie = Movie()
        movie.movieOriginalTitle = (jsonArray[index] as AnyObject).value(forKey: "original_title") as! String
        movie.movieImage = (jsonArray[index] as AnyObject).value(forKey: "poster_path") as? String
        movie.isAdult = (jsonArray[index] as AnyObject).value(forKey: "adult") as! Bool
        movie.movieTitle = (jsonArray[index] as AnyObject).value(forKey: "title") as! String
        movie.movieOverview = (jsonArray[index] as AnyObject).value(forKey: "overview") as! String
        movie.releaseDate = (jsonArray[index] as AnyObject).value(forKey: "release_date") as! String
        movie.genre = []
        movie.movieId = (jsonArray[index] as AnyObject).value(forKey: "id") as! Int
        movie.movieLanguage = (jsonArray[index] as AnyObject).value(forKey: "original_language") as! String
        movie.popularity = (jsonArray[index] as AnyObject).value(forKey: "popularity") as! Double
        movie.voteCount = (jsonArray[index] as AnyObject).value(forKey: "vote_count") as! Int
        movie.averageVoting = (jsonArray[index] as AnyObject).value(forKey: "vote_average") as! Double
        movies.append(movie)
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        jsonParsingFromURL()
        movieCollectionView.reloadData()
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        jsonParsingFromURL()
        movieCollectionView.reloadData()
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jsonParsingFromURL()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

