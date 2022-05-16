//
//  ResultsListView.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 24/03/2022.
//

import SwiftUI

struct ResultsListView: View {
    @EnvironmentObject var store: Store<AppState>
    
    var state: ResultsViewState { store.state.screenState(for: .resultsList) ?? .init() }
    
    var body: some View {
        NavigationView {
            List {
                Section("Best") {
                    ResultListRowBestResult(result: state.currentSession.bestResult)
                }
                
                Section("Current") {
                    ResultListRowAverage(name: "average of 5",
                                         result: "to implement")
                    ResultListRowAverage(name: "average of 12",
                                         result: "to implement")
                    ResultListRowAverage(name: "mean of 100",
                                         result: "to implement")
                }
                
                Section("All") {
                    ForEach(state.currentSession.results) { result in
                        ResultListRow(result: result)
                    }
                    .onDelete { offsets in
                        removeResult(at: offsets)
                    }
                }
            }
            .toolbar {
                if !state.currentSession.results.isEmpty {
                    EditButton()
                }
            }
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("Results")
        }
        .background {
            Color
                .black
                .ignoresSafeArea()
        }
    }
    
    func removeResult(at offsets: IndexSet) {
        store.dispatch(ResultsViewStateAction.removeResultsAt(offsets))
    }
}

struct ResultListRow: View {
    var result: Result
    
    var body: some View {
        NavigationLink(destination: {
            ResultDetailView(result: result)
        }) {
            HStack {
                Text(result.time.asTextWithTwoDecimal)
                    .fixedSize(horizontal: true, vertical: true)
                Spacer()
                Text(result.date.formatted())
                    .lineLimit(1)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct ResultListRowAverage: View {
    var name: String
    var result: String
    
    var body: some View {
        HStack {
            Text(name)
            Spacer()
            Text(result)
        }
    }
    
    
}

struct ResultListRowBestResult: View {
    var result: Result?
    var resultPlaceholder = "-"
    
    var body: some View {
        NavigationLink(destination: {
            if let result = result {
                ResultDetailView(result: result)
            }
        }) {
            HStack {
                Text("Single")
                Spacer()
                Text(result?.time.asTextWithTwoDecimal ?? resultPlaceholder)
            }
        }
        .disabled(result.isNil)
    }
}

// MARK: - Preview

struct ResultsListView_Previews: PreviewProvider {
    static var previews: some View {
        let resultsListState = ResultsViewState(currentSession: .previewSession)
        let store = Store
            .init(initial: AppState(screens: [.resultsScreen(resultsListState)]),
                  reducer: AppState.reducer)
        ResultsListView()
            .environmentObject(store)
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 13")
    }
}

private extension CubingSession {
    static var previewSession: CubingSession {
        let results: [Result] = [
            .init(time: 0.56, scramble: "A B C A B C", date: .now),
            .init(time: 0.123, scramble: "B C A A B C", date: .now),
            .init(time: 0.98, scramble: "A B C P O D", date: .now),
            .init(time: 1.54, scramble: "O S I E M K", date: .now),
            .init(time: 1.24, scramble: "A B C A B C", date: .now),
            .init(time: 55.56, scramble: "A B C A B C", date: .now)
        ]
        return CubingSession(results: results, cube: .three, index: 1)
    }
}
