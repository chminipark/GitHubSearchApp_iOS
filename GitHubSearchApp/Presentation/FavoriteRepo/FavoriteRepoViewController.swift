//
//  FavoriteRepoViewController.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/13.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SafariServices

/*
 - [x] 기본 스타버튼 : fill
 - [ ] 추가 삭제시 테이블뷰 리로드 x
 - [ ] 테이블뷰 당길때 리로드
 */

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
        firstInitWithData()
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
        = { [weak self] dataSource, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RepoTableViewCell.cellId,
                                                           for: indexPath) as? RepoTableViewCell,
                  let `self` = self
            else {
                return RepoTableViewCell()
            }
            
            cell.bind(repository: item, delegate: self, disposeBag: `self`.disposeBag)
            cell.starButton.isTap = true
            
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
        let viewWillAppear = self.rx.viewWillAppear
        
        let input = FavoriteRepoViewModel.Input(viewWillAppear: viewWillAppear)
        let output = favoriteRepoViewModel.transform(input: input, disposeBag: disposeBag)
        
        output.$repoList
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func firstInitWithData() {
        favoriteRepoViewModel.fetchRequest.onNext(())
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
