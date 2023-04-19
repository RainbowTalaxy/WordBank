//
//  JSONData.swift
//  WordBank
//
//  Created by Talaxy on 2023/4/19.
//

import Foundation

struct WordData: Codable {
    let id: UUID
    let date: Date
    let name: String
    let part: String
    let def: String
    
    init(from word: Word) {
        self.id = word.id!
        self.date = word.date ?? Date()
        self.name = word.name ?? ""
        self.part = word.partOfSpeech ?? ""
        self.def = word.definition ?? ""
    }
}

struct BookData: Codable {
    let id: UUID
    let date: Date
    let title: String
    let words: [WordData]
    
    init(from book: Book) {
        self.id = book.id!
        self.date = book.date ?? Date()
        self.title = book.title ?? ""
        self.words = book.words?.array.map({ word in
            WordData(from: word as! Word)
        }) ?? []
    }
}

struct UploadBookData: Codable {
    let userId: String
    let book: BookData
    
    init(from book: Book, userId: String) {
        self.userId = userId
        self.book = BookData(from: book)
    }
}
