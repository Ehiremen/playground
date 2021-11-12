//
//  StatusDetails.swift
//  ToDoList
//
//  Created by Ehiremen Ekore on 10/31/21.
//

import Foundation
import SwiftUI

struct Status {
    let name: String
    let color: Color
}

struct Utils {
    static let statusDict: [String:Status] = [
        "ns": Status(name: "not started", color: .gray),
        "ip": Status(name: "in progress", color: .blue),
        "co": Status(name: "completed", color: .green),
        "gu": Status(name: "given up", color: .red)
    ]
    
    
    static let longDateShortTime: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .long
        df.timeStyle = .short
        df.locale = Locale.autoupdatingCurrent
        return df
    }()
    
    static let shortDateShortTime: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        df.locale = Locale.autoupdatingCurrent
        
        return df
    }()
}
