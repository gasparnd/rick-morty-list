//
//  TableCellView.swift
//  RickAndMotyList
//
//  Created by Gaspar Dolcemascolo on 30-12-24.
//

import UIKit
import Kingfisher

class TableCellView: UITableViewCell {
    
    static let reuseID = "ContactCell"
    static let rowHeight: CGFloat = 80
    
    let characterImageView = UIImageView()
    let nameLabel = UILabel()
    let speciesLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TableCellView {
    private func setupUI() {
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        characterImageView.contentMode = .scaleAspectFill
        characterImageView.layer.cornerRadius = 30
        characterImageView.clipsToBounds = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        speciesLabel.translatesAutoresizingMaskIntoConstraints = false
        speciesLabel.font = UIFont.systemFont(ofSize: 14)
        speciesLabel.textColor = .gray
        
        contentView.addSubview(characterImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(speciesLabel)
        
        NSLayoutConstraint.activate([
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            characterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            characterImageView.widthAnchor.constraint(equalToConstant: 60),
            characterImageView.heightAnchor.constraint(equalToConstant: 60),
            
            nameLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            speciesLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 16),
            speciesLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            speciesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with character: Character) {
        
        nameLabel.text = character.name
        speciesLabel.text = character.species
        if let url = URL(string: character.image) {
            characterImageView
                .kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholder"), // Imagen temporal mientras carga
                options: [
                    .transition(.fade(0.2)), // Animación de transición
                    .cacheOriginalImage // Almacena la imagen en caché
                ]
            )
        }
    }
}
