//
//  ViewController.swift
//  002
//
//  Created by songjiayang on 6/22/14.
//  Copyright (c) 2014 swift 101. All rights reserved.
//


// A extension for substring by range like ruby way.
import Foundation

extension String {
    subscript(range: Range<Int>) -> String {
        get {
            let location = range._startIndex
            let endIndex = range.endIndex < 0 ? countElements(self) + range.endIndex : range.endIndex
            let length = endIndex - range._startIndex + 1
            return self.bridgeToObjectiveC().substringWithRange(NSMakeRange(location,length))
        }
    }
}

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var result : UILabel
    
    // input number cache
    var operator:String?
    var inputNum1:Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        result.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // All result directly change button click
    
    @IBAction func onClickNum0(sender : UIButton) {
        resultAppend("0")
    }
    @IBAction func onClickNum1(sender : UIButton) {
       resultAppend("1")
    }
    
    @IBAction func onClickNum2(sender : UIButton) {
        resultAppend("2")
    }

    @IBAction func onClickNum3(sender : UIButton) {
       resultAppend("3")
    }
    
    @IBAction func onClickNumber4(sender : UIButton) {
        resultAppend("4")
    }
    
    @IBAction func onClickNum5(sender : UIButton) {
        resultAppend("5")
    }
    
    @IBAction func onClickNum6(sender : UIButton) {
        resultAppend("6")
    }
    
    @IBAction func onClickNum7(sender : UIButton) {
       resultAppend( "7")
    }
    
    @IBAction func onClickNum8(sender : UIButton) {
        resultAppend("8")
    }
    
    @IBAction func onClickNum9(sender : UIButton) {
        resultAppend( "9")
    }
    
    @IBAction func onClickPointBtn(sender : UIButton) {
        resultAppend(".")
    }
    @IBAction func onClickDelBtn(sender : UIButton) {
        var value = result.text
        if !value.isEmpty {
            result.text = value[0 .. -2]
        }
    }
    @IBAction func onClearResult(sender : UIButton) {
        result.text = ""
    }
    
    // on operations click
    @IBAction func onClickAddOperator(sender : UIButton) {
        onClickOprator("+")
    }
    
    @IBAction func onClickSubOperator(sender : UIButton) {
        onClickOprator("-")
    }
    @IBAction func onClickMulOperator(sender : UIButton) {
        onClickOprator("*")
    }
    @IBAction func onClickDivOperator(sender : UIButton) {
        onClickOprator("/")
    }
    
    @IBAction func onClickEqul(sender : UIButton) {
        var inputNum2 = NSString(string: result.text).doubleValue
        var _result:Double?
        if operator == "+" {
            _result = inputNum1! + inputNum2
        }
        else if operator == "-" {
            _result = inputNum1! - inputNum2
        }
        else if operator == "*" {
            _result = inputNum1! * inputNum2
        }
        else if operator == "/"{
            _result = inputNum1! / inputNum2
        }
        result.text = "\(_result)"
    }
    
    //helper functions and can be private.
    func onClickOprator(symbol: String) {
        inputNum1 = NSString(string: result.text).doubleValue
        println(inputNum1)
        result.text = ""
        operator = symbol
    }
    
    func resultAppend(v: String){
        result.text = result.text + v
    }
}

