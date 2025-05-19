//
//  SavedBooksViewController.swift
//  AdvanceProject
//
//  Created by 형윤 on 5/13/25.
//
import UIKit
import SnapKit

class SavedBooksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView()
    let deleteAllButton = UIButton()
    var savedBooks: [BookEntity] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "담은 책"

        setupUI()
        setupConstraints()
        loadBooks()
    }

    // 화면이 다시 나타날 때 마다 최신 데이터로 리로드
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBooks()
    }

    //UI
    private func setupUI() {
        deleteAllButton.setTitle("전체 삭제", for: .normal)
        deleteAllButton.setTitleColor(.red, for: .normal)
        deleteAllButton.addTarget(self, action: #selector(deleteAll), for: .touchUpInside)
        view.addSubview(deleteAllButton)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SavedCell")
        view.addSubview(tableView)
    }

    private func setupConstraints() {
        deleteAllButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(30)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(deleteAllButton.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    // coredata 불러오기
    private func loadBooks() {
        savedBooks = CoreDataManager.shared.fetchBooks()
        tableView.reloadData()
    }

    @objc private func deleteAll() {
        CoreDataManager.shared.deleteAllBooks()
        loadBooks()
    }

    // 저장된 책 수만큼 셀 표시
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedBooks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let book = savedBooks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedCell", for: indexPath)
        cell.textLabel?.text = "\(book.title ?? "") - \(book.authors ?? "") - \(book.price)원"
        return cell
    }
}
