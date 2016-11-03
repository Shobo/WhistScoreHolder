//
//  WSHMathAdditions.swift
//  WhistScoreHolder
//
//  Created by Mihai Costiug on 07/05/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import Foundation

func smallestSquareRootWithSquareLargerThan(_ number: Int) -> Int {
    var counter = number
    
    while counter <= (number ^^ 2) {
        let squareRoot = sqrt(Double(counter))
        
        if squareRoot == floor(squareRoot) {    //square root is an integer
            return Int(squareRoot)
        }
        
        counter += 1
    }
    
    return 0    //no result found
}

infix operator ^^

func ^^(radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}
