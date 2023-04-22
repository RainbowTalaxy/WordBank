//
//  Transfer.swift
//  WordBank
//
//  Created by Talaxy on 2023/4/19.
//

import Foundation

let userId = "test"

class Transfer {
    static let baseUrl = "https://blog.talaxy.cn/public-api/word-bank"
    
    static func upload(book: Book, onSuccess: @escaping () -> Void = {}, onError: @escaping () -> Void = {}) {
        do {
            let encoder = JSONEncoder()
            let json = try encoder.encode(BookData(from: book))
            let url = URL(string: "\(baseUrl)/books/\(userId)")
            let session = URLSession.shared
            var request = URLRequest(url: url!)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = json
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    onError()
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response")
                    onError()
                    return
                }
                let statusCode = httpResponse.statusCode
                if statusCode == 200 {
                    onSuccess()
                } else {
                    onError()
                }
            }
            task.resume()
        } catch {
            print("Error converting entity to JSON: \(error.localizedDescription)")
        }
    }
    
    static func getBookList(onSuccess: @escaping (BookListData) -> Void = {_ in }, onError: @escaping () -> Void = {}) {
        let url = URL(string: "\(baseUrl)/books/\(userId)")
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.dataTask(with: request) { (data, response, error) in
            do {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    onError()
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response")
                    onError()
                    return
                }
                let statusCode = httpResponse.statusCode
                if statusCode == 200, let data = data {
                    let decoder = JSONDecoder()
                    let list = try decoder.decode(BookListData.self, from: data)
                    onSuccess(list)
                } else {
                    onError()
                }
            } catch {
                onError()
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
