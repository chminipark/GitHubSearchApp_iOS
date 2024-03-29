//
//  StarButton.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/11/04.
//

import UIKit
import RxSwift

class StarButton: UIView {
  let starImage = UIImage(systemName: "star")!
  let starFillImage = UIImage(systemName: "star.fill")!
  
  var delegate: UIViewController?
  var repository: Repository?
  var disposeBag: DisposeBag?
  
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
  
  @objc func touchUpInside() {
    guard let repository = repository,
          let delegate = delegate,
          let disposeBag = disposeBag
    else {
      print("😡😡😡😡😡 starButton init fail...")
      return
    }
    
    buttonAction(buttonState: isTap,
                 repository: repository,
                 delegate: delegate,
                 disposeBag: disposeBag)
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
  
  func configureView(repository: Repository, delegate: UIViewController, disposeBag: DisposeBag) {
    self.isTap = repository.isStore
    self.starCountLabel.text = String(repository.starCount)
    self.repository = repository
    self.delegate = delegate
    self.disposeBag = disposeBag
  }
}

extension StarButton {
  func buttonAction(buttonState: Bool,
                    repository: Repository,
                    delegate: UIViewController,
                    disposeBag: DisposeBag) {
    if buttonState {
      CoreDataManager.shared.deleteRepo(repo: repository)
        .subscribe(with: self, onNext: { (owner, result) in
          switch result {
          case .success:
            owner.isTap = !owner.isTap
            owner.showDeleteAlert(delegate: delegate)
          case .failure(let error):
            print(error.description)
          }
        })
        .disposed(by: disposeBag)
    } else {
      CoreDataManager.shared.saveRepo(repository)
        .subscribe(with: self, onNext: { (owner, result) in
          switch result {
          case .success:
            owner.isTap = !owner.isTap
            owner.showSaveAlert(delegate: delegate)
          case .failure(let error):
            print(error.description)
          }
        })
        .disposed(by: disposeBag)
    }
  }
  
  func showSaveAlert(delegate self: UIViewController) {
    let alertController = UIAlertController(title: "즐겨찾기 추가!",
                                            message: nil,
                                            preferredStyle: .alert)
    let action = UIAlertAction(title: "확인", style: .default)
    alertController.addAction(action)
    DispatchQueue.main.async {
      self.present(alertController, animated: true)
    }
  }
  
  func showDeleteAlert(delegate self: UIViewController) {
    let alertController = UIAlertController(title: "즐겨찾기 삭제!",
                                            message: nil,
                                            preferredStyle: .alert)
    let action = UIAlertAction(title: "확인", style: .default)
    alertController.addAction(action)
    DispatchQueue.main.async {
      self.present(alertController, animated: true)
    }
  }
}
