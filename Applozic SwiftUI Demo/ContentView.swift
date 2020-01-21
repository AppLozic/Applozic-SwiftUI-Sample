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

    // Workaround for inactive navigation link iOS 13.3 bug
    // Source: https://stackoverflow.com/a/59291574/3637751
    @State private var destID = 0

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: ConversationList()
                    .onDisappear() { self.destID = self.destID + 1 }
                ) {
                    Text("Launch chat")
                }
                .navigationBarTitle("Welcome", displayMode: .inline)
                .id(destID)
            }
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
