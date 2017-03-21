//
//  ALWheelCollectionViewFlowLayout.h
//  wheelCollectionView
//
//  Created by Ash Li on 2017/3/6.
//  Copyright © 2017年 ashli. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEFAULT_RADIUS (1400 * CGRectGetWidth([UIScreen mainScreen].bounds) / 375.f)
#define DEFAULT_MINSCALE 0.5

@interface ALWheelCollectionViewFlowLayout : UICollectionViewFlowLayout

@end

@protocol ALWheelCollectionViewFlowLayoutDelegate <UICollectionViewDelegateFlowLayout>

- (CGFloat)radiusOfcollectionView:(UICollectionView *)collectionView layout:(ALWheelCollectionViewFlowLayout*)collectionViewLayout;

- (CGFloat)minScaleOfcollectionView:(UICollectionView *)collectionView layout:(ALWheelCollectionViewFlowLayout*)collectionViewLayout;//(0,1]
@end
