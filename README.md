# SwiftUI State Management Demo Application 

This application demonstrate how to use the State management in SwiftUI Application

This version of the app uses plain vannila swiftui 

- Store reference type is introduced
- AppState made as value type
- All the user actions are defined as enums
- Mutation logic is moved to Reducer
- Reducer takes the State along with Action, will return the new State

- Reducers splitted in to small reducers and combined all the reducers to create the appReducer
- Reducers are modified to operate with relavent data instead of whole app state
- counterReducer is modified to work with CounterAction (Pullback is created to work with both State and Action)

### Issues
- reducer is operating on whole AppAction

### Refactor
- Modify the code PrimeModal and FavoritePrimes to work with respective actions

