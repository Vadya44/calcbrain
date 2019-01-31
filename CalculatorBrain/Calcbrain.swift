//  Calcbrain.swift
//  CalculatorBrain
//  Created by M1 on 15/10/2018.
//  Copyright © 2018 Dmitry Alexandrov. All rights reserved.
import Foundation

class CalcBrain
{
    fileprivate var accumulator = 0.0
    fileprivate var secondOperand = 0.0
    fileprivate var isFuncEquals = false
    
    var result : Double {
        get {
            return accumulator
        }
    }
    
    fileprivate struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    fileprivate var pending: PendingBinaryOperationInfo?
    
    func setOperand(_ operand: Double) {
        accumulator = operand
        
        secondOperand = operand
    }
    
    func reset() {
        accumulator = 0
        secondOperand = 0.0
        isFuncEquals = false
        pending = nil
    }
    
    fileprivate enum Operation {
        case binaryOperation( (Double, Double) -> Double )
        case equals
        case constant(Double)
        case unaryOperation( (Double) -> Double )
    }

    fileprivate var operations: Dictionary<String, Operation> = [
        "+": Operation.binaryOperation({ (arg1, arg2) -> Double in
            return (arg1 + arg2)
        }),

        "-": Operation.binaryOperation({ (arg1, arg2) in
            return (arg1 - arg2)
        }),
        
        "✕": Operation.binaryOperation({ ($0 * $1) }),

        "÷": Operation.binaryOperation({ $0 / $1 }),
        
        "=": Operation.equals,
        
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "√": Operation.unaryOperation( sqrt ),
        "±": Operation.unaryOperation( { -$0 } ),
        "Sin": Operation.unaryOperation( sin ),
        "Cos": Operation.unaryOperation( cos ),
    ]
    
    func executeBinaryOperation() {
        if pending != nil && !isFuncEquals {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    func executeLastBinaryOperation() {
        if pending != nil {
            if (isFuncEquals){
                accumulator = pending!.binaryFunction(accumulator, pending!.firstOperand)
            }
            else {
                accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            }
        }
    }
    
    func performOperation(_ symbol: String) {
        if let oper = operations[symbol] {
            switch oper {
            case Operation.binaryOperation(let function):
                executeBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                isFuncEquals = false
            case .equals:
                if (pending != nil) {
                    executeLastBinaryOperation()
                    pending = PendingBinaryOperationInfo(binaryFunction: pending!.binaryFunction, firstOperand: secondOperand)
                    isFuncEquals = true
                }
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                accumulator = function(accumulator)
            }
        }
    }
    
}
