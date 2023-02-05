# SwiftUI State Management Demo Application 

This application demonstrate how to use the State management in SwiftUI Application

This version of the app uses plain vannila swiftui 

- Store reference type is introduced
- AppState made as value type
- All the user actions are defined as enums
- Mutation logic is moved to Reducer
- Reducer takes the State along with Action, will return the new State

### Issues
- Eventhough we have 3 different screen, all the reducer implementation is done in single appReducer

### Refactor
- Define small reducer per screen
- Combine all the small reducers

