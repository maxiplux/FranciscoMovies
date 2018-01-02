//
//  LocalCoreDataService.swift
//  EMDb
//
//  Created by MIGUEL DIAZ RUBIO on 3/10/16.
//  Copyright © 2016 Miguel Díaz Rubio. All rights reserved.
//

import Foundation
import CoreData

class LocalCoreDataService {
    
    let remoteMovieService = RemoteItunes()
    let stack  = CoreDataStack.sharedInstance
    
    func searchMovies(byTerm: String, remoteHandler: @escaping ([Movie]?) -> Void) {
        
        remoteMovieService.searchMovies(byTerm: byTerm) { movies in
            
            if let movies = movies {
                
                var modelMovies = [Movie]()
                for movie in movies {
                    let modelMovie = Movie(id: movie["id"], title: movie["title"], order: nil, summary: movie["summary"], image: movie["image"], category: movie["category"], director: movie["director"])
                    modelMovies.append(modelMovie)
                }
                remoteHandler(modelMovies)
                
            } else {
                print("Error while calling REST services")
                remoteHandler(nil)
            }
            
        }
        
    }
    
    func getTopMovies(localHandler: ([Movie]?) -> Void, remoteHandler: @escaping ([Movie]?) -> Void) {
        
        localHandler(self.queryTopMovies())
        
        remoteMovieService.getTopMovies() { movies in
            
            
            
            if let movies = movies {
              
                
                
                self.markAllMoviesAsUnsync()
                
                var order = 1
                
                for movieDictionary in movies
                {
                    
                    
                    if let movie = self.getMovieById(id: movieDictionary["id"]!, favorite: false)
                    {
                       
                        self.updateMovie(movieDictionary: movieDictionary, movie: movie, order: order)
                    }
                    else
                    {
                         
                        self.insertMovie(movieDictionary: movieDictionary, order: order)
                    }
                    
                    order += 1
                    
                }
                
                self.removeOldNotFavoritedMovies()
                
                remoteHandler(self.queryTopMovies())
                
            } else {
                remoteHandler(nil)
            }
            
        }
        
        
    }
    
    func queryTopMovies() -> [Movie]? {
        print ("Estamos probando la consulta de todos")
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManaged> = MovieManaged.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        //let predicate = NSPredicate(format: "favorite = \(false)")
        //request.predicate = predicate
        
        do {
            
            let fetchedMovies = try context.fetch(request)
            
            var movies = [Movie]()
            for managedMovie in fetchedMovies
            {
                movies.append(managedMovie.mappedObject())
                 print ("estamos en el retorno de la consulta")
            }
            return movies
            
        } catch {
            print("Error while getting movies from Core Data")
            return nil
        }
        
        
    }
    
    func markAllMoviesAsUnsync() {
        
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManaged> = MovieManaged.fetchRequest()
        
        let predicate = NSPredicate(format: "favorite = \(false)")
        request.predicate = predicate
        
        do {
            
            let fetchedMovies = try context.fetch(request)
            for managedMovie in fetchedMovies {
                managedMovie.sync = false
            }
            
            try context.save()
            
        } catch {
            print("Error while updating Core Data")
        }
        
    }
    
    func getMovieById(id: String, favorite: Bool) -> MovieManaged? {
        
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManaged> = MovieManaged.fetchRequest()
        
        let predicate = NSPredicate(format: "id = \(id) and favorite = \(favorite)")
        request.predicate = predicate
        
        do {
            
            let fetchedMovies = try context.fetch(request)
            if fetchedMovies.count > 0 {
                return fetchedMovies.last
            } else {
                return nil
            }
            
        } catch {
            print("Error while getting movie from Core Data")
            return nil
        }
        
    }
    
    func insertMovie(movieDictionary : [String:String], order: Int) {
        
        let context = stack.persistentContainer.viewContext
        let movie = MovieManaged(context: context)
        
        movie.id = movieDictionary["id"]
        
        updateMovie(movieDictionary: movieDictionary, movie: movie, order: order)
    }
    
    func updateMovie(movieDictionary: [String:String], movie: MovieManaged, order: Int) {
        
        let context = stack.persistentContainer.viewContext
        movie.order = Int16(order)
        movie.title = movieDictionary["title"]
        movie.summary = movieDictionary["summary"]
        movie.category = movieDictionary["category"]
        movie.director = movieDictionary["director"]
        movie.image = movieDictionary["image"]
        movie.sync = true
        
        do {
            try context.save()
            print ("todo salio bien en el contexto")
        } catch {
            print("Error while updating Core Data")
        }
        
    }
    
    func removeOldNotFavoritedMovies() {

        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManaged> = MovieManaged.fetchRequest()
        
        let predicate = NSPredicate(format: "favorite = \(false)")
        request.predicate = predicate
        
        do {
            
            let fetchedMovies = try context.fetch(request)
            for managedMovie in fetchedMovies {
                if !managedMovie.sync {
                    context.delete(managedMovie)
                }
            }
            
            try context.save()
            
        } catch {
            print("Error while deleting from Core Data")
        }
        
    }
    
    func getFavoriteMovies() -> [Movie]? {
        
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManaged> = MovieManaged.fetchRequest()
        
        let predicate = NSPredicate(format: "favorite = \(true)")
        request.predicate = predicate
        
        do {
            
            let fetchedMovies = try context.fetch(request)
            
            var movies : [Movie] = [Movie]()
            for managedMovie in fetchedMovies {
                movies.append(managedMovie.mappedObject())
            }
            
            return movies
            
        } catch {
            print("Error while getting favorites")
            return nil
        }
        
    }
    
    func isMovieFavorite(movie: Movie) -> Bool {
        if let _ = getMovieById(id: movie.id!, favorite: true) {
            return true
        } else {
            return false
        }
    }
    
    func markUnmarkFavorite(movie: Movie) {
        
        let context = stack.persistentContainer.viewContext
        
        if let exist = getMovieById(id: movie.id!, favorite: true) {
            context.delete(exist)
        } else {
            
            let favorite = MovieManaged(context: context)
            
            favorite.id = movie.id
            favorite.title = movie.title
            favorite.summary = movie.summary
            favorite.category = movie.category
            favorite.director = movie.director
            favorite.image = movie.image
            favorite.favorite = true
            
            do {
                
                try context.save()
                
            } catch {
                print("Error while marking as favorite")
            }
            
        }
        // cada ves que se agrega un elemento a favoritos
        // se incrementa o decrementa
        updateFavoritesBadge()

    }
    
    // esta funcion esta mal , porque hace cosas de mas
    // esta funcion  envia al observable el valor del badget , para incrementarlo o decrementarlo
    func updateFavoritesBadge()
    {
        if let totalFavorites = getFavoriteMovies()?.count
        {
            let notification = Notification(name: Notification.Name("updateFavoritesBadgeNotification"), object: totalFavorites, userInfo: nil)
            NotificationCenter.default.post(notification)
        }
    }
    
}
