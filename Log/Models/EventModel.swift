//
//  Event.swift
//  Log
//
//  Created by Mike Wong on 2023/7/9.
//

import Foundation
import SwiftUI

struct TagModel: Codable, Identifiable {
    let id = UUID().description
    let text:String
    let textColor:String
    let backgroundColor:String
    init(text: String, textColor: String, backgroundColor: String) {
        self.text = text
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        self.textColor = try container.decode(String.self, forKey: .textColor)
        self.backgroundColor = try container.decode(String.self, forKey: .backgroundColor)
    }

}

struct EventModel: Codable, Identifiable {
    let id:String
    let tagId:String
    let title:String
    let detail:String
    let begin:Date
    let end:Date
    init(id:String, tagId:String, title:String, detail:String, begin:Date, end:Date) {
        self.id = id
        self.tagId = tagId
        self.title = title
        self.detail = detail
        self.begin = begin
        self.end = end
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.tagId = try container.decode(String.self, forKey: .tagId)
        self.title = try container.decode(String.self, forKey: .title)
        self.detail = try container.decode(String.self, forKey: .detail)
        self.begin = try container.decode(Date.self, forKey: .begin)
        self.end = try container.decode(Date.self, forKey: .end)
    }
}
