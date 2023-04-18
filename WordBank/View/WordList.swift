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
                ForEach(words) { word in
                    HStack {
                        QueryableWord(word: word)
                        Spacer()
                        Text(partOfSpeech(word: word))
                            .foregroundColor(.secondary)
                            .font(.custom("Georgia", size: 14))
                            .italic()
                        Text(word.definition ?? "")
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
                    isFormVisible = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        })
        .sheet(isPresented: $isFormVisible) {
            WordForm(book: book, word: nil)
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
    }
}
