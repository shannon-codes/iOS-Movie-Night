//
//  ViewDetailsViewController.swift
//  MovieNight
//
//  Created by Xcode User on 2020-03-21.
//  Copyright © 2020 Shannon Lim. All rights reserved.
//

import UIKit

class ViewDetailsViewController: UIViewController {
    
    @IBOutlet var posterImage : UIImageView!
    @IBOutlet var mTitle : UILabel!
    @IBOutlet var mReleaseDate : UILabel!
    @IBOutlet var mVoteAverage : UILabel!
    @IBOutlet var mOverview : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let mainDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let selectedMovie : Movie = mainDelegate!.selectedMovie

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
        
        mTitle.text = selectedMovie.title
        mReleaseDate.text = selectedMovie.releaseDate
        
        let numFormatter = NumberFormatter()
        numFormatter.usesGroupingSeparator = true
        numFormatter.maximumFractionDigits = 2
        numFormatter.numberStyle = .decimal
        
       mVoteAverage.text = numFormatter.string(from: selectedMovie.voteAverage)!
       
        
       mOverview.text = selectedMovie.overview
    
    }
    
    //TO DO : create json parse method to triggerred by the watch trailer button to generate a youtube path
    //print(selectedMovie.mid) use movie id to call get movie and use key names "key" to combine with youtube path to load video
}
