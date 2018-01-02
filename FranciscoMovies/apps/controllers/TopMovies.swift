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
        collectionView.delegate = self
        collectionView.dataSource = self
        
        searchBar.delegate = self// esta clase va cargar
        
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        loadData()
        
        
        // ajustamos el refresco , el objecto que permite entender que hay algo cargando
        refresh.addTarget(self, action: #selector(loadData), for: UIControlEvents.valueChanged)
        
        collectionView.refreshControl?.tintColor = UIColor.white // cambiamos el color del refresco
        collectionView.refreshControl = refresh // le seteamos el refrescontrol , par que lo pinte , cuando se este refrescando el collection view
 
        setCollectionViewPadding()
        
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewPadding
    }
    ///////// imeplementamos los metodos de la celda //
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print ("Que pasa con las peliculas \(movies.count)")
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
            print ("esta es la imagen \(imageData)")
            cell.movieImage.kf.setImage(with: ImageResource(downloadURL: URL(string: imageData)!), placeholder: #imageLiteral(resourceName: "img-loading"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 113, height: 170)
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let term = searchBar.text {
            dataProvider.searchMovies(byTerm: term) { movies in
                if let movies = movies {
                    self.movies = movies
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        searchBar.resignFirstResponder()
                    }
                }
            }
        }
    }
    
    
    @objc func loadData() {
        
        dataProvider.getTopMovies(localHandler: { movies in
            
            if let movies = movies
            {
                print ("estoy en un metodo loadData")
              
                  self.movies = movies
                  print (movies.count)
                
                DispatchQueue.main.async
                    {
                    print ("estoy en un metodo asincrono")
                    print (movies.count)
                    self.collectionView.reloadData()
                }
            } else {
                print("No hay registros en Core Data")
            }
            
        }, remoteHandler: { movies in
            
            if let movies = movies
            {
                print ("estoy en un metodo remoteHandler")
                print (movies.count)
                self.movies = movies
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    // finalizamos el refresco el loading object
                    self.refresh.endRefreshing()
              }
            }
            
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPathSelected = collectionView.indexPathsForSelectedItems?.last {
                let selectedMovie = movies[indexPathSelected.row]
                let detailVC = segue.destination as! ShowMovie
                detailVC.movie = selectedMovie
            }
            hideKeyboard()
        }
    }
    
    //ocultar el teclado
    @objc func hideKeyboard() {
        self.searchBar.resignFirstResponder()
        self.view.removeGestureRecognizer(self.tapGesture)
    }
    
    
}

