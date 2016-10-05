//
//  percentageViewController.swift
//  percentage
//
//  Created by Swapnil Dhanwal on 30/08/16.
//  Copyright © 2016 Swapnil Dhanwal. All rights reserved.
//

import UIKit
import NYAlertViewController


//global variables

var semesters = [Int]()

class percentageViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    //object variables
    var scrollView = UIScrollView()
    var mainView = UIView()
    var contentView = UIView()
    var pickerView = UIPickerView()
    var semesterPickerView = UIPickerView()
    var mainHeight = CGFloat()
    var mainWidth = CGFloat()
    var viewWidth = CGFloat()
    var viewHeight = CGFloat()
    var navHeight = CGFloat()
    var currentSemester = Int()
    var pickerWidth = CGFloat()
    var pickerHeight = CGFloat()
    var tapToHideKeyboard = UITapGestureRecognizer()
    
    //variables for the branch pickerView
    var branches = ["COE", "IT", "ECE", "ICE", "MPAE"]
    var branchesPrime = ["coe", "it", "ece", "ice", "mpae"]
    var branch = String()
    
    //variables for the semesters pickerView
    var semester = Int()
    
    //variables to populate the contentView and calculate percentage
    var subjects = [[String:AnyObject]]()
    var jsonData = [String : AnyObject]()
    var textFieldsTheory = [UITextField]()
    var textFieldsPractical = [UITextField]()
    var textFields = [UITextField]()
    var labelsTheory = [UILabel]()
    var labelsPractical = [UILabel]()
    var labels = [UILabel]()
    var creditsTotal = Int()
    var marksTotal = Int()
    var percentages = [Double]()
    var marks = [[Int]]()
    var currentTextField = UITextField()
    var dy = CGFloat()
    var currentFrame = CGRect()
    var newFrame = CGRect()
    var keyBoardFrame = CGRect()
    var nextButton = UIButton()
    var backButton = UIButton()
    var calculateButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentSemester = 1
        marksTotal = 0
        creditsTotal = 0
        percentages.removeAll()
        //Loading json data
        
        if isLandscape()
        {
            
            self.nextButton.isHidden = true
            self.backButton.isHidden = true
            self.calculateButton.isHidden = true
            
        }
        
        let filePath = Bundle.main.path(forResource: "subjects", ofType: "json")!
        do
        {
            let dataString = try NSString(contentsOfFile: filePath , encoding: String.Encoding.utf8.rawValue)
            let data = dataString.data(using: String.Encoding.utf8.rawValue)
            self.jsonData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
        }
        catch
        {
            print("JSON serialisation failed!")
        }
        
        
        if self.navigationController?.navigationBar != nil
        {
            navHeight = (self.navigationController?.navigationBar.frame.height)!
        }
        else
        {
            navHeight = 0
        }
        
        mainHeight = self.view.bounds.height * 0.90-navHeight
        mainWidth = self.view.bounds.width * 0.85
        viewHeight = self.view.bounds.height
        viewWidth = self.view.bounds.width
        pickerWidth = self.view.bounds.width * 0.5
        pickerHeight = self.view.bounds.width*0.5
        
        mainView.frame = CGRect(x: self.viewWidth/2-self.mainWidth/2, y: self.navHeight*0.75+self.self.viewHeight/2-self.mainHeight/2, width: self.mainWidth, height: self.mainHeight)
        self.currentFrame = mainView.frame
        mainView.layer.cornerRadius = 8
        mainView.layer.masksToBounds = true
        mainView.backgroundColor = getColor(red: 0, green: 179, blue: 164)
        mainView.alpha = 0
        self.view.addSubview(mainView)
        
        scrollView.frame = CGRect(x: 0, y: 0, width: mainWidth, height: mainHeight)
        scrollView.contentSize = CGSize(width: mainWidth, height: 800)
        self.mainView.addSubview(scrollView)
        
        contentView.frame = CGRect(x: 0, y: 0, width: mainWidth, height: 800);
        contentView.backgroundColor = getColor(red: 0, green: 179, blue: 164)
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = true
        self.scrollView.addSubview(contentView)
        
        //setting the autoresixing masks for landscape view
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        scrollView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        pickerView = UIPickerView()
        pickerView.tag = 0
        pickerView.delegate = self
        pickerView.dataSource = self
        
        semesterPickerView = UIPickerView()
        semesterPickerView.tag = 1
        semesterPickerView.delegate = self
        semesterPickerView.dataSource = self
        
        //setting up the tap gesture recogniser which will hide the keyboard when the user taps elsewhere on the screen. We will leave it disabled till the user begins editing
        tapToHideKeyboard.numberOfTapsRequired = 1
        tapToHideKeyboard.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tapToHideKeyboard)
        tapToHideKeyboard.isEnabled = false
        
        //At this point we are in a position to set variables such as the number of semesters, the current branch etc...
        let alert = NYAlertViewController()
        alert.titleFont = UIFont(name: "Avenir Next Condensed", size: 20)
        alert.message = ""
        alert.title = "Select Your Branch"
        alert.alertViewContentView = pickerView
        alert.buttonColor = getColor(red: 0, green: 179, blue: 164)
        alert.buttonTitleFont = UIFont(name: "Avenir Next Condensed", size: 20)
        alert.addAction(NYAlertAction(title: "OK", style: .default, handler: { (action) in
            
            self.branch = self.branches[self.pickerView.selectedRow(inComponent: 0)]
            self.subjects = self.jsonData[self.branchesPrime[self.pickerView.selectedRow(inComponent: 0)]] as! [[String:AnyObject]]
            
            for i in 0..<self.subjects.count
            {
                
                semesters.append(i+1)
                
            }
            
            
            self.dismiss(animated: true, completion: {
                
                let semesterAlert = NYAlertViewController()
                semesterAlert.titleFont = UIFont(name: "Avenir Next Condensed", size: 20)
                semesterAlert.message = ""
                semesterAlert.title = "Select your semester"
                semesterAlert.alertViewContentView = self.semesterPickerView
                semesterAlert.buttonColor = getColor(red: 0, green: 179, blue: 164)
                semesterAlert.buttonTitleFont = UIFont(name: "Avenir Next Condensed", size: 20)
                semesterAlert.addAction(NYAlertAction(title: "Done", style: .default, handler: { (action) in
                    
                    self.semester = self.semesterPickerView.selectedRow(inComponent: 0) + 1
                    for _ in 0..<self.semester
                    {
                        self.percentages.append(0)
                    }
                    
                    
                    self.dismiss(animated: true, completion: { 
                        
                        UIView.animate(withDuration: 0.3, animations: {
                            
                                                self.drawView()
                                                self.mainView.alpha = 1

                        })
                        
                    })
                    
                }))
                self.present(semesterAlert, animated: true, completion: nil)
                
                
            })
            
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func viewWillLayoutSubviews() {
        
        currentFrame = self.mainView.frame
        
        mainHeight = self.view.frame.height * 0.90-navHeight
        mainWidth = self.view.frame.width * 0.85
        viewHeight = self.view.frame.height
        viewWidth = self.view.frame.width
        pickerWidth = self.view.frame.width * 0.5
        pickerHeight = self.view.frame.width*0.5
        
    }
    
    override func viewDidLayoutSubviews() {
        
        newFrame = self.mainView.frame
        
    }
    
    //MARK : Need to register the view for notifications so as to shift the view up by a specific height when the keyboard is shown
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(percentageViewController.keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(percentageViewController.keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    func keyboardWillShow(_ notification : Notification)
    {
        
        self.keyBoardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    
        let tf1 = self.scrollView.convert(currentTextField.frame, to: self.mainView)
        let tf2 = self.mainView.convert(tf1, to: self.view)
        
        if tf2.maxY >= self.keyBoardFrame.minY
        {
            self.dy = tf2.maxY - self.keyBoardFrame.minY + 10
            UIView.animate(withDuration: 0.3, animations: { 
                
                self.mainView.frame.origin.y -= self.dy
                
            })

        }
        
        
    }
    
    func keyboardWillHide(_ notification : Notification)
    {
        
        UIView.animate(withDuration: 0.3) {
            
            self.mainView.frame.origin.y += self.dy
            self.dy = 0
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        
        if fromInterfaceOrientation == .portrait
        {
            
            self.view.endEditing(true)
            self.nextButton.isHidden = false
            self.backButton.isHidden = false
            self.calculateButton.isHidden = false
            
        }
        
        if fromInterfaceOrientation == .landscapeRight && self.interfaceOrientation == .portrait
        {
            
            self.drawView()
            
        }
        
        if fromInterfaceOrientation == .landscapeLeft && self.interfaceOrientation == .portrait
        {

            self.drawView()
        }
        
    }
    
    
    //MARK : add subviews to the mainView
    
    func drawView()
    {
        
        //Clearing all views and arrays of textFields and labels
        for view in contentView.subviews
        {
            view.removeFromSuperview()
        }
        self.textFieldsPractical.removeAll()
        self.textFieldsTheory.removeAll()
        self.labelsTheory.removeAll()
        self.labelsPractical.removeAll()
        self.textFields.removeAll()
        self.labels.removeAll()
        
        let textHeight : CGFloat = 20
        let textWidth : CGFloat = mainWidth * 0.3
        let labelWidth : CGFloat = mainWidth * 0.3
        let labelHeight = textHeight
        var height : CGFloat = 10
        
        let semesterLabel = UILabel(frame: CGRect(x: mainWidth/2-mainWidth*0.85/2, y: height, width: 0.85*mainWidth, height: 25))
        semesterLabel.text = "Semester \(currentSemester)"
        semesterLabel.font = UIFont(name: "Avenir Next Condensed", size: 25)
        semesterLabel.textAlignment = .center
        semesterLabel.autoresizingMask = [.flexibleWidth]
        self.contentView.addSubview(semesterLabel)
        
        height += 25+20
        
        //Loading list of subjects in the current semester
        let subjectList = self.subjects[currentSemester-1]["subjects"] as! [String : AnyObject]
        let theory = subjectList["theory"] as? [[String:AnyObject]]
        let practical = subjectList["practical"] as? [[String:AnyObject]]
        
        for i in 0..<(theory?.count)!
        {
            
            let label = UILabel(frame: CGRect(x: mainWidth*1/4-labelWidth/2, y: height, width: labelWidth, height: labelHeight))
            label.font = UIFont(name: "Avenir Next Condensed", size: 15)
            if let item = theory?[i]
            {
                label.text = "\(item["name"] as! String)"
            }
            label.autoresizingMask = [.flexibleWidth, .flexibleRightMargin]
            labelsTheory.append(label)
            
            
            let textField = UITextField(frame: CGRect(x: self.mainWidth*3/4-textWidth/2, y: height, width: textWidth, height: textHeight))
            textField.text = String(describing: theory![i]["marks"]!)
            textField.borderStyle = .roundedRect
            textField.backgroundColor = UIColor.white
            _ = textField.frame.height.advanced(by: 15)
            textField.font = UIFont(name: "Avenir Next Condensed", size: 15)
            textField.textAlignment = .center
            textField.keyboardType = .default
            textField.keyboardAppearance = .dark
            textField.delegate = self
            textField.autoresizingMask = [.flexibleWidth, .flexibleLeftMargin]
            textFieldsTheory.append(textField)
            
            height += 40
            
        }
        
        for i in 0 ..< textFieldsTheory.count
        {
            textFields.append(textFieldsTheory[i])
            labels.append(labelsTheory[i])
            contentView.addSubview(textFieldsTheory[i])
            contentView.addSubview(labelsTheory[i])
        }
        
        
        for i in 0..<(practical?.count)!
        {
            
            let label = UILabel(frame: CGRect(x: mainWidth*1/4-labelWidth/2, y: height, width: labelWidth, height: labelHeight))
            label.font = UIFont(name: "Avenir Next Condensed", size: 15)
            if let item = practical?[i]
            {
                label.text = "\(item["name"] as! String)"
            }
            label.autoresizingMask = [.flexibleWidth, .flexibleRightMargin]
            labelsPractical.append(label)
            
            let textField = UITextField(frame: CGRect(x: mainWidth*3/4-textWidth/2, y: height, width: textWidth, height: textHeight))
            textField.text = String(describing: practical![i]["marks"]!)
            textField.borderStyle = .roundedRect
            textField.backgroundColor = UIColor.white
            _ = textField.frame.height.advanced(by: 15)
            textField.font = UIFont(name: "Avenir Next Condensed", size: 15)
            textField.textAlignment = .center
            textField.keyboardType = .default
            textField.keyboardAppearance = .dark
            textField.delegate = self
            textField.autoresizingMask = [.flexibleWidth, .flexibleLeftMargin]
            textFieldsPractical.append(textField)
            
            height += 40
        }
        
        for i in 0 ..< textFieldsPractical.count
        {
            textFields.append(textFieldsPractical[i])
            labels.append(labelsPractical[i])
            contentView.addSubview(textFieldsPractical[i])
            contentView.addSubview(labelsPractical[i])
        }
        
        let buttonWidth = mainWidth*0.45
        let buttonHeight : CGFloat = 30
        nextButton = UIButton(frame: CGRect(x: mainWidth*0.75-buttonWidth/2, y: height, width: buttonWidth, height: buttonHeight))
        nextButton.titleLabel?.text = "Next"
        nextButton.setTitle("Next", for: UIControlState())
        nextButton.backgroundColor = UIColor.white
        nextButton.layer.cornerRadius = 4
        nextButton.titleLabel?.font = UIFont(name: "Avenir Next Condensed", size: 15)
        nextButton.titleLabel?.textAlignment = .center
        nextButton.setTitleColor(getColor(red: 0, green: 179, blue: 164), for: UIControlState())
        nextButton.setTitleColor(UIColor.lightGray, for: .disabled)
        nextButton.isUserInteractionEnabled = true
        nextButton.addTarget(self, action: #selector(percentageViewController.next as (percentageViewController) -> () -> ()), for: .touchUpInside)
        nextButton.autoresizingMask = [.flexibleLeftMargin, .flexibleWidth]
        self.contentView.addSubview(nextButton)
        
        if currentSemester == self.semester
        {
            nextButton.isEnabled = false
        }
        else
        {
            nextButton.isEnabled = true
        }
        
        backButton = UIButton(frame: CGRect(x: mainWidth/4 - buttonWidth/2, y: height, width: buttonWidth, height: buttonHeight))
        backButton.setTitle("Back", for: UIControlState())
        backButton.setTitleColor(getColor(red: 0, green: 179, blue: 164), for: UIControlState())
        backButton.setTitleColor(UIColor.lightGray, for: .disabled)
        backButton.layer.cornerRadius = 4
        backButton.backgroundColor = UIColor.white
        backButton.titleLabel?.font = UIFont(name: "Avenir Next Condensed", size: 15)
        backButton.addTarget(self, action: #selector(percentageViewController.back), for: .touchUpInside)
        backButton.autoresizingMask = [.flexibleRightMargin, .flexibleWidth]
        self.contentView.addSubview(backButton)
        
        if currentSemester == 1
        {
            backButton.isEnabled = false
        }
        else
        {
            backButton.isEnabled = true
        }
        
        height += 50
        
        calculateButton = UIButton(frame: CGRect(x: mainWidth*0.5-buttonWidth/2, y: height, width: buttonWidth, height: buttonHeight))
        calculateButton.setTitle("Calculate", for: UIControlState())
        calculateButton.setTitleColor(getColor(red: 0, green: 179, blue: 164), for: UIControlState())
        calculateButton.titleLabel!.font = UIFont(name: "Avenir Next Condensed", size: 15)
        calculateButton.backgroundColor = UIColor.white
        calculateButton.layer.cornerRadius = 4
        calculateButton.addTarget(self, action: #selector(percentageViewController.calculate), for: .touchUpInside)
        calculateButton.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleWidth]
        self.contentView.addSubview(calculateButton)
        
        height += 50
        
        scrollView.contentSize.height = height
        
    }
    
    //MARK : Methods for calculate, next and back buttons
    
    func calculate()
    {
        
        var subjectArray = self.subjects[currentSemester-1]["subjects"] as! [String:AnyObject]
        var marksTotal = 0
        var creditsTotal = 0
        
        //Calculating the percentage and storing it in an array
        
        for i in 0..<self.textFieldsTheory.count
        {
            
            if var theory = subjectArray["theory"] as? [[String:AnyObject]]
            {
                
                let currentSubject = theory[i]
                marksTotal += Int(textFieldsTheory[i].text!)! * (currentSubject["credits"] as! NSInteger)
                creditsTotal += currentSubject["credits"] as! NSInteger
                theory[i]["marks"] =  textFieldsTheory[i].text as AnyObject?
                subjectArray["theory"] = theory as AnyObject?
            }
        }
        self.subjects[currentSemester-1]["subjects"] = subjectArray as AnyObject?
        
        for i in 0..<self.textFieldsPractical.count
        {
            if var practical = subjectArray["practical"] as? [[String:AnyObject]]
            {
                
                let currentSubject = practical[i]
                marksTotal += Int(textFieldsPractical[i].text!)! * (currentSubject["credits"] as! NSInteger)
                creditsTotal += currentSubject["credits"] as! NSInteger
                practical[i]["marks"] = textFieldsPractical[i].text as AnyObject?
                subjectArray["practical"] = practical as AnyObject?
                
            }
        }
        self.subjects[currentSemester-1]["subjects"] = subjectArray as AnyObject?
        
        percentages[currentSemester-1] = Double(marksTotal)/Double(creditsTotal)
        
        let chartView = chartViewController()
        chartView.percentages = self.percentages
        
        self.navigationController?.pushViewController(chartView, animated: true)
        
    }
    
    func next() {
        
        var subjectArray = self.subjects[currentSemester-1]["subjects"] as! [String:AnyObject]
        var marksTotal = 0
        var creditsTotal = 0
        
        //Calculating the percentage and storing it in an array
        
        for i in 0..<self.textFieldsTheory.count
        {
            
            if var theory = subjectArray["theory"] as? [[String:AnyObject]]
            {
                
                let currentSubject = theory[i]
                marksTotal += Int(textFieldsTheory[i].text!)! * (currentSubject["credits"] as! NSInteger)
                creditsTotal += currentSubject["credits"] as! NSInteger
                theory[i]["marks"] =  textFieldsTheory[i].text as AnyObject?
                subjectArray["theory"] = theory as AnyObject?
            }
        }
        
        self.subjects[currentSemester-1]["subjects"] = subjectArray as AnyObject?
        
        for i in 0..<self.textFieldsPractical.count
        {
            if var practical = subjectArray["practical"] as? [[String:AnyObject]]
            {
                
                let currentSubject = practical[i]
                marksTotal += Int(textFieldsPractical[i].text!)! * (currentSubject["credits"] as! NSInteger)
                creditsTotal += currentSubject["credits"] as! NSInteger
                practical[i]["marks"] = textFieldsPractical[i].text as AnyObject?
                subjectArray["practical"] = practical as AnyObject?
                
            }
        }
        
        self.subjects[currentSemester-1]["subjects"] = subjectArray as AnyObject?
        
        percentages[currentSemester-1] = Double(marksTotal)/Double(creditsTotal)
        
        currentSemester += 1
        
        let originalFrame = self.mainView.frame
        
        UIView.animate(withDuration: 0.5, animations: {
            
            //self.view.layoutIfNeeded()
            self.mainView.center.x -= 600
            
            }, completion: { (success) in
                
                self.mainView.center.x += 2000
                self.drawView()
                
                UIView.animate(withDuration: 0.5, animations: {
                    
                    self.mainView.frame = originalFrame
                    self.mainView.center.x -= 20
                    
                    }, completion: { (success) in
                        
                        UIView.animate(withDuration: 0.3, animations: {
                            
                            self.mainView.center.x += 20
                            
                        })
                }) 
        })
        
    }

    
    func back()
    {
        
        var subjectArray = self.subjects[currentSemester-1]["subjects"] as! [String:AnyObject]
        var marksTotal = 0
        var creditsTotal = 0
        
        //Calculating the percentage and storing it in an array
        
        for i in 0..<self.textFieldsTheory.count
        {
            
            if var theory = subjectArray["theory"] as? [[String:AnyObject]]
            {
                
                let currentSubject = theory[i]
                marksTotal += Int(textFieldsTheory[i].text!)! * (currentSubject["credits"] as! NSInteger)
                creditsTotal += currentSubject["credits"] as! NSInteger
                theory[i]["marks"] =  textFieldsTheory[i].text as AnyObject?
                subjectArray["theory"] = theory as AnyObject?
            }
        }
        self.subjects[currentSemester-1]["subjects"] = subjectArray as AnyObject?
        
        for i in 0..<self.textFieldsPractical.count
        {
            if var practical = subjectArray["practical"] as? [[String:AnyObject]]
            {
                
                let currentSubject = practical[i]
                marksTotal += Int(textFieldsPractical[i].text!)! * (currentSubject["credits"] as! NSInteger)
                creditsTotal += currentSubject["credits"] as! NSInteger
                practical[i]["marks"] = textFieldsPractical[i].text as AnyObject?
                subjectArray["practical"] = practical as AnyObject?
                
            }
        }
        self.subjects[currentSemester-1]["subjects"] = subjectArray as AnyObject?
        
        self.percentages[currentSemester-1] = Double(marksTotal)/Double(creditsTotal)
        
        currentSemester -= 1
        
        let originalFrame = self.mainView.frame
        
        
        UIView.animate(withDuration: 0.5, animations: {
            
            //self.view.layoutIfNeeded()
            self.mainView.center.x += 2000
            
            
        }, completion: { (success) in
            
            //self.view.layoutIfNeeded()
            self.mainView.center.x -= 2600
            self.drawView()
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.mainView.frame = originalFrame
                self.mainView.center.x += 20
                
                
            }, completion: { (success) in
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.mainView.center.x -= 20
                    
                })
            }) 
        }) 
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK : textField delegate functions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if self.textFields.contains(textField)
        {
            self.currentTextField = textField
        }
        
        textField.select(self)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.resignFirstResponder()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField.text?.characters.count)! > 0 && isNumber(text: textField.text!) && Int(textField.text!)! <= 100 && Int(textField.text!)! >= 0
        {
            self.view.endEditing(true)
        }
        
        else
        {
            textField.text = "0";
        }
        
        return true
    }
    
    func isNumber(text : String) -> Bool
    {
        let badCharacterSet = NSCharacterSet.decimalDigits.inverted
        
        if text.rangeOfCharacter(from: badCharacterSet) == nil
        {
            return true
        }
        
        return false
    }
    
    //MARK : pickerView delegate and datasource methods
    
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    
    
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView.tag == 0
        {
            return self.branches.count
        }
        return semesters.count
    }
    
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView.tag == 0
        {
            return branches[row]
    
        }
        return String(semesters[row])
    }
    
    func isLandscape() -> Bool
    {
        
        if self.view.bounds.width > self.view.bounds.height
        {
           
            return true
        
        }
    
        return false
    
    }
    
    
    
}

