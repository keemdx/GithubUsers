//
//  EmptyBackgroundView.swift
//  GithubUsers
//
//  Created by Dohyun Kim on 2022/06/16.
//

import UIKit
import SnapKit

// 표시할 데이터가 없는 경우 보여줄 뷰
class EmptyBackgroundView: UIView {
    
    var statusLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        view.numberOfLines = 1
        view.text = "📡"
        view.textAlignment = .center
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        backgroundColor = .white
    }
    
    private func addSubviews() {
        addSubview(statusLabel)
    }
    
    private func makeConstraints() {
        statusLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
