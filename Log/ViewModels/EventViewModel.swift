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
    
    @Published var tags:[TagModel] = [] {
        didSet {
            saveTags()
        }
    }
    @Published var events:[EventModel] = [] {
        didSet {
            saveEvents()
        }
    }
    
    init() {
        getEvents()
        getTags()
    }
    
    func addEvent(title:String, detail:String, tagId:String, begin:Date, end:Date) {
        let model = EventModel(id: UUID().description, tagId: tagId, title: title, detail: detail, begin: begin, end: end)
        events.append(model)
        
    }
    
    func deleteEvent(by id:String) {
        events.removeAll { event in
            return event.id == id
        }
    }
    
    func moveEvent(indexSet: IndexSet, offset: Int) {
        events.move(fromOffsets: indexSet, toOffset: offset)
    }
    
    func addTag(title: String, textColor: Color, backgroundColor: Color) {
        let tag = TagModel(text: title, textColor: textColor.hexString(), backgroundColor: backgroundColor.hexString())
        tags.append(tag)
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
    
    public func getDayEvents(date: Date) -> [EventModel] {
        let localFormatter = DateFormatter()
        localFormatter.locale = Locale(identifier: "zh_CN")
        localFormatter.dateStyle = DateFormatter.Style.medium
        localFormatter.timeStyle = DateFormatter.Style.medium
        let dateStr = localFormatter.string(from: date)
        
        var resultEvents:[EventModel] = []
        let dayStr = dateStr.components(separatedBy: " ").first!
        if let dayBegin = localFormatter.date(from: "\(dayStr) 00:00:00") {
            if let dayEnd = Calendar.current.date(byAdding: .day, value: 1, to: dayBegin) {
                resultEvents = events.filter { model in
                    let isInTheDay = model.begin >= dayBegin && model.begin < dayEnd
                    print("mike wong: isInThe day")
                    return isInTheDay
                }
            }
        }
        return resultEvents
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
    
    private func saveTags() {
        if let encodeData = try? JSONEncoder().encode(tags) {
            UserDefaults().setValue(encodeData, forKey: tagCacheKey)
        }
    }
    
    private func saveEvents() {
        if let encodedData = try? JSONEncoder().encode(events) {
            UserDefaults().setValue(encodedData, forKey: eventCacheKey)
        }
    }
    
}
