//
//  LineChartViewUIView.swift
//  Alfred
//
//  Created by John Pillar on 12/06/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import SwiftUI
import Charts

struct LineChartUIView: UIViewRepresentable {
    var lineData: [(Double)] = []
    var secondLineData: [(Double)] = []
    var threshhold: Double = 0

    func makeUIView(context: Context) -> LineChartView {
        let chart = LineChartView()

        // Format chart
        chart.noDataText = "No data to display"
        chart.noDataTextColor = UIColor.white

        chart.legend.enabled = false
        chart.drawBordersEnabled = false

        chart.rightAxis.enabled = false
        chart.xAxis.enabled = false

        chart.leftAxis.labelTextColor = .white
        chart.leftAxis.drawAxisLineEnabled = false
        chart.leftAxis.drawGridLinesEnabled = false
        chart.leftAxis.drawLimitLinesBehindDataEnabled = true
        chart.leftAxis.axisMinimum = 0

        chart.setScaleEnabled(true)
        chart.doubleTapToZoomEnabled = false
        chart.dragEnabled = false
        chart.pinchZoomEnabled = false
        chart.highlightPerTapEnabled = false

        // swiftlint:disable control_statement
        if (threshhold > 0) {
            let ll1 = ChartLimitLine(limit: threshhold, label: "")
            ll1.lineWidth = 2
            ll1.lineDashLengths = [5, 5]
            ll1.labelPosition = .topRight
            ll1.valueFont = .systemFont(ofSize: 10)
            chart.leftAxis.addLimitLine(ll1)
        }

        // Add line data
        chart.data = addLineData()

        return chart
    }

    func updateUIView(_ uiView: LineChartView, context: Context) {
        uiView.data = addLineData()
    }

    func addLineData() -> LineChartData {
        let set1ChartData = (0..<lineData.count).map { (item) -> ChartDataEntry in
            let val = lineData[item].rounded(.up)
            return ChartDataEntry(x: Double(item), y: Double(val))
        }
        let set1 = LineChartDataSet(entries: set1ChartData, label: "")

        // Format dataset
        set1.drawCirclesEnabled = false
        set1.lineWidth = 1
        set1.drawValuesEnabled = false
        set1.setColor(UIColor.green)

        let set2ChartData = (0..<secondLineData.count).map { (item) -> ChartDataEntry in
            let val = secondLineData[item].rounded(.up)
            return ChartDataEntry(x: Double(item), y: Double(val))
        }
        let set2 = LineChartDataSet(entries: set2ChartData, label: "")

        // Format dataset
        set2.drawCirclesEnabled = false
        set2.lineWidth = 1
        set2.drawValuesEnabled = false
        set2.setColor(UIColor.gray)

        let data = LineChartData(dataSets: [set1, set2])

        return data
    }
    typealias UIViewType = LineChartView
 }

#if DEBUG
struct LineChartUIView_Previews: PreviewProvider {

    static var arrayItem = 0
    static func chartDataMoisture () -> [Double] {
        var mockSensorDataItem = MockSensorDataItem()
        return (0..<(mockSensorDataItem.data?[arrayItem].readings.count)!).map { (item) in
            return mockSensorDataItem.data![arrayItem].readings[item].moisture.rounded(.down)
        }
    }

    static func chartDataBattery () -> [Double] {
        var mockSensorDataItem = MockSensorDataItem()
        return (0..<(mockSensorDataItem.data?[arrayItem].readings.count)!).map { (item) in
            return Double(mockSensorDataItem.data![arrayItem].readings[item].battery).rounded(.down)
        }
    }

    static func chartDataThreshhold () -> Double {
        var mockSensorDataItem = MockSensorDataItem()
        return Double(mockSensorDataItem.data![arrayItem].thresholdMoisture)
    }

    static var previews: some View {
        ZStack {
            Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            LineChartUIView(
                lineData: chartDataMoisture(),
                secondLineData: chartDataBattery(),
                threshhold: chartDataThreshhold()
            )
                .frame(height: 140)
        }
    }
}
#endif
