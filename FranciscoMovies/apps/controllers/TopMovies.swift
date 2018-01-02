//
//  TopMovies.swift
//  FranciscoMovies
//
//  Created by JUAN on 1/01/18.
//  Copyright © 2018 net.juanfrancisco.blog. All rights reserved.
//

import UIKit
import Kingfisher

class TopMovies: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UICollectionViewDelegateFlowLayout {
   
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var searchBar : UISearchBar!
    
    var movies : [Movie] = [Movie]()
    var collectionViewPadding : CGFloat = 0
    let refresh = UIRefreshControl()
    let dataProvider = LocalCoreDataService()
    
    var tapGesture : UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCollectionViewPadding()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        searchBar.delegate = self
        
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        loadData()
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    // calculamos el pading del collection pading , para que quede de 4 columnas
    func setCollectionViewPadding() {
        let screenWidth = self.view.frame.width
        collectionViewPadding = (screenWidth - (3 * 113))/4
    }
    
    // aplicamos el pading calculado
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionViewPadding, left: collectionViewPadding, bottom: collectionViewPadding, right: collectionViewPadding)
    }
    ///////// imeplementamos los metodos de la celda //
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = movies[indexPath.row]
        
        self.configureCell(cell, withMovie: movie)
        
        return cell
    }
    
    func configureCell(_ cell: MovieCell, withMovie movie: Movie) {
        if let imageData = movie.image {
            // con kingfisher y las extenciones sobre el UImage inyectamos el objecto que se encarga de cargar la imagen , adicional a eso le pasamos el ImageResource , una funcion de KingFisher  , donde resolvemos la url de la image , que se cargo antes
            
            // placeholder , colacamos la image img_loading
            cell.movieImage.kf.setImage(with: ImageResource(downloadURL: URL(string: imageData)!), placeholder: #imageLiteral(resourceName: "img-loading"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///// trabajamos la barra de busqueda
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.view.addGestureRecognizer(self.tapGesture)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            loadData()
        }
    }
    
    
    func loadData() {
        
        dataProvider.getTopMovies(localHandler: { movies in
            
            if let movies = movies
            {
                self.movies = movies
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } else {
                print("No hay registros en Core Data")
            }
            
        }, remoteHandler: { movies in
            
            if let movies = movies {
                self.movies = movies
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.refresh.endRefreshing()
                }
            }
            
        })
        
    }
    
    //ocultar el teclado
    @objc func hideKeyboard() {
        self.searchBar.resignFirstResponder()
        self.view.removeGestureRecognizer(self.tapGesture)
    }
    
    
}
