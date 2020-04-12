//
//  ViewDetailsViewController.swift
//  MovieNight
//
//  Created by Shannon Lim on 2020-03-21
//
//  Purpose: The purpose of this class is the view controller for displaying more about selected movie with details like poster, title, release date, vote average, and plot overview.

import UIKit

class ViewDetailsViewController: UIViewController {
    
    @IBOutlet var posterImage : UIImageView!
    @IBOutlet var mTitle : UILabel!
    @IBOutlet var mReleaseDate : UILabel!
    @IBOutlet var mVoteAverage : UILabel!
    @IBOutlet var mOverview : UILabel!
    
    let mainDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var selectedMovie : Movie = Movie()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //retrieve the selected movie that was pressed stored in shared AppDelegate
        selectedMovie = mainDelegate!.selectedMovie
        
        //display poster on a remote url
        if(selectedMovie.poster == "unavailable"){
            
            self.posterImage.image = UIImage(named: "poster-placeholder.png")
            
        }else{
            
            let imageURL = URL(string: selectedMovie.poster)
            
            // just not to cause a deadlock in UI!
            DispatchQueue.global().async {
                
                let imageData = try? Data(contentsOf: imageURL!)
                
                let image = UIImage(data: imageData!)
                
                DispatchQueue.main.async {
                    
                    self.posterImage.image = image
                    
                }
            }
        }
        
        //populate UI Labels
        
        mTitle.text = selectedMovie.title
        mReleaseDate.text = selectedMovie.releaseDate
        
        //format the vote average to 2 decimal places
        let numFormatter = NumberFormatter()
        numFormatter.usesGroupingSeparator = true
        numFormatter.maximumFractionDigits = 2
        numFormatter.numberStyle = .decimal
        mVoteAverage.text = numFormatter.string(from: selectedMovie.voteAverage)!
       
        mOverview.text = selectedMovie.overview
    
    }
    
    //Calls the insert to database Sqlite function located int the AppDelegate
    @IBAction func addFavourite(sender: UIButton){
        
        //If user is logged in
        if ((mainDelegate?.currentUserID) != nil){
            
             //check if already in database e.g. duplicate entry
            mainDelegate?.readDataFromDatabase()
            
            var alreadyInDatabase: Bool = false
            
            for favmovie in mainDelegate!.favouriteMovies {
            
                if ( favmovie.mid == selectedMovie.mid ) {
                    alreadyInDatabase = true
                    
                    provideAlert(theTitle: "No Duplicates", theMessage: "It's already in your favourites list")
                    return
                }
            }
            
            // insert to Sqlite database
            if (!alreadyInDatabase){
                //insert choice of movie to favourites table
                let returnCode = mainDelegate!.insertIntoDatabase(myMovie: selectedMovie)
                
                if(returnCode){
                    
                    provideAlert(theTitle: "Success", theMessage: "Successfully added \(selectedMovie.title) to your favourites list")
                    
                    //update the favourites movies objects list based on database query
                    mainDelegate?.readDataFromDatabase()
                    
                }else{
                    provideAlert(theTitle: "Failed", theMessage: "Not able to add \(selectedMovie.title) to your favourites list")
                }
            }
            
            
        }else{
            print("no user is logged in therefore no users favourites")
        }
        
    }
    
    func provideAlert(theTitle: String, theMessage: String){
        
        let alertController = UIAlertController(title: theTitle, message: theMessage, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
        
    }
    
    //TO DO : WATCH TRAILER create json parse method to triggerred by the watch trailer button to generate a youtube path
    //print(selectedMovie.mid) use movie id to call get movie and use key names "key" to combine with youtube path to load video
}
