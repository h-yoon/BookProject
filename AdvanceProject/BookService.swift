//
//  BookService.swift
//  AdvanceProject
//
//  Created by 형윤 on 5/14/25.
//
import Foundation

class BookService {
    static let shared = BookService()
    private init() {}

    private let apiKey = "KakaoAK 3ef57aedd5843370fdcd03a9031c7734"

    func searchBooks(query: String, completion: @escaping ([Book]) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://dapi.kakao.com/v3/search/book?query=\(encodedQuery)") else {
            return
        }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("❌ API 요청 실패: \(error.localizedDescription)")
                return
            }

            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder().decode(BookResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decoded.documents)
                }
            } catch {
                print("❌ 디코딩 오류: \(error)")
            }
        }.resume()
    }
}
