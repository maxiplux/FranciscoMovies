//
//  FavoritiesMovies.swift
//  FranciscoMovies
//
//  Created by JUAN on 1/01/18.
//  Copyright © 2018 net.juanfrancisco.blog. All rights reserved.
//

import Foundation
//
//  TopMovies.swift
//  FranciscoMovies
//
//  Created by JUAN on 1/01/18.
//  Copyright © 2018 net.juanfrancisco.blog. All rights reserved.
//

import UIKit
import Kingfisher

class ShowMovie: UIViewController {
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieSummary: UITextView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieCategory: UILabel!
    @IBOutlet weak var movieDirector: UILabel!
    
    let dataProvider = LocalCoreDataService()
    var movie : Movie? // es un parametro inyecto en el segue
    
    fileprivate func setupCurrentMovie() {
        // Do any additional setup after loading the view, typically from a nib.
        
        if let movie = movie {
            
            if let image = movie.image {
                movieImage.kf.setImage(with: ImageResource(downloadURL: URL(string: image)!))
            }
            
            movieTitle.text = movie.title
            
            self.title = movie.title
            
            movieSummary.text = movie.summary
            movieCategory.text = movie.category
            movieDirector.text = movie.director
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        setupCurrentMovie() // ajustamos todos los parametros de la pelicula que nos llega
        
         configureFavoriteButton()
        
    }
    
    // configuramos el comportamiento de marcar el botono como favorito o no
    // una sola vez dependiendo del estado inicial
    func configureFavoriteButton() {
        if let movie = self.movie {
            if dataProvider.isMovieFavorite(movie: movie) {
                btnFavorite.setBackgroundImage(#imageLiteral(resourceName: "btn-on"), for: .normal)
                btnFavorite.setTitle("¡Quiero verla!", for: .normal)
            } else {
                btnFavorite.setBackgroundImage(#imageLiteral(resourceName: "btn-off"), for: .normal)
                btnFavorite.setTitle("No me interesa", for: .normal)
            }
        }
    }
    
    
    @IBAction func favoritePressed(_ sender: UIButton) {
        
        if let movie = self.movie {
            dataProvider.markUnmarkFavorite(movie: movie)
            configureFavoriteButton()
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        movieSummary.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    
    func getTopMoviesCompletionHandler(data: [[String:String]] ) {
        print(data.count)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


