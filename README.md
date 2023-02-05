# SwiftUI State Management Demo Application 

This application demonstrate how to use the State management in SwiftUI Application

This version of the app uses plain vannila swiftui 

### Issues
- AppState is manipulated in multiple views. It is not scalable

### Refactor
- Change the AppState to Value Type
- Create a Store Reference Type
- Define Action enum for User Actions
- Define Reducer to process the Action to return the new AppState

