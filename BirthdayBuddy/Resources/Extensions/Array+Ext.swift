//
//  Array+Ext.swift
//  BirthdayBuddy
//
//  Created by Max Park on 6/24/22.
//

import Foundation

extension Array {
    
    func rotate(array: inout [Element], k: Int) {
        // Check for edge cases
        if k == 0 || array.count <= 1 {
            return // The resulting array is similar to the input array
        }

        // Calculate the effective number of rotations
        // -> "k % length" removes the abs(k) > n edge case
        // -> "(length + k % length)" deals with the k < 0 edge case
        // -> if k > 0 the final "% length" removes the k > n edge case
        let length = array.count
        let rotations = (length + k % length) % length

        // 1. Reverse the whole array
        let reversed: Array = array.reversed()

        // 2. Reverse first k numbers
        let leftPart: Array = reversed[0..<rotations].reversed()

        // 3. Reverse last n-k numbers
        let rightPart: Array = reversed[rotations..<length].reversed()

        array = leftPart + rightPart
    }
}
