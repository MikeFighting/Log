//
//  EventViewModel.swift
//  Log
//
//  Created by MikeWong on 2023/7/10.
//

import Foundation
import SwiftUI
class EventViewModel: ObservableObject {
    private let eventCacheKey = "log_event_list"
    private let tagCacheKey = "log_tag_list"
    
    @Published var tags:[TagModel] = []
    @Published var events:[EventModel] = [] {
        didSet {
            debugPrint("did set evnets")
        }
    }
    
    init() {
        getEvents()
        getTags()
    }
    
    func addEvent(title:String, detail:String, tagId:String, begin:Date, end:Date) {
        let model = EventModel(id: UUID().description, tagId: tagId, title: title, detail: detail, begin: begin, end: end)
        events.append(model)
        if let encodedData = try? JSONEncoder().encode(events) {
            UserDefaults().setValue(encodedData, forKey: eventCacheKey)
        }
    }
    
    func addTag(title: String, textColor: Color, backgroundColor: Color) {
        let tag = TagModel(text: title, textColor: textColor.hexString(), backgroundColor: backgroundColor.hexString())
        tags.append(tag)
        if let encodeData = try? JSONEncoder().encode(tags) {
            UserDefaults().setValue(encodeData, forKey: tagCacheKey)
        }
    }
    
    func getTag(name: String) -> TagModel {
        if let tag = tags.first(where: {$0.text == name}) {
            return tag
        }
        return TagModel(text: "", textColor: "", backgroundColor: "")
    }
    
    private func getEvents() {
        guard let data:Data = UserDefaults().data(forKey: eventCacheKey),
              let events = try? JSONDecoder().decode([EventModel].self, from: data) else { return }
        self.events = events
    }
    
    private func getTags() {
        guard let data:Data = UserDefaults().data(forKey: tagCacheKey),
              let tags = try? JSONDecoder().decode([TagModel].self, from: data) else {
            addTag(title: "家务", textColor: Color.white, backgroundColor: Color.red)
            addTag(title: "工作", textColor: Color.white, backgroundColor: Color.blue)
            return
        }
        self.tags = tags
    }
    

}
