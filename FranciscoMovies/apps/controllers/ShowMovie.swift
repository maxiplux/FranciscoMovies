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
    var movie : Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    func getTopMoviesCompletionHandler(data: [[String:String]] ) {
        print(data.count)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


