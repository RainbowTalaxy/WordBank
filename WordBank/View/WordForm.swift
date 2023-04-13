//
//  WordBookForm.swift
//  WordBank
//
//  Created by Talaxy on 2023/4/12.
//

import SwiftUI

struct WordForm: View {
    private enum Field: Int, Hashable {
        case word, part, def
    }
    
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedField: Field?
    @State private var name = ""
    @State private var partOfSpeech = ""
    @State private var definition = ""
    @State private var keepForm = false
    
    let book: Book?
    let word: Word?
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Word or phrase", text: $name)
                        .keyboardType(.alphabet)
                        .focused($focusedField, equals: .word)
                        .disableAutocorrection(true)
                        .onSubmit {
                            focusedField = .part
                        }
                    
                    TextField("Part of speech", text: $partOfSpeech)
                        .keyboardType(.alphabet)
                        .focused($focusedField, equals: .part)
                        .disableAutocorrection(true)
                        .onSubmit {
                            focusedField = .def
                        }
                    
                    TextField("Definition", text: $definition)
                        .focused($focusedField, equals: .def)
                        .disableAutocorrection(true)
                        .onSubmit {
                            submit()
                            if keepForm {
                                name = ""
                                partOfSpeech = ""
                                definition = ""
                                focusedField = .word
                            } else {
                                dismiss()
                            }
                        }
                    
                    Toggle("Keep form", isOn: $keepForm)
                }
            }
            .navigationTitle("\(word != nil ? "Update" : "New") word")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Cancel", action: {
                dismiss()
            }), trailing: Button("Save", action: {
                submit()
                dismiss()
            }))
        }
        .onAppear {
            focusedField = .word
            name = word?.name ?? ""
            partOfSpeech = word?.partOfSpeech ?? ""
            definition = word?.definition ?? ""
        }
    }
    
    func submit() {
        if let book {
            if let word = word {
                
            } else {
                Storage.addWord(
                    to: book,
                    name: name,
                    partOfSpeech: partOfSpeech,
                    definition: definition
                )
            }
        }
    }
}

