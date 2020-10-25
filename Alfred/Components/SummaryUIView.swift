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

        let frame = CGRect(x: 20, y: 0, width: 40, height: 40)
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

struct AirQualityUIView: View {
    @ObservedObject var houseSensorData: HouseSensorData = HouseSensorData()
    var body: some View {
        VStack {
            Text("Air quality")
                .fontWeight(.thin)
                .fixedSize(horizontal: true, vertical: false)
                .foregroundColor(.white)
            Spacer()
            Image(self.houseSensorData.healthIndicator)
                    .resizable()
                    .frame(width: 40, height: 40)
            Spacer()
        }
        .frame(width: 80, height: 100)
        .background(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
        .cornerRadius(10)
        .onAppear {
            self.houseSensorData.loadData(menuItem: -1)
        }
    }
}

struct WeatherUIView: View {
    @ObservedObject var currentWeatherData: CurrentWeatherData = CurrentWeatherData()
    var body: some View {
        VStack {
            Text("Weather")
                .fontWeight(.thin)
                .fixedSize(horizontal: true, vertical: false)
                .foregroundColor(.white)
            Spacer()
            WeatherIconUIView(currentWeatherData: self.currentWeatherData)
                .frame(width: 71, height: 40)
            Text("\(self.currentWeatherData.results.temperature ?? 0)" + "°")
                .font(.system(size: 14))
                .fixedSize(horizontal: true, vertical: false)
                .foregroundColor(.white)
            Spacer()
        }
        .frame(width: 80, height: 100)
        .background(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
        .cornerRadius(10)
        .onAppear {
            self.currentWeatherData.loadData()
        }
    }
}

struct PlantsUIView: View {
    @ObservedObject var needsWaterData: NeedsWaterData = NeedsWaterData()
    var body: some View {
        VStack {
            Text("Plants")
                .fontWeight(.thin)
                .fixedSize(horizontal: true, vertical: false)
                .foregroundColor(.white)
            Spacer()
            Image(self.needsWaterData.needsWater)
                .resizable()
                .frame(width: 50, height: 50)
            Spacer()
        }
        .frame(width: 80, height: 100)
        //.background(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
        .background(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
        .cornerRadius(10)
    }
}

struct HeatingUIView: View {
    @ObservedObject var heatingData: HeatingData = HeatingData()
    var body: some View {
        VStack {
            Text("Heating")
                .fontWeight(.thin)
                .fixedSize(horizontal: true, vertical: false)
                .foregroundColor(.white)
            Spacer()
            if self.heatingData.results.ecoMode == "OFF" {
                if self.heatingData.results.hvac == "Heating" {
                    Text("\(self.heatingData.results.temperature ?? 0, specifier: "%.0f")°")
                        .frame(width: 30, height: 30, alignment: .center)
                        .padding()
                        .foregroundColor(Color.orange)
                        .overlay(
                            Circle()
                                .stroke(Color.orange, lineWidth: 2)
                                .padding(6)
                        )
                } else {
                    Text("\(self.heatingData.results.temperature ?? 0, specifier: "%.0f")°")
                        .frame(width: 40, height: 40, alignment: .center)
                        .padding()
                        .foregroundColor(.white)
                }
            } else {
                Image("leaf_green")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            Spacer()
        }
        .frame(width: 80, height: 100)
        .background(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
        .cornerRadius(10)
    }
}

struct SummaryUIView: View {
    var body: some View {
        HStack {
            Spacer()
            AirQualityUIView()
            Spacer()
            WeatherUIView()
            Spacer()
            PlantsUIView()
            Spacer()
            HeatingUIView()
            Spacer()
        }.frame(height: 100)
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
        .fixed(width: 414, height: 150)
        )
    }
}
#endif
