//  ViewController.swift
//  CalculatorBrain
//  Created by M1 on 15/10/2018.
//  Copyright © 2018 Dmitry Alexandrov. All rights reserved.
import UIKit
class ViewController: UIViewController
{
    fileprivate var numEditing: Bool = false
    fileprivate var brain = CalcBrain()
    
    fileprivate var displ: Double {
        get {
            return Double(display!.text!)!
        }
        set {
            display.text = String(newValue)
        }
        
    }
    
    
    @IBOutlet weak var display: UILabel!
  
    
    @IBAction func numberPressed(_ sender: UIButton) {
        let numPressed = sender.currentTitle!
        
        if numEditing {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + numPressed
        } else {
            numEditing = true
            display.text = numPressed
        }
    }
    
    @IBAction func reset(_ sender: UIButton) {
        brain.reset()
        displ = 0
        display.text = "0"
        numEditing = false
    }
    
    @IBAction func operation(_ sender: UIButton) {
        if numEditing {
            brain.setOperand(displ)
            numEditing = false
        }
        if let oper = sender.currentTitle {
            brain.performOperation(oper)
        }
        displ = brain.result
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    
}

