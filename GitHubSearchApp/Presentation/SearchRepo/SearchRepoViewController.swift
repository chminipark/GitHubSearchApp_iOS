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
import SafariServices

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
        tableView.register(SearchRepoTableViewCell.self, forCellReuseIdentifier: SearchRepoTableViewCell.cellId)
        tableView.separatorInset = .zero
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
                            Repository) -> SearchRepoTableViewCell
        = { dataSource, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchRepoTableViewCell.cellId,
                                                           for: indexPath) as? SearchRepoTableViewCell
            else {
                return SearchRepoTableViewCell()
            }
            
            cell.bind(repository: item)
            return cell
        }
        self.dataSource = .init(configureCell: configureCell)
        
        tableView.rx.modelSelected(Repository.self)
            .withUnretained(self)
            .subscribe(onNext: { (owner, repo) in
                owner.openInSafari(repo.urlString)
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
        
        viewModel.alertRequestLimit
            .subscribe(with: self, onNext: { (owner, _) in
                owner.showRequestLimitAlert()
            })
            .disposed(by: disposeBag)
    }
    
    private func openInSafari(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        let safariVC = SFSafariViewController(url: url)
        safariVC.transitioningDelegate = self
        safariVC.modalPresentationStyle = .pageSheet
        
        present(safariVC, animated: true)
    }
    
    private func showRequestLimitAlert() {
        let alertController = UIAlertController(title: "API Request Limit", message: "10 per miniute, try after 1 minute", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(action)
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
}

extension SearchRepoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchRepoViewController: UIViewControllerTransitioningDelegate {}

extension SearchRepoViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let totalHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        let currentYOffset = scrollView.contentOffset.y
        let remainFromBottom = totalHeight - currentYOffset
        
        if remainFromBottom < frameHeight * 2 && viewModel.viewState == .idle {
            viewModel.pagination.onNext(())
        }
    }
}
