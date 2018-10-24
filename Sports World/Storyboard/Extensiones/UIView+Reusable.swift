//
//  UIView+Reusable.swift
//  Pets
//
//  Created by Mario Canto on 1/31/18.
//  Copyright © 2018 Mario Canto. All rights reserved.
//

import UIKit

extension UIView: Reusable {}
extension UIViewController: Reusable {}

public extension UITableView {
	public func dequeueReusableCell<T>(ofType cellType: T.Type = T.self, at indexPath: IndexPath) -> T where T: UITableViewCell {
		guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseId,
											 for: indexPath) as? T else {
												fatalError()
		}
		return cell
	}
	
	public func dequeueReusableHeaderFooterView<T>(ofType viewType: T.Type = T.self, at section: Int) -> T where T: UITableViewHeaderFooterView {
		guard let view = dequeueReusableHeaderFooterView(withIdentifier: viewType.reuseId) as? T else {
			fatalError()
		}
		return view
	}
	
}

extension UICollectionView {
	public func dequeueReusableCell<T>(ofType cellType: T.Type = T.self, at indexPath: IndexPath) -> T where T: UICollectionViewCell {
		guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.reuseId,
											 for: indexPath) as? T else {
												fatalError()
		}
		
		return cell
	}
	
	public func dequeueReusableSupplementaryView<T>(ofType supplementaryViewType: T.Type = T.self, supplementaryElementOfKind kind: String, at indexPath: IndexPath) -> T where T: UICollectionReusableView {
		guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: supplementaryViewType.reuseId, for: indexPath) as? T else {
			fatalError()
		}
		return view
	}
}


extension UIStoryboard {
    public func makeViewController<T>(ofType type: T.Type = T.self) -> T where T: UIViewController {
        guard let viewController = instantiateViewController(withIdentifier: type.reuseId) as? T else {
            fatalError()
        }
        return viewController
    }
}


public extension UIView {
    
    public class func instantiateFromNib<T: UIView>(_ viewType: T.Type) -> T {
        return Bundle(for: self).loadNibNamed(T.reuseId, owner: nil, options: nil)?.first as! T
    }
    
    public class func instantiateFromNib() -> Self {
        return instantiateFromNib(self)
    }
    
}
