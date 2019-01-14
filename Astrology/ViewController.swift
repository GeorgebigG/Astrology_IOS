//
//  ViewController.swift
//  Astrology
//
//  Created by George Nebieridze on 1/12/19.
//  Copyright © 2019 George. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var buttonStack: UIStackView!
    @IBOutlet var dateInput: UITextField!
    
    var buttons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<buttonStack.subviews.count {
            for j in 0..<buttonStack.subviews[i].subviews.count {
                buttons.append(buttonStack.subviews[i].subviews[j] as! UIButton)
            }
        }
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let year =  components.year!
        let month = components.month!
        let day = components.day!
        
        dateInput.text = "\(day)/\(month)/\(year)"
        calculate(date: dateInput.text!)
    }

    @IBAction func dateIsEditting(_ sender: UITextField) {
        let datePickerKeyboard = UIDatePicker()
        datePickerKeyboard.datePickerMode = .date
        sender.inputView = datePickerKeyboard
        datePickerKeyboard.addTarget(self, action: #selector(self.datePickerValueChanged), for: .valueChanged)
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateInput.text = dateFormatter.string(from: sender.date)
        calculate(date: dateInput.text!)
    }
    
    func calculate(date: String) {
        let day = Int(date.split(separator: "/")[0])!
        let month = Int(date.split(separator: "/")[1])!
        let year = Int(date.split(separator: "/")[2])!
        
        let dateSum = digitalSum(day) + digitalSum(month) + digitalSum(year)
        
        var dateSumSum = digitalSum(dateSum)
        
        var subtractionNumber : Int = 0
        if day <= 9 {
            subtractionNumber = 1
        } else {
            subtractionNumber = (day / 10) * 2
        }
        let preFinalNumber = abs(dateSum - subtractionNumber)
        let finalNumber = digitalSum(preFinalNumber)
        
        for i in 0..<buttons.count {
            buttons[i].setTitle(putDigitsSeparatelyInAString(i+1, times: inTotalHowManyTimesItRepeats(digit: i+1, day: day, month: month, year: year, dateSum: dateSum, dateSumSum: dateSumSum, preFinalNumber: preFinalNumber, finalNumber: finalNumber)), for: .normal)
        }
        
        print("\(day), \(month), \(year) \n \(dateSum), \(dateSumSum), \(preFinalNumber), \(finalNumber)")
    }
    
    func digitalSum(_ number: Int) -> Int {
        var sum = 0
        
        for i in 1...String(number).count {
            sum += (number % Int("\(pow(10, i))")!) / Int("\(pow(10, i-1))")!
        }
    
        return sum
    }
    
    func putDigitsSeparatelyInAString(_ digit: Int, times: Int) -> String {
        if times == 0 {
            return " "
        }
        
        var number = 0
        
        for i in 1...times {
            number += Int("\(pow(10, i-1))")! * digit
        }
        
        return "\(number)"
    }
    
    func inTotalHowManyTimesItRepeats(digit: Int, day: Int, month: Int, year: Int, dateSum: Int, dateSumSum: Int, preFinalNumber: Int, finalNumber: Int) -> Int {
        let answer = howManyTimes(digit, repeatsInA: day) + howManyTimes(digit, repeatsInA: month) + howManyTimes(digit, repeatsInA: year) + howManyTimes(digit, repeatsInA: dateSum) + howManyTimes(digit, repeatsInA: dateSumSum) + howManyTimes(digit, repeatsInA: preFinalNumber) + howManyTimes(digit, repeatsInA: finalNumber)

        return answer
    }
    
    func howManyTimes(_ digit: Int, repeatsInA number: Int) -> Int {
        var repetition = 0
        
        for i in 1...String(number).count {
            if (number % Int("\(pow(10, i))")!) / Int("\(pow(10, i-1))")! == digit {
                repetition += 1
            }
        }
        
        return repetition
    }
}

