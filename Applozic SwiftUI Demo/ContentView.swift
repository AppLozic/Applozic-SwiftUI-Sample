//
//  ContentView.swift
//  Applozic SwiftUI Demo
//
//  Created by Mukesh on 20/01/20.
//  Copyright © 2020 Applozic. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var showingConversation = false

    var body: some View {
        VStack {
            Text("Welcome")
            Button("Launch Chat") {
                self.showingConversation = true
            }
                .padding(.top, 50)
        }
        .sheet(isPresented: $showingConversation) {
            ConversationList()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
