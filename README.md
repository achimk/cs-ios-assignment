# iOS Assignment CS

This is a placeholder README file with the instructions for the assingment. We expect you to build your own README file.

## Instructions

You can find all the instrucrtions for the assingment on [Assingment Instructions](https://docs.google.com/document/d/1zCIIkybu5OkMOcsbuC106B92uqOb3L2PPo9DNFBjuWg/edit?usp=sharing).

## Delivering the code
* Fork this repo and select the access level as private **[Check how to do it here](https://confluence.atlassian.com/bitbucket/forking-a-repository-221449527.html)**
* Go to settings and add the user **m-cs-recruitment@backbase.com** with the read access **[Check how to do it here](https://confluence.atlassian.com/bitbucket/grant-repository-access-to-users-and-groups-221449716.html)**
* Send an e-mail to **m-cs-recruitment@backbase.com** with your info and repo once the development is done

Please remember to work with small commits, it help us to see how you improve your code :)

# Solution

## Architecture

Example application was prepared with clean architecture pattern with advantage of using vertical slices (represented by Movies feature folder). More about this solution you can find **[here](https://www.youtube.com/watch?v=5kOzZz2vj2o)** or in Clean Architecture book supplement by Jimmy Bogard.

## Third Party Libraries

Current example was build by using popular libraries, integrated by Cocoapods package manager:

* RxSwift (5.1.1) - used for reactive programming,
* RxCocoa (5.1.1) - used for reactive programing in UI,
* Reusable (4.1.1) - used for dequeue and register custom cells or views,
* Kingfisher (6.1.0) - used for image cacheing on disk,
* TagListView (1.4.1) - used for displaying movie genres as list of tags,

## Issues
* missing flow controllers for coordinates from one screen to another,
* missing mapper tests for conversion from `Response` to `Entity`,
* missing initial loading and error handling screens like `MovieDetails` screen for `HomeMovies` screen,