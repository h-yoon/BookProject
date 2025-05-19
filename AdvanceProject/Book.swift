//
//  Book.swift
//  AdvanceProject
//
//  Created by 형윤 on 5/14/25.
//
import Foundation

struct Book: Codable {
    let title: String
    let authors: [String]
    let price: Int
    let thumbnail: String
    let contents: String
    let publisher: String
}

struct BookResponse: Codable {
    let documents: [Book]
}
