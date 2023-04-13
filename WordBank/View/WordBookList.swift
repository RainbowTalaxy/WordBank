//
//  WordBookList.swift
//  WordBank
//
//  Created by Talaxy on 2023/4/12.
//

import SwiftUI

struct WordBookList: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Book.date, ascending: false)])
    var books: FetchedResults<Book>
    
    @State private var isFormVisible = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Books")) {
                    ForEach(books) { book in
                        NavigationLink {
                            WordList(book: book)
                        } label: {
                            HStack {
                                Label {
                                    HStack {
                                        Text(book.title ?? "Untitled")
                                    }
                                } icon: {
                                    Image(systemName: "text.book.closed")
                                }
                            }
                        }
                    }
                    .onDelete { indexes in
                        for index in indexes {
                            Storage.deleteBook(book: books[index])
                        }
                    }
                }
            }
            .navigationTitle("WordBank")
            .toolbar {
                Button {
                    isFormVisible = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isFormVisible) {
            WordBookForm()
        }
    }
}
