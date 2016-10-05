//
//  chartViewController.swift
//  percentageFinal
//
//  Created by Swapnil Dhanwal on 05/10/16.
//  Copyright © 2016 Swapnil Dhanwal. All rights reserved.
//

import UIKit
import Charts

class chartViewController: UIViewController, ChartViewDelegate, UIScrollViewDelegate {
    
    var scrollView = UIScrollView()
    var infoView = UIView()
    var viewHeight = CGFloat()
    var viewWidth = CGFloat()
    var chartHeight = CGFloat()
    var chartWidth = CGFloat()
    var navHeight = CGFloat()
    var chart = LineChartView()
    var line = UILabel()
    
    //variables to populate the infoView
    var subjects = [String : AnyObject]()
    var percentages = [Double]()
    var marksTotal = [Int]()
    var aggregateWithoutDropping = [Double]()
    var aggregateWithDropping = [Double]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        //Setting up the scrollView
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 10, width: self.view.bounds.width, height: self.view.bounds.height))
        scrollView.backgroundColor = UIColor.white
        scrollView.contentSize = CGSize(width: self.view.bounds.width, height: 1000)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        
        //setting up the LineChartView
        chart = LineChartView(frame: CGRect(x: 0, y: 0, width: self.scrollView.frame.width, height: 300))
        chart.autoresizingMask = [.flexibleWidth, .flexibleLeftMargin, .flexibleRightMargin]
        chartHeight = self.chart.frame.height
        chartWidth = self.chart.frame.width
        chart.xAxis.axisRange = Double(percentages.count)
        chart.xAxis.axisMinimum = 1
        chart.xAxis.axisMaximum = Double(percentages.count)
        chart.layer.backgroundColor = UIColor.lightText.cgColor
        
        let yVals = percentages
        var xVals = [Int]()
        for i in 0..<percentages.count
        {
            
            xVals.append(i+1)
        
        }
        var chartDataEntries = [ChartDataEntry]()
        for i in 0..<yVals.count
        {
            
            chartDataEntries.append(ChartDataEntry(x: Double(xVals[i]), y: yVals[i]))
            
        }
        let unDroppedLineDataSet = LineChartDataSet(values: chartDataEntries, label: "Without Dropping")
        let chartData = LineChartData(dataSets: [unDroppedLineDataSet])
        chart.data = chartData
        self.scrollView.addSubview(chart)
        
        //setting up the line demarcating the chart and the info view
        line = UILabel(frame: CGRect(x: 0, y: self.chart.frame.maxY, width: self.scrollView.bounds.width, height: 5))
        line.backgroundColor = getColor(0, green: 179, blue: 164)
        line.autoresizingMask = [.flexibleWidth]
        scrollView.addSubview(line)
        
        infoView = UIView(frame: CGRect(x: 0, y: self.line.frame.maxY, width: self.scrollView.frame.width, height: 500))
        infoView.backgroundColor = UIColor.lightGray
        infoView.autoresizingMask = [.flexibleWidth]
        self.scrollView.addSubview(infoView)
        
        //finally, update the scrollView's contentSize property to fit all its subViews
        self.scrollView.contentSize = CGSize(width: self.view.bounds.width, height: self.chart.bounds.height + 5 + self.infoView.bounds.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        let y = self.scrollView.contentOffset.y
        
        print(y)
        
        if y < 0
        {
            print("dragged")
            self.chart.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.height)!, width: self.scrollView.bounds.width, height: 300-0.5*y-(self.navigationController?.navigationBar.frame.height)! * 0.5)
            self.chart.center.y += y
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getColor(_ red : CGFloat, green : CGFloat, blue : CGFloat) -> UIColor
    {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
