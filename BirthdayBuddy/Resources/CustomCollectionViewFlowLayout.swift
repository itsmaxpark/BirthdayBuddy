//
//  CustomCollectionViewFlowLayout.swift
//  BirthdayBuddy
//
//  Created by Max Park on 4/1/22.
//

import Foundation
import UIKit

final class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        // proposedContentOffset is the point where scrolling stops based off the top left of the contentView
        var offsetAdjusment = CGFloat.greatestFiniteMagnitude // greatest finite number that isnt infinity
        let cellWidth: CGFloat = 220
        let leftMargin: CGFloat = 40
        
        let horizontalCenter = proposedContentOffset.x + cellWidth/2 //(collectionView.frame.width/2)//center of contentview
        
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
        
        //Retrieves the layout attributes for all of the cells and views in the specified rectangle.
        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)
        
        layoutAttributesArray?.forEach({ (layoutAttributes) in
            let itemHorizontalCenter = layoutAttributes.center.x // x position of each cell's center
            
            if abs(itemHorizontalCenter - horizontalCenter) < abs(offsetAdjusment) {
                // offsetAdjustment is distance between item center and contentview center
                if abs(velocity.x) < 0.3 { // minimum velocityX to trigger the snapping effect
                    offsetAdjusment = itemHorizontalCenter - horizontalCenter - leftMargin
//                    print("1: \(offsetAdjusment)")
                } else if velocity.x > 0 { // triggered on big swipes to the left
                    offsetAdjusment = itemHorizontalCenter - horizontalCenter + cellWidth
//                    print("2: \(offsetAdjusment)")
                } else { // velocity.x < -0.3 | triggered on small swipes to the right
                    print("velocity: \(velocity.x)")
                    offsetAdjusment = itemHorizontalCenter - horizontalCenter - leftMargin - leftMargin - cellWidth
//                    print("3: \(itemHorizontalCenter) - \(horizontalCenter) - \(layoutAttributes.bounds.width) = \(offsetAdjusment)")
                }
            }
        })
        print()
        return CGPoint(x: proposedContentOffset.x + offsetAdjusment, y: proposedContentOffset.y)
    }
    
    
}
