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

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your user Id", text: $userId)
                    .frame(height: 40)
                    .border(Color.black, width: 1)
                TextField("Enter your password", text: $password)
                    .frame(height: 40)
                    .border(Color.black, width: 1)
                    .padding(.vertical)
                Button("Submit") {
                    self.login()
                }
                .frame(minWidth: nil, maxWidth: .infinity, minHeight: 40)
                .accentColor(.white)
                .background(Color.blue)


            }
            .padding()
            .navigationBarTitle("Sign in", displayMode: .inline)
        }
        
    }

    func login() {
        let alUser = ALUser()
        alUser.userId = userId
        alUser.password = password
        ALChatManager.shared.connectUser(alUser) { URLResponse, error in
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
