//
//  ActivityFeedView.swift
//  StateManagementDemo
//
//  Created by Sasikumar JP on 05/02/23.
//

import SwiftUI

struct ActivityFeedView: View {
    @ObservedObject var store: Store<AppState, CounterAction>
    
    var body: some View {
        ZStack {
            if store.value.activityFeed.count > 0 {
                List {
                    ForEach(store.value.activityFeed, id: \.self) { feed in
                        switch feed.type {
                            case let .addedFavoritePrime(prime):
                                Text("Favorite Prime \(prime) - Added")
                            case let .removedFavoritePrime(prime):
                                Text("Favorite Prime \(prime) Removed")
                        }
                    }
                }
                .listStyle(.plain)
            } else {
                Text("No Activities")
            }
        }
        .navigationTitle("Activity Feed")
    }
}

struct ActivityFeedView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityFeedView(store: Store(initialValue: AppState(), reducer: counterReducer))
    }
}
