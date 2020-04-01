//
//  ImagePicker.swift
//  Applozic SwiftUI Demo
//
//  Created by Mukesh on 20/01/20.
//  Copyright © 2020 Applozic. All rights reserved.
//

import Foundation
import SwiftUI
import ApplozicSwift

struct ConversationList: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: ALKBaseNavigationViewController, context: UIViewControllerRepresentableContext<ConversationList>) {
        
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ConversationList>) -> ALKBaseNavigationViewController {
        // Pass receiver's user Id
        let receiverUserId = ""
        assert(!receiverUserId.isEmpty, "Pass receiver's user Id")

        let conversationViewController = conversationVC(contactId: receiverUserId, configuration: ALKConfiguration())
        let navigationController = ALKBaseNavigationViewController(rootViewController: conversationViewController)
        return navigationController
    }

    typealias UIViewControllerType = ALKBaseNavigationViewController
}

struct ConversationView: View {

    var body: some View {
        ConversationList()
            .edgesIgnoringSafeArea(.all)
    }
}

struct ConversationView_Preview: PreviewProvider {
    static var previews: some View {
        ConversationView()
    }
}

func conversationVC(
    contactId: String,
    configuration: ALKConfiguration
) -> ALKConversationViewController {
    let convViewModel = ALKConversationViewModel(contactId: contactId, channelKey: nil, localizedStringFileName: configuration.localizedStringFileName)
    let conversationViewController = ALKConversationViewController(configuration: configuration)
    conversationViewController.viewModel = convViewModel
    return conversationViewController
}
