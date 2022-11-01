//
//  SearchRepoTableViewCell.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/11/01.
//

import UIKit

class SearchRepoTableViewCell: UITableViewCell {
    static let cellId = String(describing: SearchRepoTableViewCell.self)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(model: Repository) {
        var content = self.defaultContentConfiguration()
        content.text = model.name
        content.secondaryText = model.description
        let image = UIImage(systemName: "star.fill")
        self.accessoryView = UIImageView(image: image)
        
        self.contentConfiguration = content
        self.separatorInset = .zero
    }
}
