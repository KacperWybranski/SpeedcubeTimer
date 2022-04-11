//
//  ResultsListView.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 24/03/2022.
//

import SwiftUI

struct ResultsListView: View {
    @ObservedObject private var appState: AppState
    private var viewModel: ResultsListViewModel
    
    init(viewModel: ResultsListViewModel) {
        self.viewModel = viewModel
        self.appState = viewModel.appState
    }
    
    var body: some View {
        NavigationView {
            ResultList(session: appState.currentSession, viewModel: viewModel)
                .navigationBarTitleDisplayMode(.large)
                .navigationTitle("Results")
        }
        .background {
            Color
                .black
                .ignoresSafeArea()
        }
    }
}

struct ResultList: View {
    var session: CubingSession
    var viewModel: ResultsListViewModel
    
    var body: some View {
        List {
            Section("Best") {
                ResultListRowBestResult(result: session.bestResult)
            }
            
            Section("Current") {
                ResultListRowAverage(name: viewModel.averageName(.five),
                                     result: viewModel.averageOfLast(5))
                ResultListRowAverage(name: viewModel.averageName(.twelve),
                                     result: viewModel.averageOfLast(12))
                ResultListRowAverage(name: viewModel.averageName(.hundred),
                                     result: viewModel.meanOfLast(100))
            }
            
            Section("All") {
                ForEach(session.results) { result in
                    ResultListRow(result: result)
                }
                .onDelete { offsets in
                    viewModel.removeResult(at: offsets)
                }
            }
        }
        .toolbar {
            EditButton()
        }
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
        ResultsListView(viewModel: ResultsListViewModel(appState: AppState(sessions: [.previewSession])))
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
        return CubingSession(results: results, cube: .three, session: 1)
    }
}
