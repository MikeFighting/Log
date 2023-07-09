//
//  Event.swift
//  Log
//
//  Created by Mike Wong on 2023/7/9.
//

import Foundation
import SwiftUI

struct TagModel {
    let text:String
    let textColor:Color
    let backgroundColor:Color
}

struct EventModel {
    let tag:TagModel
    let title:String
    let detail:String
    let begin:Date
    let end:Date
}
