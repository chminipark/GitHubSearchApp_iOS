//
//  SearchRepoViewController.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/13.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchRepoViewController: UIViewController {
    let searchRepoViewModel = SearchRepoViewModel()
    
    private let searchBar: UISearchController = {
        let sb = UISearchController()
        sb.searchBar.placeholder = "Enter the GitHub Repository"
        sb.searchBar.searchBarStyle = .minimal
        return sb
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        configureUI()
        setupSearchBar()
        setupTableView()
        bindToViewModel()
    }
    
    private func configureUI() {
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }
    
    let disposeBag = DisposeBag()
    
    private func bindToViewModel() {
        let input = SearchRepoViewModel.Input(searchBarText: searchBar.searchBar.rx.text.orEmpty.asDriver())
        let output = searchRepoViewModel.transform(input, disposeBag: disposeBag)
        
        output.$searchBarText
            .subscribe(onNext: { text in
                print(text)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
//        self.tableView.dataSource = self
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchBar
//        searchBar.searchBar.delegate = self
    }
}

//extension SearchRepoViewController: UISearchBarDelegate {
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        guard let text = searchBar.text else {
//            return
//        }
//        print(text)
//    }
//}
//
//extension SearchRepoViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return numberList.count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        var content = cell.defaultContentConfiguration()
//        content.text = "\(numberList[indexPath.row])"
//        cell.contentConfiguration = content
//
//        cell.separatorInset = .zero
//        return cell
//    }
//}


