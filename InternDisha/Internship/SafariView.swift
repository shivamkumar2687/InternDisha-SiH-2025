//
//  SafariView.swift
//  InternDisha
//
//  Created by AI Assistant on 07/09/25.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let controller = SFSafariViewController(url: url, configuration: config)
        controller.preferredBarTintColor = UIColor.systemBackground
        controller.preferredControlTintColor = UIColor.label
        return controller
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) { }
}


