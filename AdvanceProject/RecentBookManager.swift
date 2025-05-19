//
//  RecentBookManager.swift
//  AdvanceProject
//
//  Created by 형윤 on 5/16/25.
//
//
import Foundation

class RecentBookManager {
    static let shared = RecentBookManager()

    private let key = "recentBooks"

    func saveRecentBook(_ book: Book) {
        var list = fetchRecentBooks()

        list.removeAll { $0.title == book.title }

        list.insert(book, at: 0)

        if list.count > 10 {
            list = Array(list.prefix(10))
        }

        if let encoded = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    func fetchRecentBooks() -> [Book] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([Book].self, from: data) else {
            return []
        }
        return decoded
    }

    func clearRecentBooks() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
