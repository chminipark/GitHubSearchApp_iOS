//
//  StarButton.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/11/04.
//

import UIKit

class StarButton: UIView {
    let starImage = UIImage(systemName: "star")!
    let starFillImage = UIImage(systemName: "star.fill")!
    
    var image: UIImage {
        isTap ? starFillImage : starImage
    }
    
    var isTap: Bool = false {
        didSet {
            starButton.setImage(image, for: .normal)
        }
    }
    
    let starButton: UIButton = {
        let starImage = UIImage(systemName: "star")
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(starImage, for: .normal)
        return button
    }()
    
    let starCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = label.font.withSize(14)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        
        starButton.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
    }
    
    var buttonAction: ((Bool) -> ())?
    
    @objc func touchUpInside() {
        isTap = !isTap
        if let buttonAction = buttonAction {
            buttonAction(isTap)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    func setupLayout() {
        self.addSubview(starButton)
        starButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            starButton.topAnchor.constraint(equalTo: self.topAnchor),
            starButton.leftAnchor.constraint(equalTo: self.leftAnchor),
            starButton.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
        
        self.addSubview(starCountLabel)
        starCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            starCountLabel.topAnchor.constraint(equalTo: starButton.bottomAnchor, constant: 5),
            starCountLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            starCountLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            starCountLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func configureView(repository: Repository) {
        self.starCountLabel.text = String(repository.starCount)
    }
}
