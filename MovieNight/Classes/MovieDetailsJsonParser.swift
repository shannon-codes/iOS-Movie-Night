//
//  MovieDetails.swift
//  MovieNight
//
//  Created by Xcode User on 2020-03-19.
//  Copyright © 2020 Shannon Lim. All rights reserved.
//

import UIKit
import Foundation

class MovieDetailsJsonParser: NSObject {

    //Array of movies objects from parsed Json into movie objects
    var movies: [Movie] = []
    
    var mid : Int = 0
    var title : String = ""
    var fullPosterPath : String = ""
    var voteAverage : NSNumber = 0.0
    var releaseDate : String = ""
    var overview : String = ""
    
    //apiLink[0] is upcoming movies
    //apiLink[1] is now playing movies
    //apiLink[2] is top rated movies
    let apiLink : [String] = ["https://api.themoviedb.org/3/movie/upcoming?api_key=64aee71233303f691dfcb9185c3fd008&language=en-US&page=1&region=US",
    "https://api.themoviedb.org/3/movie/now_playing?api_key=64aee71233303f691dfcb9185c3fd008&language=en-US&region=CA",
    "https://api.themoviedb.org/3/movie/top_rated?api_key=64aee71233303f691dfcb9185c3fd008&language=en-US&page=1&region=CA"]
    
    
    func getDataFromJson(apiChoice: Int){
        if let url = NSURL(string: apiLink[apiChoice]){
            
            if let data = NSData(contentsOf: url as URL){
                do{
                    let parsed = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments)
                   
                    let rootDictionary = parsed as? NSDictionary
                    
                    let arrayOfMovieDictionaries = rootDictionary?["results"] as? NSArray
                    
                    for movie in arrayOfMovieDictionaries! {
                        
                       let movieDict = movie as? NSDictionary
                        
                  
                        mid = (movieDict?["id"] as? Int)!
                    
                        
                        title = (movieDict?["title"] as? String)!
                        
                        if let posterPath = movieDict?["poster_path"] as? String {
                            // obj is a string . Do something with string
                              fullPosterPath="https://image.tmdb.org/t/p/w500"+posterPath
                        }
                        else {
                            // obj is not a string e.g. nil therefore use placeholder
                           
                            fullPosterPath="unavailable"
                        }
                        
                        voteAverage = (movieDict!["vote_average"] as? NSNumber)!
                        
                        releaseDate = (movieDict?["release_date"] as? String)!
                        overview = (movieDict?["overview"] as? String)!
                        
                        //instantiate movie object with movie details
                        
                        let movie = Movie(mid: mid, title: title, poster: fullPosterPath, voteAverage: voteAverage, releaseDate: releaseDate, overview: overview)
                        
                        //add to array of movies objects
                        movies.append(movie)
                        
                    }
                }
                catch let error as NSError{
                    title = "A JSON parsing error has occurred"
                    fullPosterPath = error.description
                }
            }
            
        }
    }
    
    //clear movies array first
    func getDataFromJson(movieIDs: Set<Int>){
        
        movieIDs.forEach { movieID in
          var getMovieApiLink : String = "https://api.themoviedb.org/3/movie/\(movieID)?api_key=64aee71233303f691dfcb9185c3fd008&language=en-US"
       
        if let url = NSURL(string: getMovieApiLink){
            
            if let data = NSData(contentsOf: url as URL){
                do{
                    let parsed = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments)
                    
                    let rootDictionary = parsed as? NSDictionary
                    
                    //let arrayOfMovieDictionaries = rootDictionary?["results"] as? NSArray
                    
                    //for movie in arrayOfMovieDictionaries! {
                        
                        //let movieDict = movie as? NSDictionary
                        
                        
                        mid = (rootDictionary?["id"] as? Int)!
                        
                        
                        title = (rootDictionary?["title"] as? String)!
                        
                        if let posterPath = rootDictionary?["poster_path"] as? String {
                            // obj is a string . Do something with string
                            fullPosterPath="https://image.tmdb.org/t/p/w500"+posterPath
                        }
                        else {
                            // obj is not a string e.g. nil therefore use placeholder
                            
                            fullPosterPath="unavailable"
                        }
                        
                        voteAverage = (rootDictionary!["vote_average"] as? NSNumber)!
                        
                        releaseDate = (rootDictionary?["release_date"] as? String)!
                        overview = (rootDictionary?["overview"] as? String)!
                        
                        //instantiate movie object with movie details
                    
                    print("\(mid)"+title+fullPosterPath+"\(voteAverage)"+releaseDate+overview)
                    
                        let movie = Movie(mid: mid, title: title, poster: fullPosterPath, voteAverage: voteAverage, releaseDate: releaseDate, overview: overview)
                        
                        //add to array of movies objects
                        movies.append(movie)
                        
                    
                }
                catch let error as NSError{
                    title = "A JSON parsing error has occurred"
                    fullPosterPath = error.description
                }
            }
            
        }
        }
    }
    
}


