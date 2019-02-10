//
//  PreferenceItem.swift
//  One Click Order
//
//  Created by Harry Merzin on 2/9/19.
//  Copyright © 2019 Harry Merzin. All rights reserved.
//

import Foundation

enum PreferenceType {
    case input
    case checkbox
    case button
    case label
}

struct PreferenceItem {
    var preferenceType: PreferenceType
    var fieldName: String
    var fieldKey: String
    init(preferenceType: PreferenceType, fieldName: String, fieldKey: String? = nil) {
        self.preferenceType = preferenceType
        self.fieldName = fieldName
        self.fieldKey = fieldKey == nil ? fieldName : fieldKey!
    }
}
