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
    func updateUIViewController(_ uiViewController: ALKConversationListViewController, context: UIViewControllerRepresentableContext<ConversationList>) {
        
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ConversationList>) -> ALKConversationListViewController {
        let picker = ALKConversationListViewController(configuration: ALKConfiguration())
        return picker
    }

    typealias UIViewControllerType = ALKConversationListViewController
}
