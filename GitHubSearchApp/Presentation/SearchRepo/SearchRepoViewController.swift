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
    let disposeBag = DisposeBag()
    var dataSource: RxTableViewSectionedReloadDataSource<MySection>!
    let viewModel = SearchRepoViewModel()
    
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
                            Repository) -> UITableViewCell
        = { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = item.name
            content.secondaryText = item.description
            let image = UIImage(systemName: "star.fill")
            cell.accessoryView = UIImageView(image: image)
            
            cell.contentConfiguration = content
            cell.separatorInset = .zero
            
            return cell
        }
        self.dataSource = .init(configureCell: configureCell)
        
        tableView.rx.modelSelected(Repository.self)
            .subscribe(onNext: { repo in
                print(repo.name)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindToViewModel() {
        let searchBarText = searchBar.searchBar.rx.text.orEmpty.asObservable()
        
        let input = SearchRepoViewModel.Input(searchBarText: searchBarText)
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.$searchBarText
            .subscribe(onNext: { text in
                print(text)
            })
            .disposed(by: disposeBag)
        
        output.$repoList
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
//    guard let url = URL(string: "https://www.naver.com") else { return }
//    let safariVC = SFSafariViewController(url: url)
//    // 🔥 delegate 지정 및 presentation style 설정.
//    safariVC.transitioningDelegate = self
//    safariVC.modalPresentationStyle = .pageSheet
//
//    present(safariVC, animated: true, completion: nil)
    
    
}

extension SearchRepoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchRepoViewController: UIViewControllerTransitioningDelegate {}
