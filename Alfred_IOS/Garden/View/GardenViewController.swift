//
//  GardenViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 02/06/2019.
//  Copyright © 2019 John Pillar. All rights reserved.
//

import UIKit
import SVProgressHUD
import Charts

class GardenViewController: UIViewController, UIScrollViewDelegate {

    private let gardenController = GardenController()

    @IBAction func returnToPreviousView(_ sender: UIButton) {
        self.dismiss(animated: true, completion:nil)
    }
    
    // Chart setup
    var chartPageID:Int = 0
    var slides:[Slide] = [];
    
    @IBOutlet weak var chartAreaScrollView: UIScrollView!
    @IBOutlet weak var chartPageControl: UIPageControl!
    @IBOutlet weak var chartFilterHour: UIButton!
    @IBAction func chartFilterHour(_ sender: UIButton) {
        chartAreaScrollView.subviews.forEach({ $0.removeFromSuperview() })
        gardenController.getChartData(durartion: "hour")
        chartFilterHour.underline()
        chartFilterDay.removeUnderline()
        chartFilterWeek.removeUnderline()
        chartFilterMonth.removeUnderline()
    }
    @IBOutlet weak var chartFilterDay: UIButton!
    @IBAction func chartFilterDay(_ sender: UIButton) {
        chartAreaScrollView.subviews.forEach({ $0.removeFromSuperview() })
        gardenController.getChartData(durartion: "day")
        chartFilterHour.removeUnderline()
        chartFilterDay.underline()
        chartFilterWeek.removeUnderline()
        chartFilterMonth.removeUnderline()
    }
    @IBOutlet weak var chartFilterWeek: UIButton!
    @IBAction func chartFilterWeek(_ sender: UIButton) {
        chartAreaScrollView.subviews.forEach({ $0.removeFromSuperview() })
        gardenController.getChartData(durartion: "week")
        chartFilterHour.removeUnderline()
        chartFilterDay.removeUnderline()
        chartFilterWeek.underline()
        chartFilterMonth.removeUnderline()
    }
    @IBOutlet weak var chartFilterMonth: UIButton!
    @IBAction func chartFilterMonth(_ sender: UIButton) {
        chartAreaScrollView.subviews.forEach({ $0.removeFromSuperview() })
        gardenController.getChartData(durartion: "month")
        chartFilterHour.removeUnderline()
        chartFilterDay.removeUnderline()
        chartFilterWeek.removeUnderline()
        chartFilterMonth.underline()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
         chartFilterHour.underline()
        
        // Call API's to get data
        gardenController.getChartData(durartion: "hour")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gardenController.delegate = self
        chartAreaScrollView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}


extension GardenViewController: GardenControllerDelegate {
    
    func didFailDataUpdateWithError(displayMsg: Bool) {
        if displayMsg {
            SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
            SVProgressHUD.showError(withStatus: "Network/API error")
        }
    }
    
    // Process chart data
    func createSlide() -> Slide {
        let baseSlide:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        baseSlide.chartView.leftAxis.drawAxisLineEnabled = false
        baseSlide.chartView.leftAxis.drawGridLinesEnabled = false
        baseSlide.chartView.leftAxis.gridColor = NSUIColor.clear
        
        baseSlide.chartView.xAxis.drawGridLinesEnabled = false
        baseSlide.chartView.xAxis.enabled = false
        
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
        chartResultsData.mode = .cubicBezier
        return chartResultsData
    }
    
    func createSlides(chartData: [RoomSensorBaseClass]) -> [Slide] {
        
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
        let HumiditySlide = createSlide()
        HumiditySlide.chartTitleLabel.text = "Humidity"
        if (chartData[0].data?.count != nil) {
            let chartHumData = (0..<chartData[0].data!.count).map { (i) -> ChartDataEntry in
                let val = chartData[0].data![i].humidity?.rounded(.up)
                return ChartDataEntry(x: Double(i), y: Double(val ?? 0))
            }
            chartResultsData = formatChart(chartData: chartHumData)
            lineChartData.addDataSet(chartResultsData)
            HumiditySlide.chartView.leftAxis.axisMinimum = 0
            HumiditySlide.chartView.data = lineChartData
            
            // Tidy up vars
            lineChartData = LineChartData()
            chartResultsData = LineChartDataSet()
        }
        showSlides.append(HumiditySlide) // Add slide
        
        // Battery
        let BatterySlide = createSlide()
        BatterySlide.chartTitleLabel.text = "Battery"
        if (chartData[0].data?.count != nil) {
            let chartBatData = (0..<chartData[0].data!.count).map { (i) -> ChartDataEntry in
                let val = chartData[0].data![i].battery!
                return ChartDataEntry(x: Double(i), y: Double(val) ?? 0)
            }
            chartResultsData = formatChart(chartData: chartBatData)
            lineChartData.addDataSet(chartResultsData)
            BatterySlide.chartView.leftAxis.axisMinimum = 0
            BatterySlide.chartView.leftAxis.axisMaximum = 100
            BatterySlide.chartView.data = lineChartData
                
            // Tidy up vars
            lineChartData = LineChartData()
            chartResultsData = LineChartDataSet()
        }
            
        showSlides.append(BatterySlide) // Add slide
        return showSlides
    }
    
    func setupSlideScrollView(slides : [Slide]) {
        chartAreaScrollView.frame = CGRect(x: 8, y: 76, width: view.frame.width, height: view.frame.height)
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
    
   
}
