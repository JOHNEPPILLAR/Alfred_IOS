//
//  SummaryUIView.swift
//  Alfred
//
//  Created by John Pillar on 06/06/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import SwiftUI

struct WeatherIconUIView: UIViewRepresentable {

    @ObservedObject var currentWeatherData = CurrentWeatherData()

    func makeUIView(context: Context) -> UIView {
        return UIView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {

        if self.currentWeatherData.results.icon != nil {
            let skyConImage: SkyconTypes = SkyconTypes.withLabel(currentWeatherData.results.icon!)!
            let frame = CGRect(x: 20, y: 0, width: 30, height: 30)
            let iconView = SkyIconView(type: skyConImage, strokeColor: .white, backgroundColor: .clear, frame: frame)
            iconView.tag = 100
            if let viewWithTag = uiView.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
            }
            uiView.addSubview(iconView)
        }
    }
}

struct SummaryUIView: View {

    @ObservedObject var currentWeatherData = CurrentWeatherData()
    @ObservedObject var houseSensorsData = HouseSensorData()
    @ObservedObject var needsWaterData = NeedsWaterData()

    var body: some View {
        GeometryReader { geometry in
            HStack {
                VStack {
                    Text("Air quality")
                        .fontWeight(.thin)
                        .fixedSize(horizontal: true, vertical: false)
                        .foregroundColor(.white)
                    Spacer()
                    if self.houseSensorsData.healthIndicator == 0 {
                        Image("1pxHeader")
                        .resizable()
                        .frame(width: 1, height: 1)
                    } else if self.houseSensorsData.healthIndicator == 1 {
                        Image("air_quality_green")
                        .resizable()
                        .frame(width: 30, height: 30)
                    } else if self.houseSensorsData.healthIndicator == 2 {
                        Image("air_quality_yellow")
                        .resizable()
                        .frame(width: 30, height: 30)
                    } else {
                        Image("air_quality_red")
                        .resizable()
                        .frame(width: 30, height: 30)
                    }
                    Spacer()
                }
                Divider().background(Color.gray)
                VStack {
                    Text("Weather")
                        .fontWeight(.thin)
                        .fixedSize(horizontal: true, vertical: false)
                        .foregroundColor(.white)
                    VStack {
                        WeatherIconUIView()
                        .frame(width: 71, height: 30)
                        Text("\(self.currentWeatherData.results.temperature ?? 0)" + "° C")
                        .font(.system(size: 12))
                        .fixedSize(horizontal: true, vertical: false)
                        .foregroundColor(.white)
                    }
                }
                Divider().background(Color.gray)
                VStack {
                    Text("Plants")
                        .fontWeight(.thin)
                        .fixedSize(horizontal: true, vertical: false)
                        .foregroundColor(.white)
                    Spacer()
                    if self.needsWaterData.results.count > 0 {
                        Image("leaf_red")
                        .resizable()
                        .frame(width: 30, height: 30)
                    } else {
                        Image("leaf_green")
                        .resizable()
                        .frame(width: 30, height: 30)
                    }
                    Spacer()
                }
            }
            .padding(10)
            .background(Color(#colorLiteral(red: 0.03529411765, green: 0.09411764706, blue: 0.1803921569, alpha: 1)))
            .cornerRadius(10)
            .frame(width: geometry.size.width, height: 100)
            Spacer()
        }
    }
}

#if DEBUG
struct SummaryUIView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(#colorLiteral(red: 0.1439366937, green: 0.1623166203, blue: 0.2411367297, alpha: 1))
            .edgesIgnoringSafeArea(.all)
            SummaryUIView()
        }
        .previewLayout(
            .fixed(width: 414, height: 150)
        )
    }
}
#endif
