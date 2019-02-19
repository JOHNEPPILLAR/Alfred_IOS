//
//  RoomsViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 20/01/2019.
//  Copyright © 2019 John Pillar. All rights reserved.
//

import UIKit
import SVProgressHUD
import Charts

class RoomsViewController: UIViewController {

    private let roomsController = RoomsController()

    let timerInterval = 5 // seconds

    var refreshLightDataTimer: Timer!
    var roomID:Int = 0
    var headerViewColor: UIColor!
    
    @IBAction func returnToPreviousView(_ sender: UIButton) {
        self.dismiss(animated: true, completion:nil)
    }
    
    @IBAction func lightsOnOffChange(_ sender: UISwitch) {
        if refreshLightDataTimer != nil {
            refreshLightDataTimer.invalidate() // Stop the refresh data timer
            refreshLightDataTimer = nil
        }
        roomsController.UpdateLightStateValueChange(lightID: (roomID), lightState: (sender.isOn))
    }
  
    @IBAction func lightBrightnessChange(_ sender: UISlider, event: UIEvent) {
        sender.setValue(sender.value.rounded(.down), animated: true)
        
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                if refreshLightDataTimer != nil {
                    refreshLightDataTimer.invalidate() // Stop the refresh data timer
                    refreshLightDataTimer = nil
                }
            case .ended:
                roomsController.UpdateLightBrightness(lightID: roomID, brightness: Int(sender.value))
            default:
                break
            }
        }
    }
    
    @IBOutlet weak var roomName: UILabel!
    
    // Lights
    @IBOutlet weak var lightsLabel: UITextField!
    @IBOutlet weak var lightsLabelLine: UIView!
    @IBOutlet weak var lightsOnOff: UISwitch!
    @IBOutlet weak var lightsView: UIView!
    @IBOutlet weak var lightSlider: UISlider!
    
    // Chart buttons
    @IBOutlet weak var chartHourButton: UIButton!
    @IBOutlet weak var chartDayButton: UIButton!
    @IBOutlet weak var chartWeekButton: UIButton!
    
    @IBOutlet weak var ChartAreaScroolView: UIScrollView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        headerViewColor = lightsView.backgroundColor!

        // Call API's to get data
        roomsController.getLightRoomData()
        roomsController.getChartData(roomID: roomID, durartion: "day")

    }
    
    // Temp
    @IBOutlet weak var roomTemp: UITextField!
    @IBOutlet weak var chartView: LineChartView!
    
    
    //
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomsController.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if refreshLightDataTimer != nil {
            refreshLightDataTimer.invalidate() // Stop the refresh data timer
            refreshLightDataTimer = nil
        }
    }
}

extension RoomsViewController: RoomsControllerDelegate {
 
    func didFailDataUpdateWithError(displayMsg: Bool) {
        if displayMsg {
            SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
            SVProgressHUD.showError(withStatus: "Network/API error")
        }
        if refreshLightDataTimer != nil {
            refreshLightDataTimer.invalidate() // Stop the refresh data timer
            refreshLightDataTimer = nil
        }
    }

    func didFailLightDataUpdateWithError(displayMsg: Bool) {
        if displayMsg {
            SVProgressHUD.showError(withStatus: "Lights - Network/API error")
        }
        if refreshLightDataTimer != nil {
            refreshLightDataTimer.invalidate() // Stop the refresh data timer
            refreshLightDataTimer = nil
        }
    }

    // Process light room data
    func roomLightsDidRecieveDataUpdate(data: [RoomLightsData]) {
        let roomData = data.filter { ($0.attributes?.attributes?.id?.contains(String(roomID)))! }
        
        roomName.text = roomData[0].attributes?.attributes?.name
        
        lightsOnOff.isOn = roomData[0].state?.attributes?.anyOn ?? false
        lightSlider.value = Float(roomData[0].action?.attributes?.bri ?? 0)
        
        if (roomData[0].state?.attributes?.anyOn)! {
            var color = UIColor.white
            switch roomData[0].action?.attributes?.colormode {
            case "ct"?: color = HueColorHelper.getColorFromScene((roomData[0].action?.attributes?.ct)!)
            case "xy"?: color = HueColorHelper.colorFromXY(CGPoint(x: Double((roomData[0].action?.attributes?.xy![0])!), y: Double((roomData[0].action?.attributes?.xy![1])!)), forModel: "LCT007")
            case "hs"?: color = HueColorHelper.colorFromXY(CGPoint(x: Double((roomData[0].action?.attributes?.xy![0])!), y: Double((roomData[0].action?.attributes?.xy![1])!)), forModel: "LCT007")
            default: color = UIColor.white
            }
            lightSlider.maximumTrackTintColor = color
            let darkerColor = color.darker(by: -15)
            lightsOnOff.onTintColor = darkerColor
            lightSlider.maximumTrackTintColor = darkerColor
            lightSlider.setMinimumTrackImage(startColor: darkerColor!,
                                                  endColor: UIColor.white,
                                                  startPoint: CGPoint.init(x: 0, y: 0),
                                                  endPoint: CGPoint.init(x: 1, y: 1))
            // lightSlider.layer.cornerRadius = 12.0;
            lightSlider.isHidden = false
            lightsView.backgroundColor = color
        } else {
            lightSlider.isHidden = true
            lightsView.backgroundColor = headerViewColor
            lightsOnOff.onTintColor = headerViewColor
        }
        
        if refreshLightDataTimer == nil { // Set up data refresh timer
            refreshLightDataTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timerInterval), repeats: true){_ in
                self.roomsController.getLightRoomData()
            }
        }

    }

    // Process chart data
    func chartDataDidRecieveDataUpdate(data: [RoomTempSensorData]) {

        let chartData: Any
        
        // Configure chart UI
        chartView.backgroundColor = .clear
        chartView.gridBackgroundColor = .clear
        chartView.drawGridBackgroundEnabled = true
        chartView.drawBordersEnabled = false
        chartView.setScaleEnabled(true)
        chartView.legend.enabled = false
        chartView.xAxis.enabled = false
        chartView.leftAxis.axisMinimum = -10
        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.gridColor = NSUIColor.clear
        chartView.xAxis.drawGridLinesEnabled = false
        //tempChartView.chartDescription?.enabled = false
        //tempChartView.pinchZoomEnabled = false
        //tempChartView.dragEnabled = true

        // Temp
        chartView.chartDescription?.text = "Temperature"
        chartView.leftAxis.axisMaximum = 45
        chartData = (0..<data[0].rows!.count).map { (i) -> ChartDataEntry in
            let val = data[0].rows![i].temperature?.rounded(.up)
            return ChartDataEntry(x: Double(i), y: Double(val!))
        }

        // CO2
        
        // Hum
        
        
        // Configure chart result UI
        let chartResultsData = LineChartDataSet(values: chartData as? [ChartDataEntry], label: "")
        chartResultsData.setColor(UIColor.darkGray)
        chartResultsData.drawCirclesEnabled = false
        chartResultsData.lineWidth = 1
        chartResultsData.drawValuesEnabled = false
        chartResultsData.drawFilledEnabled = true
        chartResultsData.fillColor = .darkGray
 
        let data = LineChartData()
        data.addDataSet(chartResultsData)
        self.chartView.data = data
        
    }
    
}
