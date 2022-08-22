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
            Group {
                if state.currentSession.results.isEmpty {
                    ResultsListEmptyView()
                } else {
                    List {
                        Section(header: Text(ResultsListDictionary.best)) {
                            ResultListRowBestResult(result: state.bestResult)
                            ResultListRowAverage(name: ResultsListDictionary.averageOf5, result: state.bestAvg5)
                            ResultListRowAverage(name: ResultsListDictionary.averageOf12, result: state.bestAvg12)
                            ResultListRowAverage(name: ResultsListDictionary.meanOf100, result: state.bestMean100)
                        }
                        
                        Section(header: Text(ResultsListDictionary.current)) {
                            ResultListRowAverage(name: ResultsListDictionary.averageOf5,
                                                 result: state.currentAvg5)
                            ResultListRowAverage(name: ResultsListDictionary.averageOf12,
                                                 result: state.currentAvg12)
                            ResultListRowAverage(name: ResultsListDictionary.meanOf100,
                                                 result: state.currentMean100)
                        }
                        
                        Section(header: Text(ResultsListDictionary.all + " (\(state.currentSession.results.count))")) {
                            ForEach(state.currentSession.results) { result in
                                ResultListRow(result: result)
                            }
                            .onDelete { offsets in
                                removeResult(at: offsets)
                            }
                        }
                    }
                    .toolbar {
                        EditButton()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle(ResultsListDictionary.results)
        }
        .background(
            Color
                .black
                .ignoresSafeArea()
        )
    }
    
    func removeResult(at offsets: IndexSet) {
        store.dispatch(ResultsViewStateAction.removeResultsAt(offsets))
    }
}

// MARK: - Preview

struct ResultsListView_Previews: PreviewProvider {
    static var previews: some View {
        let session = CubingSession.previewSession
        let resultsListState = ResultsViewState(currentSession: session)
        let store = Store
            .init(initial: .forPreview(screenStates: [.resultsScreen(resultsListState)], session: session), reducer: AppState.reducer)
        ResultsListView()
            .environmentObject(store)
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 13")
        
        let session2 = CubingSession.previewEmptySession
        let resultsListState2 = ResultsViewState(currentSession: session2)
        let store2 = Store
            .init(initial: .forPreview(screenStates: [.resultsScreen(resultsListState2)], session: session2), reducer: AppState.reducer)
        ResultsListView()
            .environmentObject(store2)
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 13")
    }
}

private extension CubingSession {
    static var previewSession: CubingSession {
        let results: [Result] = [
            .init(time: 0.56, scramble: "A B C A B C", date: .init()),
            .init(time: 0.123, scramble: "B C A A B C", date: .init()),
            .init(time: 0.98, scramble: "A B C P O D", date: .init()),
            .init(time: 1.54, scramble: "O S I E M K", date: .init()),
            .init(time: 1.24, scramble: "A B C A B C", date: .init()),
            .init(time: 55.56, scramble: "A B C A B C", date: .init())
        ]
        return CubingSession(results: results, cube: .three, index: 1)
    }
    
    static var previewEmptySession: CubingSession {
        CubingSession(results: [], cube: .three, index: 1)
    }
}
