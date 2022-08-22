//
//  ResultsListWithSectionsView.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 22/08/2022.
//

import SwiftUI

struct ResultsListWithSectionsView: View {
    @EnvironmentObject var store: Store<AppState>
    
    var state: ResultsViewState
    
    var body: some View {
        if state.currentSession.results.isEmpty {
            ResultsListEmptyView()
        } else {
            List {
                Section(header: Text("Best 🏆")) {
                    ResultListRowBestResult(result: state.currentSession.bestResult)
                }
                
                Section(header: Text("Current")) {
                    ResultListRowAverage(name: "average of 5",
                                         result: state.currentAvg5)
                    ResultListRowAverage(name: "average of 12",
                                         result: state.currentAvg12)
                    ResultListRowAverage(name: "mean of 100",
                                         result: state.currentMean100)
                }
                
                Section(header: Text("All")) {
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
        }
    }
    
    func removeResult(at offsets: IndexSet) {
        store.dispatch(ResultsViewStateAction.removeResultsAt(offsets))
    }
}

// MARK: - ResultListRow

struct ResultListRow: View {
    var result: Result
    
    private(set) var withParentheses: Bool = false
    
    var body: some View {
        NavigationLink(destination: {
            ResultDetailView(result: result)
        }) {
            HStack {
                Text(result.time.asTextWithTwoDecimal.wrappedInParentheses(withParentheses))
                    .fixedSize(horizontal: true, vertical: true)
                Spacer()
                Text(result.date.formatted)
                    .lineLimit(1)
                    .foregroundColor(.gray)
            }
        }
    }
    
    func wrappedInParentheses(_ wrapped: Bool) -> some View {
        var newView = self
        newView.withParentheses = wrapped
        return newView
    }
}

// MARK: - ResultListRowAverage

struct ResultListRowAverage: View {
    let resultPlaceholder = "-"
    var name: String
    var result: AverageResult?
    
    var body: some View {
        NavigationLink(destination: {
            if let result = result {
                ResultListAverageList(name: name, result: result)
            }
        }) {
            HStack {
                Text(name)
                Spacer()
                Text(result?.value.asTextWithTwoDecimal ?? resultPlaceholder)
            }
        }
        .disabled(result.isNil)
    }
}

struct ResultListAverageList: View {
    let name: String
    let result: AverageResult
    
    var body: some View {
        List {
            ForEach(result.solves) { solve in
                ResultListRow(result: solve)
                    .wrappedInParentheses([result.solves.best, result.solves.worst].contains(solve))
            }
        }
    }
}

// MARK: - ResultListRowBestResult

struct ResultListRowBestResult: View {
    let resultPlaceholder = "-"
    var result: Result?
    
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
