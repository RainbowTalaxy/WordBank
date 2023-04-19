//
//  Transfer.swift
//  WordBank
//
//  Created by Talaxy on 2023/4/19.
//

import Foundation

class Transfer {
    static let baseUrl = "https://blog.talaxy.cn/public-api/word-bank"
    
    static func upload(book: Book, onSuccess: @escaping () -> Void = {}, onError: @escaping () -> Void = {}) {
        do {
            let encoder = JSONEncoder()
            let json = try encoder.encode(UploadBookData(from: book, userId: "test"))
            let url = URL(string: "\(baseUrl)/books")
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
                let statusMessage = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                print("Status code: \(statusCode)")
                print("Status message: \(statusMessage)")
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
}
