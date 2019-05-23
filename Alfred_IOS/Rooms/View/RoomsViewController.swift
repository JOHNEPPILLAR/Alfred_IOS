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

class RoomsViewController: UIViewController, UIScrollViewDelegate {
    private let roomsController = RoomsController()

    var roomID:Int = 0
    var scheduleID:Int = 0
    var sensorID:Int = 0
    var headerViewColor: UIColor!
    @IBOutlet weak var roomName: UILabel!
    
    @IBAction func returnToPreviousView(_ sender: UIButton) {
        self.dismiss(animated: true, completion:nil)
    }
    
    // Schedules
    @IBOutlet weak var timersTableView: UITableView!
    fileprivate var SchedulesDataArray = [SchedulesData]() {
        didSet {
            timersTableView.reloadData()
            
            // Resize the views based on table rows
            timersTableView.sizeToFit()
            timersTableView.frame.size.height = timersTableView.contentSize.height
            timersView.frame.size.height = timersTableView.contentSize.height
            timersBackgroundView.frame.size.height = timersTableView.contentSize.height + 40
            
            let newStartPosition = timersBackgroundView.frame.origin.y + timersBackgroundView.frame.size.height + 20
            sensorBackgroundView.moveY(y: newStartPosition)
            sensorsView.moveY(y: newStartPosition)
        }
    }
    
    // Motion Sensors
    @IBOutlet weak var sensorsTableView: UITableView!
    fileprivate var MotionSensorDataArray = [MotionSensorsData]() {
        didSet {
            sensorsTableView.reloadData()
            
            if MotionSensorDataArray.count > 0 {
                // Resize the views based on table rows
                sensorsTableView.sizeToFit()
                sensorsTableView.frame.size.height = sensorsTableView.contentSize.height
                sensorsView.frame.size.height = sensorsTableView.contentSize.height
                sensorBackgroundView.frame.size.height = sensorsTableView.contentSize.height + 40
            } else {
                sensorsView.isHidden = true
                sensorBackgroundView.isHidden = true
            }
        }
    }
    
    // Lights
    let timerInterval = 5 // seconds
    var refreshLightDataTimer: Timer!

    @IBOutlet weak var lightsLabel: UITextField!
    @IBOutlet weak var lightsOnOff: UISwitch!
    @IBOutlet weak var lightsView: UIView!
    @IBOutlet weak var timersView: UIView!
    @IBOutlet weak var lightSlider: UISlider!
    @IBOutlet weak var timersBackgroundView: RoundCornersView!
    @IBOutlet weak var sensorBackgroundView: RoundCornersView!
    @IBOutlet weak var sensorsView: UIView!
    
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
    
    // Chart setup
    var chartPageID:Int = 0
    var slides:[Slide] = [];
    
    @IBOutlet weak var chartAreaScrollView: UIScrollView!
    @IBOutlet weak var chartPageControl: UIPageControl!
    @IBOutlet weak var chartFilterHour: UIButton!
    @IBAction func chartFilterHour(_ sender: UIButton) {
        chartAreaScrollView.subviews.forEach({ $0.removeFromSuperview() })
        roomsController.getChartData(roomID: roomID, durartion: "hour")
        chartFilterHour.underline()
        chartFilterDay.removeUnderline()
        chartFilterWeek.removeUnderline()
        chartFilterMonth.removeUnderline()
    }
    @IBOutlet weak var chartFilterDay: UIButton!
    @IBAction func chartFilterDay(_ sender: UIButton) {
        chartAreaScrollView.subviews.forEach({ $0.removeFromSuperview() })
        roomsController.getChartData(roomID: roomID, durartion: "day")
        chartFilterHour.removeUnderline()
        chartFilterDay.underline()
        chartFilterWeek.removeUnderline()
        chartFilterMonth.removeUnderline()
    }
    @IBOutlet weak var chartFilterWeek: UIButton!
    @IBAction func chartFilterWeek(_ sender: UIButton) {
        chartAreaScrollView.subviews.forEach({ $0.removeFromSuperview() })
        roomsController.getChartData(roomID: roomID, durartion: "week")
        chartFilterHour.removeUnderline()
        chartFilterDay.removeUnderline()
        chartFilterWeek.underline()
        chartFilterMonth.removeUnderline()
    }
    @IBOutlet weak var chartFilterMonth: UIButton!
    @IBAction func chartFilterMonth(_ sender: UIButton) {
        chartAreaScrollView.subviews.forEach({ $0.removeFromSuperview() })
        roomsController.getChartData(roomID: roomID, durartion: "month")
        chartFilterHour.removeUnderline()
        chartFilterDay.removeUnderline()
        chartFilterWeek.removeUnderline()
        chartFilterMonth.underline()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "schedule"?:
            if let vc = segue.destination as? ViewScheduleController {
                vc.scheduleID = scheduleID
            }
        case "motionSensor"?:
            if let vc = segue.destination as? ViewSensorController {
                vc.sensorID = sensorID
            }
        case .none:
            return
        case .some(_):
            return
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        headerViewColor = lightsView.backgroundColor!
        chartFilterHour.underline()
        
        // Call API's to get data
        roomsController.getLightRoomData()
        roomsController.getChartData(roomID: roomID, durartion: "hour")
        roomsController.getSchedulesData(roomID: roomID)
        roomsController.getMotionSensorData(roomID: roomID)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        timersTableView.delegate = self
        timersTableView.dataSource = self
        sensorsTableView.delegate = self
        sensorsTableView.dataSource = self
        
        roomsController.delegate = self
        chartAreaScrollView.delegate = self
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
            SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
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

            let darkerColor = color.darker(by: -15)
            lightsOnOff.onTintColor = UIColor.lightGray
            lightsOnOff.thumbTintColor = darkerColor

            lightSlider.maximumTrackTintColor = darkerColor
            lightSlider.thumbTintColor = UIColor.lightGray
            lightSlider.setMinimumTrackImage(startColor: darkerColor!,
                                                  endColor: UIColor.white,
                                                  startPoint: CGPoint.init(x: 0, y: 0),
                                                  endPoint: CGPoint.init(x: 1, y: 1))
            
            lightSlider.isHidden = false
            lightsView.backgroundColor = color
        } else {
            lightSlider.isHidden = true
            lightsView.backgroundColor = headerViewColor
            lightsOnOff.thumbTintColor = UIColor.darkGray
        }
        
