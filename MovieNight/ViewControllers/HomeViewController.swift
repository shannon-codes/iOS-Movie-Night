//
//  HomeViewController.swift
//  MovieNight
//
//  Created by Xcode User on 2020-03-20.
//  Copyright © 2020 Shannon Lim. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    let movieData = MovieDetailsJsonParser()
    
    @IBOutlet var sgMovieCategory : UISegmentedControl!
    @IBOutlet weak var collectionView1 : UICollectionView!
    let reuseIdentifier = "featuredCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateAPI()
        
        print("goodbye")
        
        //put after login page on homepage or favourites pageview controller
        //FireBase get currently signed in user
        //https://firebase.google.com/docs/auth/ios/manage-users#get_a_users_profile
        //let user = Auth.auth().currentUser
        //    if let user = user {
        //        // The user's ID, unique to the Firebase project.
        //        // Do NOT use this value to authenticate with your backend server,
        //        // if you have one. Use getTokenWithCompletion:completion: instead.
        //        let uid = user.uid
        //        let email = user.email
        //        let photoURL = user.photoURL
        //    }
        //store uid in appdelegate
       
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 50
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 50
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0.0, left: 50.0, bottom: 0.0, right: 50.0)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectionView1{
            return movieData.movies.count
        }
        
        return 0
    }
    //provide content for each custom cell of type FeaturedCollectionCell.swift
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView == self.collectionView1){
            let cell : FeaturedCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! FeaturedCollectionViewCell
            
            
            if(movieData.movies[indexPath.row].poster == "unavailable"){
                
                        cell.featuredImage.image = UIImage(named: "poster-placeholder.png")
                
            }else{
                //display an image from a remote url
                let imageURL = URL(string: movieData.movies[indexPath.row].poster)
                
                // just not to cause a deadlock in UI!
                DispatchQueue.global().async {
                    let imageData = try? Data(contentsOf: imageURL!)
                    
                    let image = UIImage(data: imageData!)
                    DispatchQueue.main.async {
                        
                        cell.featuredImage.image = image
                    
                    }
                }
                
            }

            cell.lblTitle.text = movieData.movies[indexPath.row].title
            
            cell.lblReleaseDate.text = movieData.movies[indexPath.row].releaseDate
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let mainDelegate = UIApplication.shared.delegate as? AppDelegate
        
        mainDelegate?.selectedMovie = movieData.movies[indexPath.row]
        
        performSegue(withIdentifier: "SegueToMovieDetails", sender: nil)
    }
    
    func updateAPI(){
        let diff = sgMovieCategory.selectedSegmentIndex // selectedSegmented index part o UISegmentedCOntrol
        
        if diff == 0 {
            
            movieData.getDataFromJson(apiChoice: 0)
            
        }else if diff == 1 {
            
            movieData.getDataFromJson(apiChoice: 1)
        }else{
            movieData.getDataFromJson(apiChoice: 2)
        }
        
    }
    
    @IBAction func segmentValueChanged(sender:UISegmentedControl){
        movieData.movies.removeAll()
        updateAPI()
        
        collectionView1.reloadData()
        // Reload Data
        collectionView1.reloadItems(at: collectionView1.indexPathsForVisibleItems)
        
        print(movieData.movies.count)
        
        print(movieData.movies[0].title)
    }
    
    
    @IBAction func unwindToHomeVC(Sender: UIStoryboardSegue){
        
    }

}
