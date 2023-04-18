//
//  Query.swift
//  WordBank
//
//  Created by Talaxy on 2023/4/18.
//

import Foundation
import Combine
import UIKit

class Query: ObservableObject {
    @Published public var isPopuped = false
    @Published public var word: String?
    
    func show(word: String) {
        if UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: word) {
            self.word = word
            self.isPopuped = true
        }
    }
    
    func close() {
        self.word = nil
        self.isPopuped = false
    }
}
