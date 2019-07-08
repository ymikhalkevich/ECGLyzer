//
//  ChartView.swift
//  ECGlyzer
//
//  Created by Yury Mikhalkevich on 5/28/19.
//  Copyright © 2019 Yury Mikhalkevich. All rights reserved.
//

import UIKit
import Charts

class ChartView: UIView {
    private struct Constants {
        static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
        static let margin: CGFloat = 10.0
        static let topBorder: CGFloat = 60
        static let bottomBorder: CGFloat = 50
        static let colorAlpha: CGFloat = 0.3
        static let circleDiameter: CGFloat = 5.0
        
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        //calculate the x point
    }
}

extension ChartView  {
    
    static func setUp (forView: UIView) -> LineChartView {
        let lineChart = LineChartView(frame:  CGRect(x: forView.bounds.minX,
                                             y: forView.bounds.minY,
                                             width: forView.bounds.maxX,
                                             height: forView.bounds.maxY))
        
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        
        lineChart.noDataText = "Please provide data to show"
        
        forView.addSubview(lineChart)
        lineChart.rightAxis.enabled = false
        lineChart.xAxis.labelPosition = .bottom
        lineChart.legend.enabled = false
        
        lineChart.leftAnchor.constraint(equalTo: forView.safeAreaLayoutGuide.leftAnchor,
                                                            constant: 0).isActive = true
        lineChart.rightAnchor.constraint(equalTo: forView.safeAreaLayoutGuide.rightAnchor,
                                                             constant: -5).isActive = true
        lineChart.topAnchor.constraint(equalTo: forView.safeAreaLayoutGuide.topAnchor,
                                                           constant: 10).isActive = true
        lineChart.bottomAnchor.constraint(equalTo: forView.safeAreaLayoutGuide.bottomAnchor,
                                                              constant: 0).isActive = true
        
        return lineChart
    }
}
