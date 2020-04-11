//
//  FavouritesTableViewController.swift
//  MovieNight
//
//  Created by Xcode User on 2020-04-11.
//  Copyright © 2020 Shannon Lim. All rights reserved.
//

import UIKit

class FavouritesTableViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mainDelegate = UIApplication.shared.delegate as? AppDelegate
        
        if((mainDelegate?.currentUserID) != nil){
             mainDelegate?.readDataFromDatabase()
        }else{
            print("no user is logged in therefore no users favourites")
        }
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
