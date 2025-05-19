//
//  RecentBookCell.swift
//  AdvanceProject
//
//  Created by 형윤 on 5/19/25.
//
import UIKit
import SnapKit

class RecentBookCell: UICollectionViewCell {
    static let identifier = "RecentBookCell"

    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageView)

        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.backgroundColor = .orange
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with book: Book) {
        if let url = URL(string: book.thumbnail) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
        }
    }
}
