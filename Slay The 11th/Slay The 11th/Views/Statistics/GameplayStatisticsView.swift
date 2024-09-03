//
//  GameplayStatisticsView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 29/08/2024.
//

import SwiftUI
import Charts
import Pow

struct GameplayStatisticsView: View {
    @State private var playerScores: [PlayerScore] = []
    @State private var selectedDataPoint: PlayerScore? = nil
    @State private var selectedBarData: BarChartData? = nil
    var db: DatabaseManager

    var body: some View {
        VStack {
            Text(NSLocalizedString("gameplay_statistics", comment: "Gameplay Statistics title"))
                .font(.kreonTitle)
                .padding()
            
            // Line Graph for Player Scores
            LineChartView(playerScores: playerScores, selectedDataPoint: $selectedDataPoint)
            
            ZStack {
                Text(String(format: NSLocalizedString("player_finished_stage", comment: "Player finished at stage message"), selectedDataPoint?.name ?? "", selectedDataPoint?.stagesFinished ?? 0))
                    .font(.kreonHeadline)
                    .padding()
                    .foregroundColor(Color(.label))
                    .opacity(selectedDataPoint == nil ? 0 : 1)
                    .transition(.movingParts.wipe(
                        angle: .degrees(-45),
                        blurRadius: 50
                    ))
                    .zIndex(1)
            }
            .animation(.spring(dampingFraction: 1), value: selectedDataPoint)
            
            let barData = prepareBarChartData(playerScores: playerScores)
            BarChartView(barChartData: barData, selectedData: $selectedBarData)
            
            ZStack {
                Text(String(format: NSLocalizedString("chart_label_value", comment: "Chart label with value"), selectedBarData?.label ?? "", selectedBarData?.value ?? 0, selectedBarData?.label == NSLocalizedString("runs_played", comment: "Runs Played label") ? "%.0f" : "%.2f"))
                    .font(.kreonHeadline)
                    .foregroundColor(Color(.label))
                    .padding()
                    .opacity(selectedBarData == nil ? 0 : 1)
                    .transition(.movingParts.wipe(
                        angle: .degrees(-45),
                        blurRadius: 50
                    ))
                    .zIndex(1)
            }
            .animation(.spring(dampingFraction: 1), value: selectedBarData)
        }
        .onAppear {
            playerScores = db.fetchPlayers(limit: 15)
        }
    }

    func calculateWinRate(playerScores: [PlayerScore], winningStage: Int = 10) -> Double {
        let totalRuns = playerScores.count
        let wins = playerScores.filter { $0.stagesFinished >= winningStage }.count
        return totalRuns > 0 ? (Double(wins) / Double(totalRuns)) * 100 : 0
    }
  
    func calculateAverageScore(playerScores: [PlayerScore]) -> Double {
        guard !playerScores.isEmpty else { return 0 }
        let totalScore = playerScores.reduce(0) { $0 + $1.score }
        return Double(totalScore) / Double(playerScores.count)
    }

    func prepareBarChartData(playerScores: [PlayerScore]) -> [BarChartData] {
        let totalRuns = Double(playerScores.count)
        let winRate = calculateWinRate(playerScores: playerScores)
        
        return [
            BarChartData(label: NSLocalizedString("runs_played", comment: "Runs Played label"), value: totalRuns, color: .green),
            BarChartData(label: NSLocalizedString("win_rate", comment: "Win Rate (%) label"), value: winRate, color: .blue)
        ]
    }
}

#Preview {
    GameplayStatisticsView(db: MockDataManager())
}