        if refreshLightDataTimer == nil { // Set up data refresh timer
            refreshLightDataTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timerInterval), repeats: true){_ in
                self.roomsController.getLightRoomData()
            }
        }
    }

    // Process chart data
    func createSlide() -> Slide {
        let baseSlide:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        baseSlide.chartView.leftAxis.drawAxisLineEnabled = false
        baseSlide.chartView.leftAxis.drawAxisLineEnabled = false
        baseSlide.chartView.leftAxis.drawGridLinesEnabled = false
        baseSlide.chartView.leftAxis.gridColor = NSUIColor.clear
        baseSlide.chartView.xAxis.enabled = false
        baseSlide.chartView.xAxis.drawGridLinesEnabled = false
        baseSlide.chartView.rightAxis.enabled = false
        baseSlide.chartView.backgroundColor = .clear
        baseSlide.chartView.gridBackgroundColor = .clear
        baseSlide.chartView.drawBordersEnabled = false
        baseSlide.chartView.setScaleEnabled(true)
        baseSlide.chartView.legend.enabled = false
        baseSlide.chartView.chartDescription?.enabled = false
        baseSlide.chartView.noDataText = "No data to display"
        baseSlide.chartView.noDataTextColor = UIColor.darkGray
        baseSlide.chartView.pinchZoomEnabled = false

        let marker = BalloonMarker(color: UIColor.darkGray,
                                   font: .systemFont(ofSize: 12),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = baseSlide.chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        baseSlide.chartView.marker = marker
        return baseSlide
    }
    
    func formatChart(chartData: [ChartDataEntry]) -> LineChartDataSet {
        let chartResultsData = LineChartDataSet(entries: chartData, label: "")
        chartResultsData.setColor(UIColor.darkGray)
        chartResultsData.drawCirclesEnabled = false
        chartResultsData.lineWidth = 1
        chartResultsData.drawValuesEnabled = false
        chartResultsData.drawFilledEnabled = true
        chartResultsData.fillColor = .darkGray
        chartResultsData.drawHorizontalHighlightIndicatorEnabled = false
        chartResultsData.drawVerticalHighlightIndicatorEnabled = false
        return chartResultsData
    }
    
    func createSlides(chartData: [RoomSensorBaseClass]) -> [Slide] {

        let roomsWithBattery = [4, 8, 9]
        let roomsWithHumidity = [4, 5, 8, 9]
        let roomsWithAir = [5]
        let roomsWithNitrogen = [5]
        let roomsWithCO2 = [4, 9]

        var lineChartData = LineChartData()
        var chartResultsData = LineChartDataSet()
        var showSlides = [Slide]()
        
        // Temperature
        let TemperatureSlide = createSlide()
        TemperatureSlide.chartTitleLabel.text = "Temperature"
        
        if (chartData[0].data?.count ?? 0 > 1) {
            let chartTempData = (0..<chartData[0].data!.count).map { (i) -> ChartDataEntry in
                let val = chartData[0].data![i].temperature?.rounded(.up)
                return ChartDataEntry(x: Double(i), y: Double(val ?? 0))
            }
            
            // TemperatureSlide.chartView.leftAxis.axisMaximum = 45
            // TemperatureSlide.chartView.leftAxis.axisMinimum = -10
            
            chartResultsData = formatChart(chartData: chartTempData)
            lineChartData.addDataSet(chartResultsData)
            TemperatureSlide.chartView.data = lineChartData
            TemperatureSlide.chartView.animate(yAxisDuration: CATransaction.animationDuration()*2, easingOption: .linear)
    
            // Tidy up vars
            chartResultsData = LineChartDataSet()
            lineChartData = LineChartData()
        }
        showSlides.append(TemperatureSlide) // Add slide
        
        // Humidity
        if roomsWithHumidity.contains(where: { $0 == roomID }) {
            let HumiditySlide = createSlide()
            HumiditySlide.chartTitleLabel.text = "Humidity"
            // HumiditySlide.chartView.leftAxis.axisMaximum = 100
            // HumiditySlide.chartView.leftAxis.axisMinimum = 0

            if (chartData[0].data?.count != nil) {
                let chartHumData = (0..<chartData[0].data!.count).map { (i) -> ChartDataEntry in
                    let val = chartData[0].data![i].humidity?.rounded(.up)
                    return ChartDataEntry(x: Double(i), y: Double(val ?? 0))
                }
                chartResultsData = formatChart(chartData: chartHumData)
                lineChartData.addDataSet(chartResultsData)
                HumiditySlide.chartView.data = lineChartData
                // Tidy up vars
                lineChartData = LineChartData()
                chartResultsData = LineChartDataSet()
            }
            showSlides.append(HumiditySlide) // Add slide
        }
        
        // Air Quality
        if roomsWithAir.contains(where: { $0 == roomID }) {
            let AirQualitySlide = createSlide()
            AirQualitySlide.chartTitleLabel.text = "Air Quality"
            // AirQualitySlide.chartView.leftAxis.axisMaximum = 4
            // AirQualitySlide.chartView.leftAxis.axisMinimum = 0
            // AirQualitySlide.chartView.leftAxis.labelCount = 4
            
            if (chartData[0].data?.count != nil) {
                let chartHumData = (0..<chartData[0].data!.count).map { (i) -> ChartDataEntry in
                    let val = chartData[0].data![i].airQuality
                    return ChartDataEntry(x: Double(i), y: Double(val ?? 0))
                }
                chartResultsData = formatChart(chartData: chartHumData)
                lineChartData.addDataSet(chartResultsData)
                AirQualitySlide.chartView.data = lineChartData
                // Tidy up vars
                lineChartData = LineChartData()
                chartResultsData = LineChartDataSet()
            }
            showSlides.append(AirQualitySlide) // Add slide
        }
        
        // Nitrogen
        if roomsWithNitrogen.contains(where: { $0 == roomID }) {
            let nitrogenSlide = createSlide()
            nitrogenSlide.chartTitleLabel.text = "Nitrogen"
            // nitrogenSlide.chartView.leftAxis.axisMaximum = 10
            // nitrogenSlide.chartView.leftAxis.axisMinimum = 0
            
            if (chartData[0].data?.count != nil) {
                let chartHumData = (0..<chartData[0].data!.count).map { (i) -> ChartDataEntry in
                    let val = chartData[0].data![i].nitrogen
                    return ChartDataEntry(x: Double(i), y: Double(val ?? 0))
                }
                chartResultsData = formatChart(chartData: chartHumData)
                lineChartData.addDataSet(chartResultsData)
                nitrogenSlide.chartView.data = lineChartData
                // Tidy up vars
                lineChartData = LineChartData()
                chartResultsData = LineChartDataSet()
            }
            showSlides.append(nitrogenSlide) // Add slide
        }
        
        // CO2
        if roomsWithCO2.contains(where: { $0 == roomID }) {
            let CO2Slide = createSlide()
            CO2Slide.chartTitleLabel.text = "CO2"
            // CO2Slide.chartView.leftAxis.axisMaximum = 2000
            // CO2Slide.chartView.leftAxis.axisMinimum = 0
            
            if (chartData[0].data?.count != nil) {
                let chartHumData = (0..<chartData[0].data!.count).map { (i) -> ChartDataEntry in
                    let val = chartData[0].data![i].co2?.rounded(.up)
                    return ChartDataEntry(x: Double(i), y: Double(val ?? 0))
                }
                chartResultsData = formatChart(chartData: chartHumData)
                lineChartData.addDataSet(chartResultsData)
                CO2Slide.chartView.data = lineChartData
                // Tidy up vars
                lineChartData = LineChartData()
                chartResultsData = LineChartDataSet()
            }
            showSlides.append(CO2Slide) // Add slide
        }
        
        // Battery
        if roomsWithBattery.contains(where: { $0 == roomID }) {
            let BatterySlide = createSlide()
            BatterySlide.chartTitleLabel.text = "Battery"
            // BatterySlide.chartView.leftAxis.axisMaximum = 100
            // BatterySlide.chartView.leftAxis.axisMinimum = 0
            
            if (chartData[0].data?.count != nil) {
                let chartHumData = (0..<chartData[0].data!.count).map { (i) -> ChartDataEntry in
                    let val = chartData[0].data![i].battery!
                    return ChartDataEntry(x: Double(i), y: Double(val) ?? 0)
                }
                chartResultsData = formatChart(chartData: chartHumData)
                lineChartData.addDataSet(chartResultsData)
                BatterySlide.chartView.data = lineChartData
                // Tidy up vars
                lineChartData = LineChartData()
                chartResultsData = LineChartDataSet()
            }
            showSlides.append(BatterySlide) // Add slide
        }
        return showSlides
    }
    
    func setupSlideScrollView(slides : [Slide]) {
        chartAreaScrollView.frame = CGRect(x: 8, y: 170, width: view.frame.width, height: view.frame.height)
        chartAreaScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        chartAreaScrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            chartAreaScrollView.addSubview(slides[i])
        }
    }
    
    func chartDataDidRecieveDataUpdate(data: [RoomSensorBaseClass]) {
        slides = createSlides(chartData: data)
        setupSlideScrollView(slides: slides)
        chartPageControl.numberOfPages = slides.count
        chartPageControl.currentPage = chartPageID
        chartPageControl.addTarget(self, action: #selector(self.changeChart(sender:)), for: UIControl.Event.valueChanged)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        chartFilterHour.isHidden = true
        chartFilterDay.isHidden = true
        chartFilterWeek.isHidden = true
        chartFilterMonth.isHidden = true
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        if scrollView.contentOffset.x / view.frame.width == CGFloat(pageIndex)  {
            chartFilterHour.isHidden = false
            chartFilterDay.isHidden = false
            chartFilterWeek.isHidden = false
            chartFilterMonth.isHidden = false
        }
        chartPageControl.currentPage = Int(pageIndex)
        chartPageID = chartPageControl.currentPage
        let theViewToAccess = chartAreaScrollView.getAllSubviews() as [Slide]
        theViewToAccess[chartPageID].chartView.animate(yAxisDuration: CATransaction.animationDuration()*2, easingOption: .linear)
    }
    
    @objc func changeChart(sender: UIPageControl) -> () {
        let x = CGFloat(chartPageControl.currentPage) * chartAreaScrollView.frame.size.width
        chartAreaScrollView.setContentOffset(CGPoint(x:x, y:0), animated: false)
        chartPageID = chartPageControl.currentPage
    }
 
    // Process light room data
    func schedulesDidRecieveDataUpdate(data: [SchedulesData]) {
        SchedulesDataArray = data
    }
    
    // Process motion sensor data
    func motionSensorsDidRecieveDataUpdate(data: [MotionSensorsData]) {
        MotionSensorDataArray = data
    }
    
}

extension RoomsViewController: UITableViewDelegate {
}

extension RoomsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == timersTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as! ScheduleTableViewCell
            cell.configureWithItem(item: SchedulesDataArray[indexPath.item])
            cell.backgroundColor = .clear
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SensorTableViewCell", for: indexPath) as! SensorsTableViewCell
            cell.configureWithItem(item: MotionSensorDataArray[indexPath.item])
            cell.backgroundColor = .clear
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == timersTableView {
            if (SchedulesDataArray.count > 0) {
                return SchedulesDataArray.count
            } else { return 0 }
        } else {
            if (MotionSensorDataArray.count > 0) {
                return MotionSensorDataArray.count
            } else { return 0 }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        if tableView == timersTableView {
            let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
                self.scheduleID = self.SchedulesDataArray[editActionsForRowAt.row].id!
                self.performSegue(withIdentifier: "schedule", sender: self)
            }
            edit.backgroundColor = .lightGray
            return [edit]
        } else {
            let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
                self.sensorID = self.MotionSensorDataArray[editActionsForRowAt.row].id!
                self.performSegue(withIdentifier: "motionSensor", sender: self)
            }
            edit.backgroundColor = .lightGray
            return [edit]
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

