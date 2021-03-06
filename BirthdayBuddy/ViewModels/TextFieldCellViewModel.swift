//
//  TextFieldCellViewModel.swift
//  BirthdayBuddy
//
//  Created by Max Park on 4/8/22.
//

import Foundation

struct TextFieldCellViewModel {
    
    var text: String?
    let placeholder: String
}

enum TextFieldCellViewModels {
    
    static let viewModels: [TextFieldCellViewModel] = [
        TextFieldCellViewModel(text: nil, placeholder: "First Name"),
        TextFieldCellViewModel(text: nil, placeholder: "Last Name"),
    ]
}

