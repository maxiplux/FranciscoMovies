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

class ShowMovie: UIViewController {
    
    
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


