//
//  RepoLabels.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/11/04.
//

import UIKit

class RepoLabels: UIView {
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = label.font.withSize(14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }

    func configureView(repository: Repository) {
        nameLabel.text = repository.name
        descriptionLabel.text = repository.description
    }
    
    func setupLayout() {
        self.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor),
            nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
        
        self.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            descriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
