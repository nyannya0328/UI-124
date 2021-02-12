//
//  UI_124App.swift
//  UI-124
//
//  Created by にゃんにゃん丸 on 2021/02/12.
//

import SwiftUI

@main
struct UI_124App: App {
    @StateObject var model = HomeViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
