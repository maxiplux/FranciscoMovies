//
//  Movie.swift
//  EMDb
//
//  Created by MIGUEL DIAZ RUBIO on 2/10/16.
//  Copyright © 2016 Miguel Díaz Rubio. All rights reserved.
//

import Foundation

class Movie {
    
    var id : String?
    var title : String?
    var order : Int?
    var summary : String?
    var image : String?
    var category : String?
    var director : String?
    
    init() {
        
        self.id = nil
        self.title = nil
        self.order = nil
        self.summary = nil
        self.image = nil
        self.category = nil
        self.director = nil
        
    }
    
    init(id: String?, title: String?, order: Int?, summary: String?, image: String?, category: String?, director: String?) {
        
        self.id = id
        self.title = title
        self.order = order
        self.summary = summary
        self.image = image
        self.category = category
        self.director = director
        
    }
    
}
