# YouTV-App

 ### **Table Of Contents**
- [Summery](#summery)
- [Requirements](#requirements)
- [Installation](#installation)
- [Technology use in this project](#technology-use-in-this-project)
- [Gitwokflow](#gitwokflow)
- [Documentation](#documentation)
- [Extra Information](#extra-information)
    - [Challenges](#challenges)
    - [Time Efforts](#time-efforts)

## Summery

The Application was written in a Swift 5.3. The App represent The MovieDB.org API and Authentication as Client.
Application contains the three layers which are the `Data Layer`, `Domain Layer` or `Business Layer` and `Presentation Layer`. The Presnetation layer was architected in MVVM Coordinator. 


## Requirements

- Xcode 12.2 or laster.
- Swift 5.3.1 or later.
- iOS 13.0 or later.

## Installation

- Step 1: Download or clone the project github repository
  
  ```Bash 
    $ git clone https://github.com/farshadmb/YouTV-App
  ```

- Step 2: Install Bundler via Running the below command.

  ```Bash 
    $ gem install bundler 
  ```

  Install Cocoapods via 

  ```Bash
    $ gem install cocoapods --user-install
  ``` 
  
  then run ``` $ pods install ``` command.
  
- Step 3: Open ```YouTVDemo.xcworkspace``` file.
   
- Step 4: Run and enjoy the app.
    
## Technology use in this project

- Reactive Functional Programming
- RxSwift
- Combine
- Clean Code
- Clean Arch [Reference](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- Modern MVVM  
- Coordinator
- SwiftUI
- Localization
- CI Testing
- Swiftlint
- Jazzy for documentation.
- Github Actions workflow.
- SOLID Principles.
- Dependency Injection based on Factory Strategy.

## Documentation

open `Docs` folder at root folder on `master` branch.

> Note: The latest Documentation is placed on `docs` branch. 
> if you want to see it please checkout `docs` then open Docs folder.

## Gitwokflow

Please see the Pull Requests in this Repository.
[Pull Requests](https://github.com/farshadmb/YouTV-App/pulls?q=is%3Apr+is%3Aclosed)

## Extra Information

#### Challenges

- Dealing With `UICollectionViewCompositionalLayout` to implement Custom Home Layout.
- Finding and exploring the best approach to handle multiple section and item view Model.
- Implementing ViewModel for each specific section and item in Home Presentation Layer.
- Building the Swiftlint Checker and Documents Generator with GitHub Action.
- Following the SOLID Principles.
  
#### Time Efforts

*The project took around two weeks to develop and deploy.*
