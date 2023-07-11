//
//  EventViewModel.swift
//  Log
//
//  Created by MikeWong on 2023/7/10.
//

import Foundation
class EventViewModel: ObservableObject {
    private let eventCacheKey = "log_event_list"
    @Published var events:[EventModel] = [] {
        didSet {
            debugPrint("did set evnets")
        }
    }
    init() {
        getEvents()
    }
    
    private func getEvents() {
        guard let data:Data = UserDefaults().data(forKey: eventCacheKey),
              let events = try? JSONDecoder().decode([EventModel].self, from: data) else { return }
        self.events = events
    }
    
    func addEvent(title:String, detail:String, tagId:String, begin:Date, end:Date) {
        let model = EventModel(id: UUID().description, tagId: tagId, title: title, detail: detail, begin: begin, end: end)
        events.append(model)
        if let encodedData = try? JSONEncoder().encode(events) {
            UserDefaults().setValue(encodedData, forKey: eventCacheKey)
        }
    }
}
