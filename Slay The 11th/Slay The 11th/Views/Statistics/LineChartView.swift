//
//  LineChartView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 29/08/2024.
//

import SwiftUI
import Charts

struct LineChartView: View {
    var playerScores: [PlayerScore]
    @Binding var selectedDataPoint: PlayerScore?

    var body: some View {
        Chart {
            ForEach(Array(playerScores.enumerated()), id: \.element.id) { index, score in
                LineMark(
                    x: .value("Run Number", index + 1),
                    y: .value("Score", score.score)
                )
                .symbol(.circle)
                .foregroundStyle(.blue)
            }
        }
        .chartOverlay { proxy in
            GeometryReader { geometry in
                Rectangle().fill(Color.clear).contentShape(Rectangle())
                    .onTapGesture { location in
                        let xPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
                        if let closestXIndex = proxy.value(atX: xPosition, as: Int.self) {
                            if closestXIndex > 0 && closestXIndex <= playerScores.count {
                                selectedDataPoint = playerScores[closestXIndex - 1]
                            }
                        }
                    }
            }
        }
        .frame(height: 200)
        .padding()
    }
}



#Preview {
  LineChartView(playerScores: [
    PlayerScore(id: "1", name: "Player 1", score: 100, stagesFinished: 5),
    PlayerScore(id: "2", name: "Player 2", score: 150, stagesFinished: 7),
    PlayerScore(id: "3", name: "Player 3", score: 200, stagesFinished: 10),
    PlayerScore(id: "4", name: "Player 4", score: 120, stagesFinished: 6),
    PlayerScore(id: "5", name: "Player 5", score: 180, stagesFinished: 8),
  ], selectedDataPoint: .constant(nil))
}
