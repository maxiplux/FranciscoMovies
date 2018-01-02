//
//  MovieManaged.Ext.swift
//  FranciscoMovies
//
//  Created by JUAN on 1/01/18.
//  Copyright © 2018 net.juanfrancisco.blog. All rights reserved.
//

import Foundation
extension MovieManaged {
func mappedObject() -> Movie {
    return Movie(id: self.id, title: self.title, order: Int(self.order), summary: self.summary, image: self.image, category: self.category, director: self.director)
}
}
