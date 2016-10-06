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
    var textView = UITextView()
    var viewHeight = CGFloat()
    var viewWidth = CGFloat()
    var chartHeight = CGFloat()
    var chartWidth = CGFloat()
    var navHeight = CGFloat()
    var chart = LineChartView()
    var line = UILabel()
    
    //variables to populate the infoView
    var subjects = [[String : AnyObject]]()
    var percentages = [Double]()
    var marksTotal = [Int]()
    var creditsTotal = [Int]()
    var aggregateWithoutDropping = [Double]()
    var aggregateWithDropping = [Double]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        //Setting up the scrollView
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 10, width: self.view.bounds.width, height: self.view.bounds.height))
        scrollView.backgroundColor = UIColor.white
        scrollView.contentSize = CGSize(width: self.view.bounds.width, height: 1000)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleRightMargin, .flexibleRightMargin]
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
        chart.animate(xAxisDuration: 0.3, yAxisDuration: 0.3)
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
        infoView.backgroundColor = UIColor(red: 231/255, green: 234/255, blue: 236/255, alpha: 1)
        infoView.autoresizingMask = [.flexibleWidth, .flexibleRightMargin, .flexibleLeftMargin]
        self.scrollView.addSubview(infoView)
        
        textView = UITextView(frame: CGRect(x: self.infoView.frame.width/2 - 0.90*self.infoView.frame.width/2, y: self.infoView.frame.height/2 - 0.90*self.infoView.frame.height/2, width: 0.90*self.infoView.frame.width, height: 0.90*self.infoView.frame.height))
        var textString = String()
        
        let s = NSAttributedString(string: "Percentages: \n\n", attributes: [NSFontAttributeName : UIFont(name : "AvenirNext-Medium", size : 20)])
        let sn = s.string
        textString.append(sn)
        
        for i in 0..<self.percentages.count
        {
            
            let p = percentages[i]
            textString.append("Semester \(i+1) | \(Double(round(100*p)/100))\n\n")
            
        }
        
        //calculating the aggregate without dropping
        var aggregate = Double()
        var tm = Int()
        var tc = Int()
        print(creditsTotal)
        print(marksTotal)
        for i in 0..<marksTotal.count
        {
            
            tm += marksTotal[i]
            tc += creditsTotal[i]
            
        }
        aggregate = Double(tm)/Double(tc)
        
        textString.append("Aggregate | \(Double(round(100*aggregate)/100))\n\n")
        
        textView.isEditable = true
        textView.isSelectable = true
        textView.font = UIFont(name: "Avenir Next Condensed", size: 20)
        textView.text = textString
        textView.isEditable = false
        textView.autoresizingMask = [.flexibleWidth, .flexibleLeftMargin, .flexibleRightMargin]
        let height = textView.sizeThatFits(CGSize(width: self.textView.bounds.width, height: 1000)).height
        textView.frame = CGRect(x: self.infoView.frame.width/2 - 0.90*self.infoView.frame.width/2, y: self.infoView.frame.height/2 - 0.90*self.infoView.frame.height/2, width: 0.90*self.infoView.frame.width, height: max(0.90*self.infoView.frame.height, height))
        infoView.frame = CGRect(x: 0, y: self.line.frame.maxY, width: self.scrollView.frame.width, height: max(500, textView.bounds.height+40))
        infoView.addSubview(textView)
        
        //finally, update the scrollView's contentSize property to fit all its subViews
        self.scrollView.contentSize = CGSize(width: self.view.bounds.width, height: self.chart.bounds.height + 5 + self.infoView.bounds.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        let y = self.scrollView.contentOffset.y
        
        if let h = self.navigationController?.navigationBar.frame.height
        {
            if y < 0
            {
                
                self.chart.frame = CGRect(x: 0, y: h, width: self.scrollView.bounds.width, height: 300-0.5*y-h * 0.5)
                self.chart.center.y += y
                
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        
        let height = textView.sizeThatFits(CGSize(width: self.textView.bounds.width, height: 1000)).height
        textView.frame = CGRect(x: self.infoView.frame.width/2 - 0.90*self.infoView.frame.width/2, y: self.infoView.frame.height/2 - 0.90*self.infoView.frame.height/2, width: 0.90*self.infoView.frame.width, height: max(0.90*self.infoView.frame.height, height))
        infoView.frame = CGRect(x: 0, y: self.line.frame.maxY, width: self.scrollView.frame.width, height: max(500, textView.bounds.height+40))
        self.scrollView.contentSize = CGSize(width: self.view.bounds.width, height: self.chart.bounds.height + 5 + self.infoView.bounds.height)

        
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
