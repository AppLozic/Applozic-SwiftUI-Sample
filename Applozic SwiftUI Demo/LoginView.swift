//
//  LoginView.swift
//  Applozic SwiftUI Demo
//
//  Created by Mukesh on 20/01/20.
//  Copyright © 2020 Applozic. All rights reserved.
//

import SwiftUI
import Applozic

struct LoginView: View {

    @Binding var isPresented: Bool

    @State private var userId: String = ""
    @State private var password: String = ""
    @ObservedObject private var keyboard = KeyboardResponder()
    private var chatManager: ALChatManager {
        return ALChatManager(applicationKey: ALChatManager.applicationId as NSString)
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField(
                    "User id (Use a random id for the first time)",
                    text: $userId
                )
                    .autocapitalization(.none)
                    .padding(10)
                    .border(Color.gray, width: 1)

                SecureField("Password", text: $password)
                    .padding(10)
                    .border(Color.gray, width: 1)
                    .padding(.vertical)
                Button("Submit") {
                    self.login()
                }
                .frame(minWidth: nil, maxWidth: .infinity, minHeight: 40)
                .accentColor(.white)
                .background(Color.blue)
            }
            .padding()
            .padding(.bottom, keyboard.currentHeight)
            .edgesIgnoringSafeArea(.bottom)
            .animation(.easeOut(duration: 0.16))
            .navigationBarTitle("Sign in", displayMode: .inline)
        }
        
    }

    func login() {
        let alUser = ALUser()
        alUser.userId = userId
        alUser.password = password
        chatManager.connectUser(alUser) { URLResponse, error in
            if error == nil {
                self.isPresented = false
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isPresented: .constant(false))
    }
}
