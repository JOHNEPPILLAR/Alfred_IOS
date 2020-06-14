//
//  LineChartViewUIView.swift
//  Alfred
//
//  Created by John Pillar on 12/06/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import SwiftUI

struct LineChartUIView: View {
    var data: [(Double)]
    var batteryData: [(Double)]?
    var title: String?
    var threshhold: Double?

    public init(data: [Double],
                batteryData: [Double]? = nil,
                title: String? = nil,
                threshhold: Double? = nil) {
        self.data = data
        self.batteryData = batteryData
        self.title = title
        self.threshhold = threshhold
    }

    var globalMin: Double {
        if let min = data.min() {
            return min
        }
        return 0
    }

    var globalMax: Double {
        if let max = data.max() {
            return max
        }
        return 0
    }

    public var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    if self.title != nil {
                        Text(self.title ?? "")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .offset(x: 10, y: 0)
                        Spacer()
                        Text("Current: \(String(format: "%.0f", self.data.last ?? 0))/" +
                             "\(String(format: "%.0f", self.threshhold ?? 0))")
                            .fontWeight((self.data.last ?? 0) <= (self.threshhold ?? 0) ? .bold : .light)
                            .foregroundColor((self.data.last ?? 0) <= (self.threshhold ?? 0) ? .red : .white)
                            .offset(x: -10, y: 0)
                    }
                }
                Spacer()
                Spacer()
                GeometryReader { reader in
                    ZStack {
                        if self.threshhold != nil {
                            Line( // Battery
                                data: self.batteryData ?? [],
                                lineColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).color,
                                dashLine: false,
                                minDataValue: .constant(self.globalMin),
                                maxDataValue: .constant(self.globalMax),
                                frame: .constant(CGRect(
                                x: 0,
                                y: 0,
                                width: reader.frame(in: .local).width - 30,
                                height: reader.frame(in: .local).height))
                            )

                            Line( // Threshhold
                                data: [Double](repeating: self.threshhold ?? 0.0, count: self.data.count),
                                lineColor: #colorLiteral(red: 0.8078431487, green: 0.2911018658, blue: 0.3674803542, alpha: 1).color,
                                dashLine: true,
                                minDataValue: .constant(self.globalMin),
                                maxDataValue: .constant(self.globalMax),
                                frame: .constant(CGRect(
                                x: 0,
                                y: 0,
                                width: reader.frame(in: .local).width - 30,
                                height: reader.frame(in: .local).height))
                            )
                        }
                        Line(
                            data: self.data,
                            lineColor: Color.green,
                            dashLine: false,
                            minDataValue: .constant(self.globalMin),
                            maxDataValue: .constant(self.globalMax),
                            frame: .constant(CGRect(
                            x: 0,
                            y: 0,
                            width: reader.frame(in: .local).width - 30,
                            height: reader.frame(in: .local).height))
                        )
                    }
                }
                .offset(x: 10, y: -30)
            }
        }
    }
}

#if DEBUG
struct LineChartUIView_Previews: PreviewProvider {

    static func chartDataMoisture () -> [Double] {
        let mockSensorDataItem = MockSensorDataItem()
        return (0..<mockSensorDataItem.data[1].readings.count).map { (item) in
            return mockSensorDataItem.data[1].readings[item].moisture.rounded(.down)
        }
    }

    static func chartDataBattery () -> [Double] {
        let mockSensorDataItem = MockSensorDataItem()
        return (0..<mockSensorDataItem.data[1].readings.count).map { (item) in
            return Double(mockSensorDataItem.data[1].readings[item].battery)
        }
    }

    static func chartDataTitle () -> String {
        let mockSensorDataItem = MockSensorDataItem()
        return mockSensorDataItem.data[1].plantname
    }

    static func chartDataThreshhold () -> Double {
        let mockSensorDataItem = MockSensorDataItem()
        return mockSensorDataItem.data[1].thresholdmoisture
    }

    static var previews: some View {
        ZStack {
            Color(#colorLiteral(red: 0.1439366937, green: 0.1623166203, blue: 0.2411367297, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            LineChartUIView(
                data: chartDataMoisture(),
                batteryData: chartDataBattery(),
                title: chartDataTitle(),
                threshhold: chartDataThreshhold()
            )
        }
    }
}
#endif

struct Line: View {
    var data: [(Double)]
    var lineColor: Color = Color.green
    var dashLine: Bool = false

    @Binding var minDataValue: Double?
    @Binding var maxDataValue: Double?
    @Binding var frame: CGRect

    let padding: CGFloat = 30

    var stepWidth: CGFloat {
        if data.count < 2 {
            return 0
        }
        return frame.size.width / CGFloat(data.count-1)
    }
    var stepHeight: CGFloat {
        var min: Double?
        var max: Double?
        let points = self.data
        if minDataValue != nil && maxDataValue != nil {
            min = minDataValue!
            max = maxDataValue!
        } else if let minPoint = points.min(), let maxPoint = points.max(), minPoint != maxPoint {
            min = minPoint
            max = maxPoint
        } else {
            return 0
        }
        if let min = min, let max = max, min != max {
            if min <= 0 {
                return (frame.size.height-padding) / CGFloat(max - min)
            } else {
                return (frame.size.height-padding) / CGFloat(max + min)
            }
        }
        return 0
    }

    var path: Path {
        let points = self.data
        return Path.quadCurvedPathWithPoints(
                points: points,
                step: CGPoint(
                x: stepWidth,
                y: stepHeight),
                globalOffset: minDataValue)
    }

    let dashStyle = StrokeStyle(lineWidth: 3, dash: [5, 5])
    let lineStyle = StrokeStyle(lineWidth: 3, lineJoin: .round)

    public var body: some View {
        ZStack {
            self.path
                .stroke(lineColor, style: dashLine ? dashStyle : lineStyle)
                .rotationEffect(.degrees(180), anchor: .center)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .drawingGroup()
        }
    }
}

extension Path {
    static func quadCurvedPathWithPoints(
            points: [Double],
            step: CGPoint,
            globalOffset: Double? = nil) -> Path {
        var path = Path()
        if points.count < 2 {
            return path
        }
        let offset = globalOffset ?? points.min()!
        var p1 = CGPoint(x: 0, y: CGFloat(points[0]-offset)*step.y)
        path.move(to: p1)
        for pointIndex in 1..<points.count {
            let p2 = CGPoint(x: step.x * CGFloat(pointIndex), y: step.y*CGFloat(points[pointIndex]-offset))
            let midPoint = CGPoint.midPointForPoints(p1: p1, p2: p2)
            path.addQuadCurve(to: midPoint, control: CGPoint.controlPointForPoints(p1: midPoint, p2: p1))
            path.addQuadCurve(to: p2, control: CGPoint.controlPointForPoints(p1: midPoint, p2: p2))
            p1 = p2
        }
        return path
    }
}

extension CGPoint {
    static func midPointForPoints(p1: CGPoint, p2: CGPoint) -> CGPoint {
       return CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
    }

    static func controlPointForPoints(p1: CGPoint, p2: CGPoint) -> CGPoint {
        var controlPoint = CGPoint.midPointForPoints(p1: p1, p2: p2)
        let diffY = abs(p2.y - controlPoint.y)

        if p1.y < p2.y {
            controlPoint.y += diffY
        } else if  p1.y > p2.y {
            controlPoint.y -= diffY
        }
        return controlPoint
    }
}
