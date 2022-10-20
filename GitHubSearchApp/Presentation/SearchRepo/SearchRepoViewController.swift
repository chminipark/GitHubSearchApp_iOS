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
        let searchBarText = searchBar.searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.milliseconds(1500), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: "")
        
        let input = SearchRepoViewModel.Input(searchBarText: searchBarText)
        let output = searchRepoViewModel.transform(input: input, disposeBag: disposeBag)
        
        output.$searchBarText
            .subscribe(onNext: { text in
                print(text)
            })
            .disposed(by: disposeBag)
        
        output.$repoList
            .subscribe(onNext: { repoList in
                print(repoList.count)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchBar
    }
}
