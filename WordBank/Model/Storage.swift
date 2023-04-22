//
//  Storage.swift
//  WordBank
//
//  Created by Talaxy on 2023/4/12.
//

import Foundation
import CoreData

class Storage {
    static public let container = {
        let persistentContainer = NSPersistentContainer(name: "Model")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        return persistentContainer
    }()
    
    static func addBook(title: String) {
        let book = Book(context: container.viewContext)
        book.id = UUID()
        book.date = Date()
        book.words = NSOrderedSet()
        book.title = title
        do {
            try container.viewContext.save()
        } catch {
            container.viewContext.delete(book)
            fatalError("Add book failed")
        }
    }
    
    static func updateBook(book: Book, title: String) {
        book.title = title
        do {
            try container.viewContext.save()
        } catch {
            container.viewContext.delete(book)
            fatalError("Update book failed")
        }
    }
    
    static func deleteBook(book: Book) {
        container.viewContext.delete(book)
        do {
            try container.viewContext.save()
        } catch {
            fatalError("Delete book failed")
        }
    }
    
    static func addWord(to book: Book, name: String, partOfSpeech: String, definition: String) {
        let word = Word(context: container.viewContext)
        word.id = UUID()
        word.date = Date()
        word.lastUpdate = Date()
        word.name = name
        word.partOfSpeech = partOfSpeech
        word.definition = definition
        book.addToWords(word)
        do {
            try container.viewContext.save()
        } catch {
            container.viewContext.delete(word)
            fatalError("Add word failed \(error)")
        }
    }
    
    static func updateWord(book: Book, word replacedWord: Word, name: String, partOfSpeech: String, definition: String) {
        let word = Word(context: container.viewContext)
        word.id = replacedWord.id
        word.date = replacedWord.date
        word.lastUpdate = Date()
        word.name = name
        word.partOfSpeech = partOfSpeech
        word.definition = definition
        var index = 0
        for word in book.words! {
            if (word as! Word).id == replacedWord.id {
                break
            }
            index += 1
        }
        if index != book.words!.count {
            book.replaceWords(at: index, with: word)
        }
        do {
            try container.viewContext.save()
        } catch {
            fatalError("Update word failed \(error)")
        }
    }
    
    static func deleteWord(word: Word, from book: Book) {
        book.removeFromWords(word)
        container.viewContext.delete(word)
        do {
            try container.viewContext.save()
        } catch {
            fatalError("Delete word failed")
        }
    }
}
