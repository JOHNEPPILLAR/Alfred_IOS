//
//  SummaryUIView.swift
//  Alfred
//
//  Created by John Pillar on 06/06/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import SwiftUI

struct WeatherIconUIView: UIViewRepresentable {

    @ObservedObject var currentWeatherData: CurrentWeatherData

    func makeUIView(context: Context) -> UIView {
        return UIView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {

        let frame = CGRect(x: 20, y: 0, width: 30, height: 30)
        let iconView = SkyIconUIView(
            type: self.currentWeatherData.results.icon ?? "",
            strokeColor: .white,
            backgroundColor: .clear,
            frame: frame)
        iconView.tag = 100
        if let viewWithTag = uiView.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
        uiView.addSubview(iconView)
    }
}

struct SummaryUIView: View {

    @ObservedObject var houseSensorData: HouseSensorData = HouseSensorData()
    @ObservedObject var currentWeatherData: CurrentWeatherData = CurrentWeatherData()
    @ObservedObject var needsWaterData: NeedsWaterData = NeedsWaterData()

    var body: some View {
        GeometryReader { geometry in
            HStack {
                VStack {
                    Text("Air quality")
                        .fontWeight(.thin)
                        .fixedSize(horizontal: true, vertical: false)
                        .foregroundColor(.white)
                    Spacer()
                    Image(self.houseSensorData.healthIndicator)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .onAppear {
                            self.houseSensorData.loadData(menuItem: -1)
                        }
                    Spacer()
                }
                .frame(width: 100)
                Divider().background(Color.gray)
                VStack {
                    Text("Weather")
                        .fontWeight(.thin)
                        .fixedSize(horizontal: true, vertical: false)
                        .foregroundColor(.white)
                    VStack {
                        WeatherIconUIView(currentWeatherData: self.currentWeatherData)
                            .frame(width: 71, height: 30)
                            .onAppear {
                                self.currentWeatherData.loadData()
                            }
                        Text("\(self.currentWeatherData.results.temperature ?? 0)" + "° C")
                            .font(.system(size: 12))
                            .fixedSize(horizontal: true, vertical: false)
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 100)
                Divider().background(Color.gray)
                VStack {
                    Text("Plants")
                        .fontWeight(.thin)
                        .fixedSize(horizontal: true, vertical: false)
                        .foregroundColor(.white)
                    Spacer()
                    Image(self.needsWaterData.needsWater)
                        .resizable()
                        .frame(width: 30, height: 30)
                    Spacer()
                }
                .frame(width: 100)
            }
            .padding(10)
            .background(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
            .cornerRadius(10)
            .frame(width: geometry.size.width, height: 100)
        }
    }
}

#if DEBUG
struct SummaryUIView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            SummaryUIView()
        }
        .previewLayout(
        .fixed(width: 414, height: 120)
        )
    }
}
#endif
