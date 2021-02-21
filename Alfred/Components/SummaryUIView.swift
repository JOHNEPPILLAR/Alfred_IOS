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
    let frame = CGRect(x: 15, y: 0, width: 40, height: 40)
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

  init() {
    self.houseSensorData.loadData(menuItem: -1)
  }

  var body: some View {
    VStack {
      Text("Air")
        .fontWeight(.thin)
        .fixedSize(horizontal: true, vertical: false)
        .foregroundColor(.white)
      Spacer()
      Image(self.houseSensorData.healthIndicator)
        .resizable()
        .frame(width: 40, height: 40)
      Spacer()
    }
    .padding(5)
    .frame(width: 80, height: 100)
    .background(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
    .cornerRadius(10)
  }
}

struct WeatherUIView: View {

  @ObservedObject var currentWeatherData: CurrentWeatherData = CurrentWeatherData()

  init() {
    self.currentWeatherData.loadData()
  }

  var body: some View {
    VStack {
      Text("Weather")
        .fontWeight(.thin)
        .fixedSize(horizontal: true, vertical: false)
        .foregroundColor(.white)
      Spacer()
      WeatherIconUIView(currentWeatherData: self.currentWeatherData)
      Spacer()
      Text("\(self.currentWeatherData.results.temperature ?? 0)" + "°")
        .font(.system(size: 16))
        .fixedSize(horizontal: true, vertical: false)
        .foregroundColor(.white)
    }
    .padding(5)
    .frame(width: 80, height: 100)
    .background(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
    .cornerRadius(10)
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
    .padding(5)
    .frame(width: 80, height: 100)
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
      if self.heatingData.results.ecoMode != nil {
        if self.heatingData.results.ecoMode == "OFF" {
          if self.heatingData.results.hvac == "Heating" {
            Spacer()
            Text("\(self.heatingData.results.temperature ?? 0, specifier: "%.0f")°")
              .font(.system(size: 26))
              .frame(width: 55, height: 55, alignment: .center)
              .foregroundColor(Color.orange)
              .overlay(
                Circle()
                .stroke(Color.orange, lineWidth: 2)
              )
            Spacer()
          } else {
            Spacer()
            Text("\(self.heatingData.results.temperature ?? 0, specifier: "%.0f")°")
              .font(.system(size: 26))
              .foregroundColor(.white)
            Spacer()
          }
        } else {
          Spacer()
          Image("leaf_green")
            .resizable()
            .frame(width: 40, height: 40)
          Spacer()
        }
      } else {
        Spacer()
      }
    }
    .padding(5)
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
