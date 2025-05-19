//
//  MainTabBarController.swift
//  AdvanceProject
//
//  Created by 형윤 on 5/13/25.
//
import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 검색화면을 네비게이션 컨트롤러로 감싾 ㅜ 아이템 설정
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        searchVC.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)

        // 담은 책 화면 추가 후 아이템 설정
        let savedVC = SavedBooksViewController()
        savedVC.tabBarItem = UITabBarItem(title: "담은 책", image: UIImage(systemName: "book"), tag: 1)

        viewControllers = [searchVC, savedVC]
    }
}
