//
//  ViewController.swift
//  MovieNight
//
//  Created by Xcode User on 2020-03-19.
//  Copyright © 2020 Shannon Lim. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //var set3: Set<Int> = [446893,514847,508439]
        //MovieDetailsJsonParser().getDataFromJson(movieIDs: set3)
        let mainDelegate = UIApplication.shared.delegate as? AppDelegate
        mainDelegate?.currentUserID = "123"
        
        print("helo")
    }





}


