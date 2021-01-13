# iOS-Movie-Night
This was my final group project for iOS Mobile Application Development. It was a team project alongside Scott, Andrei, and Afsar.

Programming Language: Swift
Development Environment: Xcode 10.3, deployment target is minimum iOS 12.4, iPhone XR Simulator

Result: Our team received a project grade of 88%.

Features I implemented were:

  1. Movie Poster Screen 
    - Make HTTP Request to The Movie Database API (themoviedb.org) to fetch movie details from themoviedb.org server
    - Service class to Parse JSON Response to any array of model Movie struct
    - Display Movies in Collection View updated by Segmented Control for Upcoming, Now Playing, Top Rated movie categories
    
  2. Movie Details Screen:
    - Title, Release Date, Vote Rating Average
    - Add to Favorites - Insert user's favourite movie id to SQLITE3 internal database
    - Set Reminder - Schedule local push notifications set to movie theatre release date using UserNotification Framework
    
  3. Favourites Screen:
    - Read/Delete movies from SQLITE3 internal database
    - Display favourite movies in a Table View
    - Swipe Right on any movie row to Delete
    
  4. Navigation:
    - Navigation Controller and TabBar Controller
    
  5. Integration:
    - Integrate and merge together all the team members storyboards and View Controllers
    
## Screenshots:

![Login, Register, Movie Collections, Movie Details](screenshots/screens1.png)

![Favorites, Map Directions](screenshots/screens2.png)

