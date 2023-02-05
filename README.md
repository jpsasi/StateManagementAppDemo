# SwiftUI State Management Demo Application 

This application demonstrate how to use the State management in SwiftUI Application

This version of the app uses plain vannila swiftui 

- Store reference type is introduced
- AppState made as value type
- All the user actions are defined as enums
- Mutation logic is moved to Reducer
- Reducer takes the State along with Action, will return the new State

- Reducers splitted in to small reducers and combined all the reducers to create the appReducer

### Issues
- Each reducer takes the whole AppState and AppAction eventhough it process the subsets

### Refactor
- Define the Simpler AppState relavent for the reducer

