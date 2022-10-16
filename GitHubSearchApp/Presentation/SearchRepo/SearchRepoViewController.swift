//
//  SearchRepoViewController.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/13.
//

import UIKit

enum MockData {
    static let numberList = (1...20).map { $0 }
}

class SearchRepoViewController: UIViewController {
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        configureUI()
        setupTableView()
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
        self.tableView.dataSource = self
    }
}

extension SearchRepoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MockData.numberList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = "\(MockData.numberList[indexPath.row])"
        cell.contentConfiguration = content
        
        cell.separatorInset = .zero
        return cell
    }
}

