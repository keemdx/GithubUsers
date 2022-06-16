//
//  MainTableViewCell.swift
//  GithubUsers
//
//  Created by Dohyun Kim on 2022/06/15.
//

import UIKit
import SnapKit

class MainTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: MainTableViewCell.self)
    
    var thumbnailImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 24
        return view
    }()
    
    var nameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.numberOfLines = 1
        return view
    }()
    
    var followButton: UIButton = {
        let view = UIButton()
        view.setTitle("Follow", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = .systemBlue
        view.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.5).cgColor
        view.layer.borderWidth = 1.2
        view.layer.cornerRadius = 4.0
        view.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        addSubviews()
        makeConstraints()
    }
    
    func setupView(model: UserModel) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let imageURL = URL(string: model.avatarUrl) else {
                return
            }
            let request = URLRequest(url: imageURL)
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.transition(toImage: image)
                    }
                }
            }).resume()
        }
        nameLabel.text = model.login
    }
    
    // 이미지 로딩을 자연스럽게 하도록 Fade-in 효과 설정
    func transition(toImage image: UIImage?) {
        UIView.transition(
            with: self,
            duration: 0.3,
            options: [.transitionCrossDissolve],
            animations: {
                self.thumbnailImageView.image = image
            },
            completion: nil
        )
    }
    
    private func attribute() {
        backgroundColor = .white
        selectionStyle = .none
    }
    
    private func addSubviews() {
        [thumbnailImageView, nameLabel, followButton]
            .forEach { contentView.addSubview($0) }
    }
    
    private func makeConstraints() {
        thumbnailImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(18)
            $0.width.height.equalTo(48)
            $0.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(14)
            $0.trailing.equalTo(followButton.snp.leading).inset(14)
            $0.centerY.equalToSuperview()
        }
        
        followButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(18)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(30)
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init?(coder: NSCoder) is not implemented") }
}
