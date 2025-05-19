//
//  CoreDtaManager.swift
//  AdvanceProject
//
//  Created by 형윤 on 5/15/25.
//
import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func save(book: Book) {
        let entity = BookEntity(context: context)
        entity.title = book.title
        entity.authors = book.authors.joined(separator: ", ")
        entity.price = Int64(book.price)
        entity.thumbnail = book.thumbnail
        entity.contents = book.contents
        entity.publisher = book.publisher

        do {
            try context.save()
        } catch {
            print("❌ 저장 실패: \(error)")
        }
    }

    func fetchBooks() -> [BookEntity] {
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("❌ 불러오기 실패: \(error)")
            return []
        }
    }

    func deleteAllBooks() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = BookEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("❌ 전체 삭제 실패: \(error)")
        }
    }
}
