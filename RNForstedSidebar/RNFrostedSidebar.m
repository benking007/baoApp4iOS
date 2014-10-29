//
//  RNFrostedMenu.m
//  RNFrostedMenu
//
//  Created by Ryan Nystrom on 8/13/13.
//  Copyright (c) 2013 Ryan Nystrom. All rights reserved.
//

#define __IPHONE_OS_VERSION_SOFT_MAX_REQUIRED __IPHONE_7_0
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "RNFrostedSidebar.h"
#import <QuartzCore/QuartzCore.h>

#pragma mark - Private Classes

@interface RNCalloutItemView : UIView

@property (nonatomic, strong) UIView *customView;
@property (nonatomic, assign) NSInteger itemIndex;
@property (nonatomic, strong) UIColor *originalBackgroundColor;
@property (nonatomic, assign) CGSize itemSize;

@end

@implementation RNCalloutItemView

- (instancetype)init {
    if (self = [super init]) {
        _customView = [[UIView alloc] init];
        _customView.backgroundColor = [UIColor clearColor];
        _customView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_customView];
    }
    return self;
}

@end

#pragma mark - Public Classes

@interface RNFrostedSidebar ()

@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) NSMutableArray *customViews;
@property (nonatomic, strong) NSArray *borderColors;
@property (nonatomic, strong) NSMutableArray *itemViews;
@property (nonatomic, strong) NSMutableIndexSet *selectedIndices;

@end

static RNFrostedSidebar *rn_frostedMenu;

@implementation RNFrostedSidebar

+ (instancetype)visibleSidebar {
    return rn_frostedMenu;
}

- (instancetype)initWithCustomViews:(NSMutableArray *)customViews selectedIndices:(NSIndexSet *)selectedIndices borderColors:(NSArray *)colors alwaysVertical:(BOOL) alwaysVertical {
    if (self = [super init]) {
        _contentView = [[UIScrollView alloc] init];
        _contentView.alwaysBounceHorizontal = NO;
        _contentView.alwaysBounceVertical = alwaysVertical;
        _contentView.bounces = YES;
        _contentView.clipsToBounds = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.showsVerticalScrollIndicator = NO;
        
        _leftPadding = 22;
        _topPadding = 16;
        _width = 150;
        _animationDuration = 0.2f;
        _itemSize = CGSizeMake(_width-44, _width/2);
        _itemViews = [NSMutableArray array];
        _tintColor = [UIColor colorWithWhite:0.2 alpha:0.73];
        _borderWidth = 2;
        _siderBackgroundColor = [UIColor whiteColor];
        _backgroundColorAlpha = 0.95;
        _originX = 0;
        _height = 150;
        _showFromTop = FALSE;
        _majorBackgroundColor = [UIColor clearColor];
        _majorBackgroundColorAlpha = 0.95;
        _majorViewAnimation = TRUE;
        _tagName = [[NSString alloc] init];
        
        if (colors) {
            NSAssert([colors count] == [customViews count], @"Border color count must match images count. If you want a blank border, use [UIColor clearColor].");
        }
        
        _selectedIndices = [selectedIndices mutableCopy] ?: [NSMutableIndexSet indexSet];
        _borderColors = colors;
        _customViews = customViews;
        
        [_customViews enumerateObjectsUsingBlock:^(UIView *customview, NSUInteger idx, BOOL *stop) {
            RNCalloutItemView *view = [[RNCalloutItemView alloc] init];
            view.itemIndex = idx;
            view.clipsToBounds = YES;
            view.customView.frame = customview.frame;
            view.itemSize = customview.frame.size;
            [view.customView addSubview:customview];
            [_contentView addSubview:view];
            [_itemViews addObject:view];
            
            if (_borderColors && _selectedIndices && [_selectedIndices containsIndex:idx]) {
                UIColor *color = _borderColors[idx];
                view.layer.borderColor = color.CGColor;
            }
            else {
                view.layer.borderColor = [UIColor clearColor].CGColor;
            }
        }];
    }
    return self;
}

- (instancetype)initWithCustomViews:(NSMutableArray *)customViews selectedIndices:(NSIndexSet *)selectedIndices {
    return [self initWithCustomViews:customViews selectedIndices:selectedIndices borderColors:nil alwaysVertical:YES];
}

- (instancetype)initWithCustomViews:(NSMutableArray *)customViews {
    return [self initWithCustomViews:customViews selectedIndices:nil borderColors:nil alwaysVertical:YES];
}

