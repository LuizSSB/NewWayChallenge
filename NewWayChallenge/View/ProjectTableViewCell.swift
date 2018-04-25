//
//  ProjectTableViewCell.swift
//  NewWayChallenge
//
//  Created by Luiz SSB on 4/24/18.
//  Copyright © 2018 luizssb. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {
    private static let rowHeight: [UIUserInterfaceSizeClass: CGFloat] = [
        .regular: 127,
        .compact: 106
    ]
    
    @IBOutlet weak var repositoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var watchingLabel: UILabel?
    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var ownerUsernameLabel: UILabel!
    @IBOutlet weak var ownerRealNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ownerImageView.layer.cornerRadius = ownerImageView.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    static func rowHeight(forTraits traits: UITraitCollection) -> CGFloat {
        guard let size = rowHeight[traits.horizontalSizeClass] else {
            return rowHeight[.compact]!
        }
        
        return size
    }
}
