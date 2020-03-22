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

    var mid : Int = 0
    var title : String = ""
    var fullPosterPath : String = ""
    var voteAverage : NSNumber = 0.0
    var releaseDate : String = ""
    var overview : String = ""

//apiLink[0] is upcoming movies
    //apiLink[0] is now playing movies
    let apiLink : [String] = ["https://api.themoviedb.org/3/movie/upcoming?api_key=64aee71233303f691dfcb9185c3fd008&language=en-US&page=1&region=US",
    "https://api.themoviedb.org/3/movie/now_playing?api_key=64aee71233303f691dfcb9185c3fd008&language=en-US&region=CA",
    "https://api.themoviedb.org/3/movie/top_rated?api_key=64aee71233303f691dfcb9185c3fd008&language=en-US&page=1&region=CA"]
    var movies: [Movie] = []
    
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
                        
                        //print(title)
                        
                        if let posterPath = movieDict?["poster_path"] as? String {
                            // obj is a string array. Do something with stringArray
                              fullPosterPath="https://image.tmdb.org/t/p/w500"+posterPath
                        }
                        else {
                            // obj is not a string array
                            //fullPosterPath="https://i2.wp.com/www.theatrecr.org/wp-content/uploads/2016/01/poster-placeholder.png"
                            fullPosterPath="unavailable"
                        }
                        
                        voteAverage = (movieDict!["vote_average"] as? NSNumber)!
                        
                        releaseDate = (movieDict?["release_date"] as? String)!
                        overview = (movieDict?["overview"] as? String)!
                        
                        let movie = Movie(mid: mid, title: title, poster: fullPosterPath, voteAverage: voteAverage, releaseDate: releaseDate, overview: overview)
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
    
}


