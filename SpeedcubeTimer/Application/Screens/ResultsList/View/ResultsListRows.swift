//
//  ResultsListRows.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 22/08/2022.
//

import SwiftUI

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
                Text(ResultsListDictionary.single)
                Spacer()
                Text(result?.time.asTextWithTwoDecimal ?? resultPlaceholder)
            }
        }
        .disabled(result.isNil)
    }
}

// MARK: - Preview

struct ResultsListRowsView_Previews: PreviewProvider {
    static var previews: some View {
        let session = CubingSession.previewSession
        let resultsListState = ResultsViewState(currentSession: session)
        let store = Store
            .init(initial: .forPreview(screenStates: [.resultsScreen(resultsListState)], session: session), reducer: AppState.reducer)
        ResultsListView()
            .environmentObject(store)
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
