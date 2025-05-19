//
//  BookDetailViewController.swift
//  AdvanceProject
//
//  Created by 형윤 on 5/13/25.
//
import UIKit
import SnapKit

class BookDetailViewController: UIViewController {

    var book: Book?
    var onSave: (() -> Void)?
    
    let scrollView = UIScrollView()
    let contentView = UIStackView()

    let thumbnailImageView = UIImageView()
    let titleLabel = UILabel()
    let authorLabel = UILabel()
    let priceLabel = UILabel()
    let contentsLabel = UILabel()

    let dismissButton = UIButton()
    let saveButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupViews()
        setupConstraints()
        displayBookInfo()
    }

    private func setupViews() {
        contentView.axis = .vertical
        contentView.spacing = 16

        titleLabel.font = .boldSystemFont(ofSize: 22)
        authorLabel.textColor = .darkGray
        priceLabel.font = .systemFont(ofSize: 18)
        contentsLabel.numberOfLines = 0
        contentsLabel.font = .systemFont(ofSize: 14)

        contentView.addArrangedSubview(thumbnailImageView)
        contentView.addArrangedSubview(titleLabel)
        contentView.addArrangedSubview(authorLabel)
        contentView.addArrangedSubview(priceLabel)
        contentView.addArrangedSubview(contentsLabel)

        scrollView.addSubview(contentView)
        view.addSubview(scrollView)

        dismissButton.setTitle("✕", for: .normal)
        dismissButton.setTitleColor(.black, for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)

        saveButton.setTitle("담기", for: .normal)
        saveButton.backgroundColor = .systemGreen
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 8
        saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)

        view.addSubview(dismissButton)
        view.addSubview(saveButton)
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(saveButton.snp.top).offset(-10)
        }

        contentView.snp.makeConstraints {
            $0.top.bottom.equalTo(scrollView.contentLayoutGuide).inset(20)
            $0.leading.trailing.equalTo(scrollView.frameLayoutGuide).inset(20)
        }

        thumbnailImageView.snp.makeConstraints {
            $0.height.equalTo(200)
        }

        saveButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(44)
            $0.width.equalTo(100)
        }

        dismissButton.snp.makeConstraints {
            $0.centerY.equalTo(saveButton)
            $0.leading.equalToSuperview().inset(20)
            $0.height.width.equalTo(44)
        }
    }

    private func displayBookInfo() {
        guard let book = book else { return }
        titleLabel.text = book.title
        authorLabel.text = "저자: \(book.authors.joined(separator: ", "))"
        priceLabel.text = "\(book.price)원"
        contentsLabel.text = book.contents

        if let url = URL(string: book.thumbnail) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.thumbnailImageView.image = image
                        self.thumbnailImageView.contentMode = .scaleAspectFit
                    }
                }
            }
        }
    }

    @objc private func dismissModal() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func didTapSave() {
        guard let book = book else { return }
        RecentBookManager.shared.saveRecentBook(book)
        CoreDataManager.shared.save(book: book)
        
        dismiss(animated: true) { [weak self] in
            print("onsave호출")
            self?.onSave?()
        }
    }
}
