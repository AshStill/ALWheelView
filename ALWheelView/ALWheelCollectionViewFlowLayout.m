//
//  ALWheelCollectionViewFlowLayout.m
//  wheelCollectionView
//
//  Created by Ash Li on 2017/3/6.
//  Copyright © 2017年 ashli. All rights reserved.
//

#import "ALWheelCollectionViewFlowLayout.h"

@interface ALWheelCollectionViewFlowLayout ()

@property (nonatomic,assign) CGFloat radius;
@property (nonatomic,assign) CGFloat minScale;
@property (nonatomic,weak) id<ALWheelCollectionViewFlowLayoutDelegate> delegate;

@end

@implementation ALWheelCollectionViewFlowLayout


- (void)prepareLayout
{
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.delegate = (id<ALWheelCollectionViewFlowLayoutDelegate>)self.collectionView.delegate;
    if(self.delegate && [self.delegate respondsToSelector:@selector(radiusOfcollectionView:layout:)])
    {
        self.radius = [self.delegate radiusOfcollectionView:self.collectionView layout:self];
    }
    else
    {
        self.radius = DEFAULT_RADIUS;
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(minScaleOfcollectionView:layout:)])
    {
        self.minScale = [self.delegate minScaleOfcollectionView:self.collectionView layout:self];
    }
    else
    {
        self.minScale = DEFAULT_MINSCALE;
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray * array = [super layoutAttributesForElementsInRect:rect];
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width/2;
    NSMutableArray * modifiedLayoutAttributesArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * layoutAttributes, NSUInteger idx, BOOL *stop) {
        UICollectionViewLayoutAttributes * attributes = [layoutAttributes copy];
        CGFloat delta = attributes.center.x - centerX;
        
        if (ABS(delta) > 10.f) {
            //calculate scale and translate of the item
            CGFloat scale = 1 - (1 - self.minScale) * 2 * ABS(delta)/self.collectionView.frame.size.width;
            int flag = delta >=0 ? 1 : -1;
            CGAffineTransform transform = CGAffineTransformMakeTranslation(-flag * self.itemSize.width / 2, - self.itemSize.height / 2);
            transform = CGAffineTransformRotate(transform, atan(delta / self.radius));
            transform = CGAffineTransformTranslate(transform, flag * self.itemSize.width / 2,  self.itemSize.height / 2);
            double radio = 1 - self.radius / sqrt(self.radius * self.radius + delta * delta);
            transform = CGAffineTransformTranslate(transform, radio * delta, radio * self.radius);
            transform = CGAffineTransformScale(transform, scale, scale);
            attributes.transform = transform;
        }
        
        [modifiedLayoutAttributesArray addObject:attributes];
    }
     ];
    return modifiedLayoutAttributesArray;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * attributes = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
    attributes.transform = CGAffineTransformMakeScale(self.minScale, self.minScale);
    return attributes;
}

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    //proposed rect
    CGRect rect;
    rect.origin.x =proposedContentOffset.x;
    rect.origin.y=0;
    rect.size=self.collectionView.frame.size;
    
    NSArray * array = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat centerX = self.collectionView.frame.size.width /2+ proposedContentOffset.x;
    CGFloat minDelta = MAXFLOAT;
    for (UICollectionViewLayoutAttributes * attrs in array) {
        if (ABS(minDelta)>ABS(attrs.center.x-centerX)) {
            minDelta=attrs.center.x-centerX;
        }
    }
    // fix the final offset
    proposedContentOffset.x+=minDelta;

    return proposedContentOffset;
}
@end
