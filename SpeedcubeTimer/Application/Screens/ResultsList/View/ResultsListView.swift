//
//  ResultsListView.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 24/03/2022.
//

import SwiftUI
import ComposableArchitecture

struct ResultsListView: View {
    let store: Store<ResultsListFeature.State, ResultsListFeature.Action>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                Group {
                    if viewStore.currentSession.results.isEmpty {
                        ResultsListEmptyView()
                            .ignoresSafeArea()
                    } else {
                        List {
                            Section(header: Text(ResultsListDictionary.best)) {
                                ResultListRowBestResult(result: viewStore.bestResult)
                                ResultListRowAverage(name: ResultsListDictionary.averageOf5,
                                                     result: viewStore.bestAvg5)
                                ResultListRowAverage(name: ResultsListDictionary.averageOf12,
                                                     result: viewStore.bestAvg12)
                                ResultListRowAverage(name: ResultsListDictionary.meanOf100,
                                                     result: viewStore.bestMean100)
                            }
                            
                            Section(header: Text(ResultsListDictionary.current)) {
                                ResultListRowAverage(name: ResultsListDictionary.averageOf5,
                                                     result: viewStore.currentAvg5)
                                ResultListRowAverage(name: ResultsListDictionary.averageOf12,
                                                     result: viewStore.currentAvg12)
                                ResultListRowAverage(name: ResultsListDictionary.meanOf100,
                                                     result: viewStore.currentMean100)
                            }
                            
                            Section(header: Text(ResultsListDictionary.all + " (\(viewStore.currentSession.results.count))")) {
                                ForEach(viewStore.currentSession.results) { result in
                                    ResultListRow(result: result)
                                }
                                .onDelete { offsets in
                                    viewStore
                                        .send(
                                            .removeResultsAt(offsets)
                                        )
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
            .onAppear {
                viewStore
                    .send(
                        .loadSession
                    )
            }
        }
    }
}

// MARK: - Preview

struct ResultsListView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsListView(
            store: Store(
                initialState: ResultsListFeature.State(),
                reducer: ResultsListFeature(
                    sessionsManager: SessionsManager(session: .previewSession),
                    calculationsPriority: .medium
                )
            )
        )
        .preferredColorScheme(.dark)
        .previewDevice("iPhone 13")
        
        ResultsListView(
            store: Store(
                initialState: ResultsListFeature.State(),
                reducer: ResultsListFeature(
                    sessionsManager: SessionsManager(session: .previewEmptySession),
                    calculationsPriority: .medium
                )
            )
        )
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
        CubingSession()
    }
}
