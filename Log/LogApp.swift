//
//  LogApp.swift
//  Log
//
//  Created by MikeWong on 2023/6/15.
//

import SwiftUI

@main
struct LogApp: App {
    @StateObject var eventViewModel = EventViewModel()
    var body: some Scene {
        WindowGroup {
            Home()
                .environmentObject(eventViewModel)
        }
    }
}
