//
//  ProjectTableViewCell+Repo.swift
//  NewWayChallenge
//
//  Created by Luiz SSB on 4/25/18.
//  Copyright © 2018 luizssb. All rights reserved.
//

import Foundation
import SDWebImage

extension ProjectTableViewCell {
    private static let placeholderAvatar = UIImage(named: "placeholderAvatar")
    
    func set(repository: Repository) {
        repositoryLabel.text = repository.name
        descriptionLabel.text = repository.repoDescription
        forksLabel.text = String(repository.forksCount)
        starsLabel.text = String(repository.stargazersCount)
        
        ownerUsernameLabel.text = repository.owner?.login
        
        // luizssb: users' real names are not available thorugh the web API.
        ownerRealNameLabel.text = repository.owner?.type
        
        ownerImageView.sd_setImage(
            with: repository.owner?.avatarURL,
            placeholderImage: ProjectTableViewCell.placeholderAvatar,
            completed: nil
        )
    }
}
