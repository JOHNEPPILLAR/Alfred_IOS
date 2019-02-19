//
//  ChartSlide.swift
//  Alfred_IOS
//
//  Created by John Pillar on 19/02/2019.
//  Copyright © 2019 John Pillar. All rights reserved.
//

import UIKit
import Charts

class ChartSlide: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var ChartTitleLabel: UILabel!
    @IBOutlet weak var ChartView: LineChartView!
}
