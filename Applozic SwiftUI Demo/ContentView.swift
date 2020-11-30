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
            Button("Launch chat", action: { launchChatList() })
                .navigationBarTitle("Welcome", displayMode: .inline)
                .navigationBarItems(
                    trailing:
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
        ALChatManager.shared.logoutUser { (_) in
            if !UIApplication.shared.isRegisteredForRemoteNotifications {
                UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                    if granted {
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                    DispatchQueue.main.async {
                        showingLogin = true
                    }
                }
            } else {
                showingLogin = true
            }
        }
    }

    func launchChatList()  {
        guard let topVC = UIApplication.topViewController() else { return }
        ALChatManager.shared.launchChatList(from: topVC, with: AppDelegate.config)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension UIApplication {
    class func topViewController(
        base: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
    ) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
