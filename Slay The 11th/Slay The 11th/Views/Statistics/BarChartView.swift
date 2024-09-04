/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 2
  Author: Duong Tran Minh Hoang
  ID: 3978452
  Created  date: 29/08/2024
  Last modified: 04/09/2024
  Acknowledgement: None
*/

import SwiftUI
import Charts

struct BarChartView: View {
    var barChartData: [BarChartData]
    @Binding var selectedData: BarChartData?

    var body: some View {
        VStack {
            Chart {
                ForEach(barChartData) { data in
                    BarMark(
                        x: .value("Category", data.label),
                        y: .value("Value", data.value)
                    )
                    .foregroundStyle(data.color)
                }
            }
            .chartXAxis(.hidden) // Hide x-axis
            .chartYAxis(.hidden) // Hide y-axis
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    Rectangle()
                        .fill(Color.clear)
                        .contentShape(Rectangle()) // Makes the rectangle tappable
                        .onTapGesture { location in
                            let xPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
                            if let tappedIndex = proxy.value(atX: xPosition, as: String.self),
                               let tappedData = barChartData.first(where: { $0.label == tappedIndex }) {
                                selectedData = tappedData
                            }
                        }
                }
            }
            .frame(height: 200)
            .padding()
        }
    }
}


struct BarChartData: Identifiable, Equatable {
    let id = UUID()
    let label: String
    let value: Double
    let color: Color
  
    static func ==(lhs: BarChartData, rhs: BarChartData) -> Bool {
        return lhs.label == rhs.label &&
               lhs.value == rhs.value &&
               lhs.color == rhs.color
    }
}


