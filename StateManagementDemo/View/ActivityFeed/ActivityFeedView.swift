//
//  ActivityFeedView.swift
//  StateManagementDemo
//
//  Created by Sasikumar JP on 05/02/23.
//

import SwiftUI

struct ActivityFeedView: View {
    @ObservedObject var state: AppState
    
    var body: some View {
        ZStack {
            if state.activityFeed.count > 0 {
                List {
                    ForEach(state.activityFeed, id: \.self) { feed in
                        switch feed.type {
                            case let .addedFavoritePrime(prime):
                                Text("Added Favorite Prime \(prime)")
                            case let .removedFavoritePrime(prime):
                                Text("Removed Favorite Prime \(prime)")
                        }
                    }
                }
            } else {
                Text("No Activities")
            }
        }
    }
}

struct ActivityFeedView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityFeedView(state: AppState())
    }
}
