//
//  ViewController.m
//  wheelCollectionView
//
//  Created by Ash Li on 2017/3/3.
//  Copyright © 2017年 ashli. All rights reserved.
//

#import "ViewController.h"
#import "ALWheelView.h"

#define rgba(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]

#define randomColor rgba(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface ViewController ()<ALWheelViewDelegate>

@property (nonatomic, strong) ALWheelView *wheelView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.wheelView];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ALWheelView *)wheelView
{
    if (!_wheelView) {
        _wheelView = [[ALWheelView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        _wheelView.delegate = self;
    }
    return _wheelView;
}

#pragma mark - ALWheelViewDelegate
- (NSInteger)numberOfItemsInWheel:(ALWheelView *)wheelView
{
    return 10;
}

- (CGFloat)radiusOfWheel:(ALWheelView *)wheelView
{
    return 1400.f;
}

- (CGFloat)minScaleOfItemInWheel:(ALWheelView *)wheelView
{
    return 0.8;
}

- (CGSize)sizeOfItemInWheel:(ALWheelView *)wheelView atIndex:(NSInteger)index
{
    return CGSizeMake(315, 255);
}

- (void)wheelView:(ALWheelView *)wheelView didClickItemAtIndex:(NSInteger)index
{
    NSLog(@"Select Item at Index : %ld", (long)index);
}

- (UIView *)wheelView:(ALWheelView *)wheelView itemViewAtIndex:(NSInteger)index
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 315, 255)];
    view.backgroundColor = [UIColor blueColor];
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    label.textColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"%ld",(long)index];
    label.font = [UIFont boldSystemFontOfSize:40];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    return view;
}

- (void)wheelViewWillBeginDragging:(ALWheelView*)wheelView
{
    
}

- (void)wheelViewDidEndScrollAnimation:(ALWheelView*)wheelView
{
    
}

@end
