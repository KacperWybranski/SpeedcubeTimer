//
//  ResultsListView.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 24/03/2022.
//

import SwiftUI

struct ResultsListView: View {
    @ObservedObject private var settings: AppSettings
    private var viewModel: ResultsListViewModel
    
    init(viewModel: ResultsListViewModel) {
        self.viewModel = viewModel
        self.settings = viewModel.settings
    }
    
    var body: some View {
        NavigationView {
            ResultList(session: settings.currentSession, viewModel: viewModel)
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
    @ObservedObject var session: CubingSession
    var viewModel: ResultsListViewModel
    
    var body: some View {
        List {
            ForEach(session.results) { result in
                ResultListRow(result: result)
            }
            .onDelete { offsets in
                viewModel.removeResult(at: offsets)
            }
        }
        .toolbar {
            EditButton()
        }
    }
}

struct ResultListRow: View {
    @State private var isShowingSheet: Bool = false
    var result: Result
    
    var body: some View {
        HStack {
            Text(result.time.asTextWithTwoDecimal)
                .fixedSize(horizontal: true, vertical: true)
            Spacer()
            Text(result.date.formatted())
                .lineLimit(1)
                .foregroundColor(.gray)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isShowingSheet.toggle()
        }
        .sheet(isPresented: $isShowingSheet) {
            ResultDetailView(result: result)
        }
    }
}

// MARK: - Preview

struct ResultsListView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsListView(viewModel: ResultsListViewModel(settings: AppSettings(sessions: [.previewSession])))
            .preferredColorScheme(.dark)
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
