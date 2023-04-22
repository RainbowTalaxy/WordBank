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
    @State private var isAlertVisible = false
    @State private var book: Book?
    @State private var syncList: [BookInfoData]?
    
    var body: some View {
        NavigationView {
            List {
                if let syncList = syncList {
                    Section(header: Text("Sync list")) {
                        ForEach(syncList, id: \.id) { book in
                            HStack {
                                Label {
                                    HStack {
                                        Text(book.title)
                                    }
                                } icon: {
                                    Image(systemName: "arrow.triangle.2.circlepath")
                                }
                            }
                        }
                    }
                }
                
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
                            self.book = books[index]
                            isAlertVisible = true
                        }
                    }
                }
            }
            .navigationTitle("WordBank")
            .toolbar {
                Button {
                    Transfer.getBookList { list in
                        withAnimation {
                            syncList = list.books
                        }
                    }
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                }
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
        .alert("Delete book \"\(book?.title ?? "")\"?", isPresented: $isAlertVisible) {
            Button(role: .destructive) {
                if let book = book {
                    Storage.deleteBook(book: book)
                }
            } label: {
                Text("Delete")
            }
        } message: {
            EmptyView()
        }
        
    }
}
