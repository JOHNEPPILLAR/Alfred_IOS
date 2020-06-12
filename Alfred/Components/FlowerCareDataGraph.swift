//
//  FlowerCareDataGraph.swift
//  Alfred
//
//  Created by John Pillar on 11/06/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import SwiftUI

struct FlowerCareDataGraph: View {

    @ObservedObject var flowerCareData: FlowerCareData = FlowerCareData()

    func chartData (data: [SensorReadingDataItem]) -> [Double] {
        return (0..<data.count).map { (item) in
            return data[item].moisture.rounded(.down)
        }
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            GeometryReader { geometry in
                VStack {
                    //if self.flowerCareData.results.count > 0 {
                    //ForEach(self.flowerCareData.results) { item in
                        LineChartUIView(
                            data: [0, 8, 100, 23, 54, 32, 12, 37, 100, 7, 23, 43],
                            //self.chartData(data: self.flowerCareData.results[0].readings),
                            title: "Title",
                            marker: 8.0)
                        .frame(width: geometry.size.width, height: 140)
                        .transition(.opacity)
                        .animation(.easeIn(duration: 1.0))

                        //Spacer()
                    //}
                }
            }
        }
    }
}

#if DEBUG
struct FlowerCareDataGraph_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(#colorLiteral(red: 0.1439366937, green: 0.1623166203, blue: 0.2411367297, alpha: 1))
            .edgesIgnoringSafeArea(.all)
            FlowerCareDataGraph()
        }
        //.previewLayout(
        //    .fixed(width: 414, height: 80)
        //)
    }
}
#endif
