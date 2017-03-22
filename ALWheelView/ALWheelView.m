//
//  ALWheelView.m
//  wheelCollectionView
//
//  Created by Ash Li on 2017/3/7.
//  Copyright © 2017年 ashli. All rights reserved.
//

#import "ALWheelView.h"
#import "ALWheelCollectionViewFlowLayout.h"

#define MULTIPLE 1000

@interface ALWheelView ()<UICollectionViewDataSource, ALWheelCollectionViewFlowLayoutDelegate, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger originCount;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign, readonly) NSInteger currentTotalIndex;
@property (nonatomic, strong) ALWheelCollectionViewFlowLayout *layout;
@end

@implementation ALWheelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _originCount = 0;
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
    if (self.collectionView.contentOffset.x == 0 &&  self.totalCount) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(self.totalCount / 2 - self.originCount / 2) inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    
}

- (NSInteger)currentIndex
{
    return self.currentTotalIndex % self.originCount;
}

- (NSInteger)currentTotalIndex
{
    if (CGRectGetWidth(self.collectionView.frame) == 0 || CGRectGetHeight(self.collectionView.frame) == 0) {
        return 0;
    }
    CGPoint center = CGPointMake(self.collectionView.frame.size.width / 2, self.collectionView.frame.size.height / 2);
    CGPoint point = [self convertPoint:center toView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    return indexPath.item;

}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds
                                             collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"itemID"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.clipsToBounds = NO;
        _collectionView.bounces = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        _collectionView.scrollsToTop = NO;
    }
    return _collectionView;
}

- (ALWheelCollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [[ALWheelCollectionViewFlowLayout alloc] init];
    }
    return _layout;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfItemsInWheel:)]) {
        self.originCount = [self.delegate numberOfItemsInWheel:self];
    }
    self.totalCount = self.originCount * MULTIPLE;
    if (self.totalCount != 0) {
        [self setNeedsLayout];
    }
    return self.totalCount;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"itemID" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(wheelView:itemViewAtIndex:)]) {
        UIView *customView = [self.delegate wheelView:self itemViewAtIndex:indexPath.item % self.originCount];
        customView.frame = cell.contentView.bounds;
        [cell.contentView addSubview:customView];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (indexPath.item != self.currentTotalIndex) {
        [self.collectionView scrollToItemAtIndexPath:indexPath
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:YES];
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(wheelView:didClickItemAtIndex:)]) {
            [self.delegate wheelView:self didClickItemAtIndex:indexPath.item % self.originCount];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
//    NSLog(@"%ld",(long)[self currentIndex]);
    if (self.delegate && [self.delegate respondsToSelector:@selector(wheelViewDidEndScrollAnimation:)]) {
        [self.delegate wheelViewDidEndScrollAnimation:self];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSLog(@"%ld",(long)[self currentIndex]);
    if (self.delegate && [self.delegate respondsToSelector:@selector(wheelViewDidEndScrollAnimation:)]) {
        [self.delegate wheelViewDidEndScrollAnimation:self];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(wheelViewWillBeginDragging:)]) {
        [self.delegate wheelViewWillBeginDragging:self];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate){
//        if (self.delegate && [self.delegate respondsToSelector:@selector(wheelViewDidEndScrollAnimation:)]) {
//            [self.delegate wheelViewDidEndScrollAnimation:self];
//        }
    }
}

#pragma mark - ALWheelCollectionViewFlowLayoutDelegate

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    //make sure only show one row
    return CGRectGetHeight(collectionView.bounds);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 50.f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sizeOfItemInWheel:atIndex:)]) {
        return [self.delegate sizeOfItemInWheel:self atIndex:indexPath.item % self.originCount];
    }
    return CGSizeZero;
}

- (CGFloat)radiusOfcollectionView:(UICollectionView *)collectionView layout:(ALWheelCollectionViewFlowLayout *)collectionViewLayout
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(radiusOfWheel:)]) {
        return [self.delegate radiusOfWheel:self];
    }
    return DEFAULT_RADIUS;
}

- (CGFloat)minScaleOfcollectionView:(UICollectionView *)collectionView layout:(ALWheelCollectionViewFlowLayout *)collectionViewLayout
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(minScaleOfItemInWheel:)]) {
        return [self.delegate minScaleOfItemInWheel:self];
    }
    return DEFAULT_MINSCALE;
}


@end
