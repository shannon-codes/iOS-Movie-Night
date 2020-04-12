//
//  ViewController.swift
//  MovieNight
//
//  Created by Shannon Lim on 2020-03-19.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainDelegate = UIApplication.shared.delegate as? AppDelegate
        
        //Get the currently signed in user and store userID in the AppDelegate.swift so I can later select from database by userID
        mainDelegate?.currentUserID = "123"
        
    }





}


