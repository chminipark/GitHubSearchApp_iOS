//
//  FavoriteRepoViewController.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/13.
//

import UIKit
import RxSwift
import RxDataSources
import SafariServices

class FavoriteRepoViewController: UIViewController, UIScrollViewDelegate, UIViewControllerTransitioningDelegate {
    let disposeBag = DisposeBag()
    var dataSource: RxTableViewSectionedReloadDataSource<MySection>!
    let favoriteRepoViewModel = FavoriteRepoViewModel()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(RepoTableViewCell.self, forCellReuseIdentifier: RepoTableViewCell.cellId)
        tableView.separatorInset = .zero
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        configureUI()
        setupTableView()
        bindToViewModel()
        
        favoriteRepoViewModel.fetchRequest.onNext(())
        
//        let repo = Repository(name: "test",
//                              description: "steste",
//                              starCount: 12323,
//                              urlString: "https://github.com/ReactiveX/RxSwift")
//        CoreDataManager.shared.saveRepo(repo)
//            .delay(.seconds(4), scheduler: MainScheduler.instance)
//            .subscribe(with: self, onNext: { (owner, _) in
//                owner.favoriteRepoViewModel.fetchRequest.onNext(())
//            })
//            .disposed(by: disposeBag)
    }
    
    func configureUI() {
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }
    
    func setupTableView() {
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        let configureCell: (TableViewSectionedDataSource<MySection>,
                            UITableView,
                            IndexPath,
                            Repository) -> RepoTableViewCell
        = { dataSource, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RepoTableViewCell.cellId,
                                                           for: indexPath) as? RepoTableViewCell
            else {
                return RepoTableViewCell()
            }
            
            cell.bind(repository: item)
            
            cell.starButton.buttonAction = { isTap in
                if isTap {
                    print("tap, tap")
                    print(item.name)
                } else {
                    print("not tap")
                    print(item.name)
                }
            }
            
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
        let input = FavoriteRepoViewModel.Input()
        let output = favoriteRepoViewModel.transform(input: input, disposeBag: disposeBag)
        
        output.$repoList
            .bind(to: tableView.rx.items(dataSource: dataSource))
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
}

extension FavoriteRepoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
