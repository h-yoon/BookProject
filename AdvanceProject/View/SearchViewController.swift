//
//  ViewController.swift
//  AdvanceProject
//
//  Created by 형윤 on 5/13/25.
//
import UIKit
import SnapKit

class SearchViewController: UIViewController {

    let searchBar = UISearchBar()
    let recentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    let tableView = UITableView()

    var books: [Book] = []
    var recentBooks: [Book] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "책 검색"

        setupViews()
        setupConstraints()
        setupDelegates()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recentBooks = RecentBookManager.shared.fetchRecentBooks()
        recentCollectionView.reloadData()
    }

    private func setupViews() {
        searchBar.placeholder = "책 제목을 입력하세요"
        view.addSubview(searchBar)
        view.addSubview(recentCollectionView)
        view.addSubview(tableView)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BookCell")
        recentCollectionView.register(RecentBookCell.self, forCellWithReuseIdentifier: RecentBookCell.identifier)
    }

    private func setupConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }

        recentCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(recentCollectionView.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setupDelegates() {
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        recentCollectionView.dataSource = self
        recentCollectionView.delegate = self
    }
}

// MARK: - Search 기능

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text, !keyword.isEmpty else { return }

        BookService.shared.searchBooks(query: keyword) { [weak self] result in
            self?.books = result
            self?.tableView.reloadData()
        }
    }
}

// MARK: - TableView

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath)
        let book = books[indexPath.row]
        cell.textLabel?.text = "\(book.title) - \(book.authors.joined(separator: ", "))"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = books[indexPath.row]
        let vc = BookDetailViewController()
        vc.book = book
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true)
    }
}

// MARK: - CollectionView (최근 본 책)

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recentBooks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentBookCell.identifier, for: indexPath) as! RecentBookCell
        cell.configure(with: recentBooks[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = recentBooks[indexPath.item]
        let vc = BookDetailViewController()
        vc.book = book
        
        vc.onSave = { [weak self] in
            guard let self = self else {return}
            self.recentBooks = RecentBookManager.shared.fetchRecentBooks()
            self.recentCollectionView.reloadData()
        }
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true)
    }
}
