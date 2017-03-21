//
//  ALWheelView.h
//  wheelCollectionView
//
//  Created by Ash Li on 2017/3/7.
//  Copyright © 2017年 ashli. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ALWheelViewDirection) {
    ALWheelViewDirectionClockwise,
    ALWheelViewDirectionAnticlockwise,
    ALWheelViewDirectionNono
};

@class ALWheelView;
@protocol ALWheelViewDelegate <NSObject>

- (NSInteger)numberOfItemsInWheel:(ALWheelView*)wheelView;
- (CGFloat)radiusOfWheel:(ALWheelView*)wheelView;
- (CGFloat)minScaleOfItemInWheel:(ALWheelView*)wheelView;
- (CGSize)sizeOfItemInWheel:(ALWheelView*)wheelView atIndex:(NSInteger)index;
- (void)wheelView:(ALWheelView*)wheelView didClickItemAtIndex:(NSInteger)index;
- (UIView*)wheelView:(ALWheelView*)wheelView itemViewAtIndex:(NSInteger)index;
- (void)wheelViewWillBeginDragging:(ALWheelView*)wheelView;
- (void)wheelViewDidEndScrollAnimation:(ALWheelView*)wheelView;

@end



@interface ALWheelView : UIView

@property (nonatomic, weak) id<ALWheelViewDelegate> delegate;
@property (nonatomic, assign, readonly) NSInteger currentIndex;

@end

