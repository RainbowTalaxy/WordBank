//
//  WordList.swift
//  WordBank
//
//  Created by Talaxy on 2023/4/12.
//

import SwiftUI

struct WordList: View {
    @FetchRequest var words: FetchedResults<Word>
    @EnvironmentObject var query: Query
    @State private var isFormVisible = false
    @State private var isBookFormVisible = false
    @State private var isSyncAlertVisible = false
    @State private var isDeleteAlertVisible = false
    @State private var isSync = false
    @State private var isEditable = false
    @State private var targetWord: Word? = nil
    @State private var deleteWord: Word? = nil
    let book: Book
    
    init(book: Book) {
        self.book = book
        _words = FetchRequest(entity: Word.entity(),  sortDescriptors: [
            NSSortDescriptor(keyPath: \Word.date, ascending: true)
        ],predicate: NSPredicate(format: "book == %@", book))
    }
    
    func partOfSpeech(word: Word) -> String {
        let needTrailingDot = !(word.partOfSpeech?.hasSuffix(".") ?? false) && word.partOfSpeech?.count ?? 0 > 0
        return (word.partOfSpeech ?? "") + (needTrailingDot ? "." : "")
    }
    
    var body: some View {
        ZStack {
            List {
                Section {
                    Toggle("Edit", isOn: $isEditable)
                }
                
                Section {
                    ForEach(words) { word in
                        HStack(spacing: 20) {
                            QueryableWord(word: word)
                            Spacer()
                            HStack {
                                Text(partOfSpeech(word: word))
                                    .foregroundColor(.secondary)
                                    .font(.custom("Georgia", size: 14))
                                    .italic()
                                Text(word.definition ?? "")
                            }
                            if isEditable {
                                Image(systemName: "square.and.pencil")
                                    .foregroundColor(.blue)
                                    .onTapGesture {
                                        targetWord = word
                                    }

                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                                    .onTapGesture {
                                        deleteWord = word
                                    }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(book.title ?? "Untitled")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            HStack {
                Button {
                    isBookFormVisible = true
                } label: {
                    Image(systemName: "pencil")
                }
                Button {
                    isSync = true
                    Transfer.upload(book: book) {
                        withAnimation {
                            isSync = false
                        }
                    } onError: {
                        isSync = false
                        isSyncAlertVisible = true
                    }
                } label: {
                    Image(systemName: "paperplane")
                }
                .disabled(isSync)
                Button {
                    isFormVisible = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        })
        .sheet(isPresented: $isFormVisible, onDismiss: {
            isFormVisible = false
            targetWord = nil
        }) {
            WordForm(book: book, word: targetWord)
        }
        .sheet(isPresented: $isBookFormVisible) {
            WordBookForm(book: book)
        }
        .sheet(isPresented: $query.isPopuped, onDismiss: {
            query.close()
        }) {
            NavigationView {
                DictionaryView(word: query.word ?? "NULL")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .alert("Failed to sync", isPresented: $isSyncAlertVisible) {}
        .alert("Delete word \"\(targetWord?.name ?? "")\"?", isPresented: $isDeleteAlertVisible) {
            Button(role: .destructive) {
                if let word = targetWord {
                    Storage.deleteWord(word: word, from: book)
                }
            } label: {
                Text("Delete")
            }
        } message: {
            EmptyView()
        }
        .onChange(of: targetWord) { newValue in
            if newValue != nil {
                isFormVisible = true
            }
        }
        .onChange(of: deleteWord) { newValue in
            if newValue != nil {
                isDeleteAlertVisible = true
            }
        }
        .onChange(of: isDeleteAlertVisible) { newValue in
            if !newValue {
                deleteWord = nil
            }
        }
    }
}
