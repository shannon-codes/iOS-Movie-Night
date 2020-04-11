//
//  AppDelegate.swift
//  MovieNight
//
//  Created by Xcode User on 2020-03-19.
//  Copyright © 2020 Shannon Lim. All rights reserved.
//

import UIKit
import SQLite3

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var databaseName: String? = "MyDatabase5.db"
    var databasePath: String?
    var favouriteMovies : [Movie] = []
    var currentUserID : String?
    let favMovies = MovieDetailsJsonParser()
    
    // sharing data (from model selected movie object) between objects 
    var selectedMovie: Movie = Movie()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let documentsDir = documentPaths[0]
        
        databasePath = documentsDir.appending("/" + databaseName!)
        
        checkAndCreateDatabase()
        //readDataFromDatabase()
        
        return true
    }
    
    func checkAndCreateDatabase(){
        var success = false
        
        let fileManager = FileManager.default
        
        success = fileManager.fileExists(atPath: databasePath!)
        
        //if file exists then success is true return out of method
        if success{
            return
        }
        
        
        let databasePathFromApp = Bundle.main.resourcePath?.appending("/" + databaseName!)
        
        //copy item in app to item on phone
        try? fileManager.copyItem(atPath: databasePathFromApp!, toPath: databasePath!)
        
        return
    }
    
    //check first if currentuser == "" or null
    func readDataFromDatabase(){
        
        favouriteMovies.removeAll()
        
        var db : OpaquePointer? = nil
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            print("successfully opened connection to database at \(self.databasePath)")
            //malloc memory
            var queryStatement : OpaquePointer? = nil
            let queryStatementString : String = "select * from favourites where userID=?"
            
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK{
                
                let userid = currentUserID! as NSString
                
                sqlite3_bind_text(queryStatement, 1, userid.utf8String, -1, nil)
                
                var setMovieIds = Set<Int>()
                
                while(sqlite3_step(queryStatement) == SQLITE_ROW){
                    
                    let userId : Int = Int(sqlite3_column_int(queryStatement, 0))
                    let movieId : Int = Int(sqlite3_column_int(queryStatement, 2))
                    
                    setMovieIds.insert(movieId)
                    
                    print("query result: " + "\(userId) | \(movieId)")
                    
                }
                //free up malloc'd memory, flush data
                sqlite3_finalize(queryStatement)
                
                favMovies.getDataFromJson(movieIDs: setMovieIds)
                
            }else{
                print("unable to prepare select statement")
            }
            sqlite3_close(db)
        }else{
            print("Database was unable to be opened")
        }
    }
    
    func insertIntoDatabase(myMovie : Movie) -> Bool {
        var db: OpaquePointer? = nil
        var returnCode : Bool = true
        
        if sqlite3_open(self.databasePath, &db) ==  SQLITE_OK {
            
            var insertStatement : OpaquePointer? = nil
            let insertStatementString : String = "insert into favourites values(NULL, ?,?)"
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                
                let uidStr = currentUserID! as NSString
                let midInt32 = Int32(myMovie.mid)
                
                sqlite3_bind_text(insertStatement, 1, uidStr.utf8String, -1, nil)
                sqlite3_bind_int(insertStatement, 2, midInt32)
                
                if sqlite3_step(insertStatement) == SQLITE_DONE{
                    let rowID = sqlite3_last_insert_rowid(db)
                    print("successfully insert row \(rowID)")
                }else{
                    print("could not insert row")
                    returnCode = false
                }
                sqlite3_finalize(insertStatement)
            }else{
                print("insert statement could not be prepared")
                returnCode = false
            }
            
            sqlite3_close(db)
        }
        
        return returnCode
        
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

