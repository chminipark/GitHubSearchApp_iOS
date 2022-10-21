//
//  SearchRepoViewController.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/13.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class SearchRepoViewController: UIViewController, UIScrollViewDelegate {
    let searchRepoViewModel = SearchRepoViewModel()
    let disposeBag = DisposeBag()
    var dataSource: RxTableViewSectionedReloadDataSource<MySection>!
    
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
    
    private func setupSearchBar() {
        navigationItem.searchController = searchBar
    }
    
    private func setupTableView() {
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        let configureCell: (TableViewSectionedDataSource<MySection>,
                            UITableView,
                            IndexPath,
                            TestModel) -> UITableViewCell
        = { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = item.num
            cell.contentConfiguration = content
            cell.separatorInset = .zero
            
            return cell
        }
        self.dataSource = .init(configureCell: configureCell)
    }
    
    private func bindToViewModel() {
        let data = MySection(headerTitle: "test", items: (1...10).map{ TestModel(num: String($0)) })
        Observable.just([data])
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
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
        
//        output.$repoList
//            .bind(to: tableView.rx.items(dataSource: dataSource))
//            .disposed(by: disposeBag)
    }
}

struct TestModel {
    let num: String
}

extension TestModel: IdentifiableType, Equatable {
    var identity: String {
        return num
    }
}

struct MySection {
    var headerTitle: String
    var items: [Item]
}

extension MySection: AnimatableSectionModelType {
    typealias Item = TestModel
    
    var identity: String {
        return headerTitle
    }
    
    init(original: Self, items: [Item]) {
        self = original
        self.items = items
    }
}
