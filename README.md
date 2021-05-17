# YouTV-App
 ### **Table Of Content**
- [YouTV-App](#youtv-app) 
  - [Summery](#summery)
  - [Requirements](#requirements)
  - [Installation](#installation)
  - [Technology use in this project](#technology-use-in-this-project)
  - [Gitwokflow](#gitwokflow)
  - [Extra Information](#extra-information)
      - [Challenges:](#challenges)
      - [Time Efforts](#time-efforts)

## Summery

The Application was written in a Swift 5.3. The App represent Headlines API and Authentication.
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
- Clean Code
- Clean Arch [Reference](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- Modern MVVM  
- Localization
- CI Testing
- Swiftlint
- Jazzy for documentation.
- Github Actions workflow.
- SOLID Principles.
- Dependency Injection based on Factory Strategy.

## Gitwokflow

Please see the Pull Requests in this Repository.
## Extra Information

#### Challenges:

- Dealing With `UICollectionViewCompositionalLayout` to implement Custom Home Layout.
- Finding and exploring the best approach to handle multiple section and item view Model.
- Implementing ViewModel for each specific section and item in Home Presentation Layer.
- Building the Swiftlint Checker and Documents Generator with GitHub Action.
- Following the SOLID Principles.
  
#### Time Efforts

The project took two weeks to develop and deploy.
