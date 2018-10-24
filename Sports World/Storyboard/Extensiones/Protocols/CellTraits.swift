//
//  CellTraits.swift
//  SW_etapa_IV
//
//  Created by Mario Canto on 7/27/18.
//  Copyright © 2018 Aldo Gutierrez Montoya. All rights reserved.
//

import UIKit

protocol EventDescriptionPresentable {
    var titleLabel: UILabel! { get }
    var subtitleLabel: UILabel! { get }
    func setTitle(_ title: String?)
    func setSubtitle(_ subtitle: String?)
}

extension EventDescriptionPresentable {
    
    func setTitle(_ title: String?) {
        titleLabel.text = title
    }
    
    func setSubtitle(_ subtitle: String?) {
        subtitleLabel.text = subtitle
    }
}

protocol EventDatePresentable {
    var dateLabel: UILabel! { get }
    var dayLabel: UILabel! { get }
    func setDate(_ date: String?)
    func setDay(_ day: String?)
}

extension EventDatePresentable {
    func setDate(_ date: String?) {
        dateLabel.text = date
    }
    
    func setDay(_ day: String?) {
        dayLabel.text = day
    }
}

protocol EventRatingPresentable {
    var ratingStars: [UIImageView] { get }
    func setRating(_ rating: Int)
}

extension EventRatingPresentable {
    func setRating(_ rating: Int) {
        zip(ratingStars.enumerated().map({ $0.offset >= rating }), ratingStars)
            .forEach({
                $0.1.isHidden = $0.0
            })
    }
}

protocol EventSubscriptionsPresentable {
    var subscriptionsLabel: UILabel! { get }
    func setSubscriptions(_ subscriptions: String?)
}

extension EventSubscriptionsPresentable {
    func setSubscriptions(_ subscriptions: String?) {
        subscriptionsLabel.text = subscriptions
    }
}


protocol HorizontalScrollPresentable {
    var collectionView: UICollectionView! { get }
}

protocol RoutineImageCellPresentable {
    var pictureView: UIImageView! { get }
    func setImage(_ image: UIImage?)
}

extension RoutineImageCellPresentable {
    func setImage(_ image: UIImage?) {
        pictureView.image = image
    }
}

protocol TitleRoutineCellPresentable {
    var titleLabel: UILabel! { get }
    func setTitle(_ title: String?)
}

extension TitleRoutineCellPresentable {
    func setTitle(_ title: String?) {
        titleLabel.text = title
    }
}