- (instancetype)init {
    NSAssert(NO, @"Unable to create with plain init.");
    return nil;
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor =  _majorBackgroundColor;
    
    if (_majorViewAnimation) {
        self.view.alpha = 0;
        [UIView animateWithDuration:0.5 animations:^{
            self.view.alpha = _majorBackgroundColorAlpha;
        } completion:^(BOOL finished) {
        }];
    } else {
        self.view.alpha = _majorBackgroundColorAlpha;
    }
    
    [self.view addSubview:self.contentView];
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    self.swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapForHide:)];
    
    [self.swipeGesture setDirection:(self.showFromRight ? UISwipeGestureRecognizerDirectionRight :UISwipeGestureRecognizerDirectionLeft)];
    
    [self.view addGestureRecognizer:self.swipeGesture];
    [self.view addGestureRecognizer:self.tapGesture];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if ([self isViewLoaded] && self.view.window != nil) {
        self.view.alpha = 0;
        [self layoutSubviews];
    }
}

#pragma mark - Show

- (void)animateSpringWithView:(RNCalloutItemView *)view idx:(NSUInteger)idx initDelay:(CGFloat)initDelay {
#if __IPHONE_OS_VERSION_SOFT_MAX_REQUIRED
    [UIView animateWithDuration:0.5
                          delay:(initDelay + idx*0.1f)
         usingSpringWithDamping:10
          initialSpringVelocity:50
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         view.layer.transform = CATransform3DIdentity;
                         view.alpha = 1;
                     }
                     completion:nil];
#endif
}

- (void)animateFauxBounceWithView:(RNCalloutItemView *)view idx:(NSUInteger)idx initDelay:(CGFloat)initDelay {
    [UIView animateWithDuration:0.2
                          delay:(initDelay + idx*0.1f)
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut
                     animations:^{
                         view.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1);
                         view.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1 animations:^{
                             view.layer.transform = CATransform3DIdentity;
                         }];
                     }];
}

- (void)showInViewController:(UIViewController *)controller animated:(BOOL)animated {
    if (rn_frostedMenu != nil) {
        //[rn_frostedMenu dismissAnimated:NO];
    }
    
    if ([self.delegate respondsToSelector:@selector(sidebar:willShowOnScreenAnimated:)]) {
        [self.delegate sidebar:self willShowOnScreenAnimated:animated];
    }
    
    rn_frostedMenu = self;
    
    [self rn_addToParentViewController:controller callingAppearanceMethods:YES];
    //self.view.frame = controller.view.bounds;
    
    CGFloat parentWidth = _originX != 0 ? _originX : self.view.bounds.size.width;
    
    CGRect contentFrame = self.view.bounds;
    if(!_showFromTop) {
        contentFrame.origin.x = _showFromRight ? parentWidth : -_width;
        contentFrame.size.width = _width;
    } else {
        contentFrame.origin.y = -_height;
        contentFrame.size.height = _height;
    }
    
    self.contentView.frame = contentFrame;
    
    [self layoutItems];
    
    self.contentView.backgroundColor = _siderBackgroundColor;
    self.contentView.alpha = _backgroundColorAlpha;
    
    if(!_showFromTop) {
        contentFrame.origin.x = _showFromRight ? parentWidth - _width : 0;
    } else {
        contentFrame.origin.y = 0;
    }
    
    void (^animations)() = ^{
        self.contentView.frame = contentFrame;
    };
    void (^completion)(BOOL) = ^(BOOL finished) {
        if (finished && [self.delegate respondsToSelector:@selector(sidebar:didShowOnScreenAnimated:)]) {
            [self.delegate sidebar:self didShowOnScreenAnimated:animated];
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:kNilOptions
                         animations:animations
                         completion:completion];
    }
    else{
        animations();
        completion(YES);
    }
    
    CGFloat initDelay = 0.1f;
    SEL sdkSpringSelector = NSSelectorFromString(@"animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:");
    BOOL sdkHasSpringAnimation = [UIView respondsToSelector:sdkSpringSelector];
    
    [self.itemViews enumerateObjectsUsingBlock:^(RNCalloutItemView *view, NSUInteger idx, BOOL *stop) {
        /* 动画关闭
        view.layer.transform = CATransform3DMakeScale(0.3, 0.3, 1);
        view.alpha = 1;
        view.originalBackgroundColor = self.itemBackgroundColor;
        view.layer.borderWidth = self.borderWidth;
        */
        if (sdkHasSpringAnimation) {
            [self animateSpringWithView:view idx:idx initDelay:initDelay];
        }
        else {
            [self animateFauxBounceWithView:view idx:idx initDelay:initDelay];
        }
    }];
}

- (void)showAnimated:(BOOL)animated {
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (controller.presentedViewController != nil) {
        controller = controller.presentedViewController;
    }
    [self showInViewController:controller animated:animated];
}

- (void)show {
    [self showAnimated:YES];
}

