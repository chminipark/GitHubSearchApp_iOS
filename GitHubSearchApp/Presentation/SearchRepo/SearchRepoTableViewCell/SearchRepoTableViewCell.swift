//
//  SearchRepoTableViewCell.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/11/01.
//

import UIKit

class SearchRepoTableViewCell: UITableViewCell {
    static let cellId = String(describing: SearchRepoTableViewCell.self)
    let padding: CGFloat = 10
    
    let containerView = UIView()
    let repoLabels = RepoLabels()
    let starButton = StarButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        self.contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: padding),
            containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -padding),
            containerView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: padding*2),
            containerView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -(padding))
        ])
        
        containerView.addSubview(repoLabels)
        repoLabels.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            repoLabels.topAnchor.constraint(equalTo: containerView.topAnchor),
            repoLabels.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            repoLabels.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            repoLabels.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.8)
        ])
        
        containerView.addSubview(starButton)
        starButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            starButton.leftAnchor.constraint(equalTo: repoLabels.rightAnchor),
            starButton.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            starButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    func bind(repository: Repository) {
        self.repoLabels.configureView(repository: repository)
        self.starButton.configureView(repository: repository)
    }
}
