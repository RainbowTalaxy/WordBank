//
//  WordBookForm.swift
//  WordBank
//
//  Created by Talaxy on 2023/4/12.
//

import SwiftUI

struct WordBookForm: View {
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @FocusState private var focues
    
    let book: Book?
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $title)
                        .focused($focues)
                }
            }
            .navigationTitle("\(book != nil ? "Update" : "New") word book")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Cancel", action: {
                dismiss()
            }), trailing: Button("Add", action: {
                if let book {
                    Storage.updateBook(book: book, title: title)
                } else {
                    Storage.addBook(title: title)
                }
                dismiss()
            }))
        }
        .onAppear {
            title = book?.title ?? ""
            focues = true
        }
    }
}
