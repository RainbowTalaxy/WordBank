//
//  QueryableWord.swift
//  WordBank
//
//  Created by Talaxy on 2023/4/18.
//

import SwiftUI

struct QueryableWord: View {
    @EnvironmentObject var query: Query
    @State private var isDefinitionVisible = false
    @State private var targetWord = ""
    
    let word: Word
    
    var body: some View {
        if let name = word.name, name.count > 0 {
            HStack(spacing: 5) {
                ForEach(split(phrase: name), id: \.0) { (_, word) in
                    Text(word)
                        .opacity(isFadeWord(word: word) ? 0.5 : 1)
                        .onTapGesture {
                            if !isFadeWord(word: word) {
                                query.show(word: String(word))
                            }
                        }
                }
            }
            .font(.system(size: 18))
        } else {
            Text("N/A")
                .font(.system(size: 18))
        }
    }
    
    func split(phrase: String) -> [(Int, Substring)] {
        let words = phrase.split(separator: " ")
        return Array(zip(words.indices, words))
    }
    
    func isFadeWord(word: any StringProtocol) -> Bool {
        if word.contains(".") {
            return true
        }
        return false
    }
}