#pragma mark - Dismiss

- (void)dismiss {
    [self dismissAnimated:YES];
}

- (void)dismissAnimated:(BOOL)animated {
    void (^completion)(BOOL) = ^(BOOL finished){
        [self rn_removeFromParentViewControllerCallingAppearanceMethods:YES];
        
        if ([self.delegate respondsToSelector:@selector(sidebar:didDismissFromScreenAnimated:)]) {
            [self.delegate sidebar:self didDismissFromScreenAnimated:YES];
        }
    };
    
    if ([self.delegate respondsToSelector:@selector(sidebar:willDismissFromScreenAnimated:)]) {
        [self.delegate sidebar:self willDismissFromScreenAnimated:YES];
    }
    
    if (animated) {
        CGFloat parentWidth = self.view.bounds.size.width;
        CGRect contentFrame = self.contentView.frame;
        if(!_showFromTop) {
            contentFrame.origin.x = self.showFromRight ? parentWidth : -_width;
        } else {
            contentFrame.origin.y = -_height;
        }
        
        if (_majorViewAnimation) {
            [UIView animateWithDuration:0.5 animations:^{
                self.view.alpha = 0;
            } completion:^(BOOL finished) {
            }];
        }
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.contentView.frame = contentFrame;
                             //self.blurView.frame = blurFrame;
                         }
                         completion:completion];
    }
    else {
        completion(YES);
    }
}

#pragma mark - Gestures

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.view];
    if (! CGRectContainsPoint(self.contentView.frame, location)) {
        [self dismissAnimated:YES];

    } else {
        NSInteger tapIndex = [self indexOfTap:[recognizer locationInView:self.contentView]];
        if (tapIndex != NSNotFound) {
            [self didTapItemAtIndex:tapIndex];
        }
    }
}

- (void)handleTapForHide:(UISwipeGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.view];
    if (!CGRectContainsPoint(self.contentView.frame, location)) {
        [self dismissAnimated:YES];
    }
}

#pragma mark - Private

- (void)didTapItemAtIndex:(NSUInteger)index {
    BOOL didEnable = ! [self.selectedIndices containsIndex:index];
    
    if ([self.delegate respondsToSelector:@selector(sidebar:didTapItemAtIndex:)]) {
        [self.delegate sidebar:self didTapItemAtIndex:index];
    }
    if ([self.delegate respondsToSelector:@selector(sidebar:didEnable:itemAtIndex:)]) {
        [self.delegate sidebar:self didEnable:didEnable itemAtIndex:index];
    }
}

- (void)layoutSubviews {
    CGFloat x = self.showFromRight ? self.parentViewController.view.bounds.size.width - _width : 0;
    self.contentView.frame = CGRectMake(x, 0, _width, self.parentViewController.view.bounds.size.height);
    
    [self layoutItems];
}

- (void)layoutItems {
    [self.itemViews enumerateObjectsUsingBlock:^(RNCalloutItemView *view, NSUInteger idx, BOOL *stop) {
        CGFloat mTopPadding = idx == 0 ? 22 : _topPadding * idx + view.itemSize.height * idx + _topPadding+6;
        if(_topPadding==0) mTopPadding = 0;
        
        CGRect frame = CGRectMake(_leftPadding, mTopPadding, view.itemSize.width, view.itemSize.height);
        view.frame = frame;
        view.layer.cornerRadius = 0;
    }];
    
    NSInteger items = [self.itemViews count];
    self.contentView.contentSize = CGSizeMake(0, items * (self.itemSize.height + _leftPadding) + _leftPadding);
}

- (NSInteger)indexOfTap:(CGPoint)location {
    __block NSUInteger index = NSNotFound;
    
    [self.itemViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if (CGRectContainsPoint(view.frame, location)) {
            index = idx;
            *stop = YES;
        }
    }];
    
    return index;
}

- (void)rn_addToParentViewController:(UIViewController *)parentViewController callingAppearanceMethods:(BOOL)callAppearanceMethods {
    if (self.parentViewController != nil) {
        [self rn_removeFromParentViewControllerCallingAppearanceMethods:callAppearanceMethods];
    }
    
    if (callAppearanceMethods) [self beginAppearanceTransition:YES animated:NO];
    [parentViewController addChildViewController:self];
    [parentViewController.view addSubview:self.view];
    [self didMoveToParentViewController:self];
    if (callAppearanceMethods) [self endAppearanceTransition];
}

- (void)rn_removeFromParentViewControllerCallingAppearanceMethods:(BOOL)callAppearanceMethods {
    if (callAppearanceMethods) [self beginAppearanceTransition:NO animated:NO];
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    if (callAppearanceMethods) [self endAppearanceTransition];
}

@end
