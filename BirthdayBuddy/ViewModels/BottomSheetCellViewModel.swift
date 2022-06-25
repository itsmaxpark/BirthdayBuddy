//
//  AddBirthdayBottomSheetTableViewCellViewModel.swift
//  BirthdayBuddy
//
//  Created by Max Park on 4/4/22.
//

import Foundation
import UIKit

struct BottomSheetCellViewModel {
    
    let text: String
    let fontSize: CGFloat
    let textColor: UIColor
    let image: UIImage?
    
}

enum BottomSheetCellViewModels {
    
    static let viewModels: [BottomSheetCellViewModel] = [
        BottomSheetCellViewModel(
            text: "Add Birthday",
            fontSize: 20,
            textColor: UIColor.label,
            image: UIImage(systemName: "plus")
        )
    ]
}
