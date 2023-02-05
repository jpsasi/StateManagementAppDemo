//
//  CounterView.swift
//  StateManagementDemo
//
//  Created by Sasikumar JP on 04/02/23.
//

import SwiftUI

struct CounterView: View {
    @ObservedObject var store: Store<AppState, CounterAction>
    @State var primeModalShown: Bool = false
    @State var alertNthPrime: PrimeAlert? = nil
    @State var isNthPrimeButtonDisabled = false
    
    var body: some View {
        VStack {
            HStack {
                Button("-") {
                    store.send(.decrTapped)
                }
                Text("\(store.value.count)")
                Button("+") {
                    store.send(.incrTapped)
                }
            }
            Button("Is this prime?") {
                primeModalShown = true
            }
            .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
            HStack {
                Button("What is \(ordinal(store.value.count)) prime") {
                    isNthPrimeButtonDisabled = true
                    nthPrime(store.value.count) { result in
                        isNthPrimeButtonDisabled = false
                        if let result = result {
                            alertNthPrime = PrimeAlert(prime: result)
                        }
                    }
                }
                .disabled(isNthPrimeButtonDisabled)
                .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
                if isNthPrimeButtonDisabled {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 0))
                }
            }
        }
        .sheet(isPresented: $primeModalShown) {
            NavigationView {
                PrimeModalView(store: store)
                    .toolbar {
                        Button("Cancel") {
                            primeModalShown = false
                        }
                    }
            }
            .navigationTitle("Prime Modal")
        }
        .alert(item: $alertNthPrime, content: { nthPrime in
            Alert(title: Text("\(ordinal(store.value.count)) Prime is \(nthPrime.prime)"))
        })
        .navigationTitle("Counter View")
    }
    
    private func ordinal(_ n: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(for: n) ?? ""
    }
}

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CounterView(store: Store(initialValue: AppState(), reducer: counterReducer))
        }
    }
}
