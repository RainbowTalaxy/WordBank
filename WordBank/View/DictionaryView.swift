//
//  DictionaryView.swift
//  WordBank
//
//  Created by Talaxy on 2023/4/18.
//

import SwiftUI

struct DictionaryView: UIViewControllerRepresentable {
    let word: String

    func makeUIViewController(context: UIViewControllerRepresentableContext<DictionaryView>) -> UIReferenceLibraryViewController {
        return UIReferenceLibraryViewController(term: word)
    }

    func updateUIViewController(_ uiViewController: UIReferenceLibraryViewController, context: UIViewControllerRepresentableContext<DictionaryView>) {
    }
}
