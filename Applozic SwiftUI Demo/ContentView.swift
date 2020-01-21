//
//  ContentView.swift
//  Applozic SwiftUI Demo
//
//  Created by Mukesh on 20/01/20.
//  Copyright © 2020 Applozic. All rights reserved.
//

import SwiftUI
import Applozic

enum ActiveSheet {
    case login, conversation
}

struct ContentView: View {
    @State private var showingConversation = false
    @State private var showingLogin = false

    var body: some View {
        NavigationView {
            NavigationLink(destination: ConversationView()) {
                Text("Launch chat")
            }
            .navigationBarTitle("Welcome", displayMode: .inline)
            .navigationBarItems(trailing:
                Button("Sign out") {
                    self.onSignOut()
                }
            )
        }
        .onAppear(perform: initialActions)
        .sheet(isPresented: $showingLogin) {
            LoginView(isPresented: self.$showingLogin)
        }
    }

    func initialActions() {
        showingLogin = !ALUserDefaultsHandler.isLoggedIn()
    }

    func onSignOut() {
        ALChatManager.shared.logoutUser()
        showingLogin = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
