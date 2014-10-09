//
//  MPBarsGraphView.m
//  MPPlot
//
//  Created by Alex Manzella on 22/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPBarsGraphView.h"

@interface MPBarsGraphView()

@property (nonatomic, strong) NSMutableArray *barBottomViews;

@end

@implementation MPBarsGraphView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonSetup];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonSetup];
    }
    return self;
}

- (void)commonSetup
{
    // Initialization code
    self.backgroundColor=[UIColor clearColor];
    
    currentTag=-1;
    
    self.barBottomViews = [NSMutableArray array];
    self.topCornerRadius=-1;
    self.maxBarWidth = 30.0;
    self.maxBarPadding = 30.0;
    self.barBottomViewHeight = 30.0;
    self.barBottomViewCornerRadius = 15.0;
    self.barBottomViewPadding = 10.0;
}



- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    
    
    if (self.values && !self.waitToUpdate) {
        
        
        for (UIView *subview in self.subviews) {
            [subview removeFromSuperview];
        }
        
        [self addBarsAnimated:shouldAnimate];
        
        [self.graphColor setStroke];
        
        UIBezierPath *line=[UIBezierPath bezierPath];
        
        [line moveToPoint:CGPointMake(PADDING, self.height-self.barBottomViewHeight-self.barBottomViewPadding)];
        [line addLineToPoint:CGPointMake(self.width-PADDING, self.height-self.barBottomViewHeight-self.barBottomViewPadding)];
        [line setLineWidth:1];
        [line stroke];
    }
}

- (void)addBarsAnimated:(BOOL)animated{
    
    
    for (UIButton* button in buttons) {
        [button removeFromSuperview];
    }
    
    for (UIView *view in self.barBottomViews)
    {
        [view removeFromSuperview];
    }
    
    buttons=[[NSMutableArray alloc] init];
    
    if (animated) {
        self.layer.masksToBounds=YES;
    }
    
    CGFloat barWidthDefault=self.width/(points.count*2+1);
    CGFloat barWidthFullPadding = ((self.width-self.maxBarPadding)/(points.count))-self.maxBarPadding;
    CGFloat desiredBarWidth=MAX(barWidthFullPadding, barWidthDefault);
    
    CGFloat barWidth = MIN(desiredBarWidth, self.maxBarWidth);
    CGFloat padding=MIN(self.maxBarPadding, desiredBarWidth);
    CGFloat radius=barWidth*(self.topCornerRadius >=0 ? self.topCornerRadius : 0.3);
    CGFloat contentHeight = self.height-self.barBottomViewHeight-self.barBottomViewPadding;
    for (NSInteger i=0;i<points.count;i++) {
        
        CGFloat height=[[points objectAtIndex:i] floatValue]*(contentHeight-PADDING*2)+PADDING;
        MPButton *button=[MPButton buttonWithType:UIButtonTypeCustom tappableAreaOffset:UIOffsetMake(barWidth/2, contentHeight)];
        [button setBackgroundColor:self.graphColor];
        button.frame=CGRectMake(padding+(padding*i+barWidth*i), animated ? contentHeight : contentHeight-height, barWidth, animated ? height+20 : height);
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = button.bounds;
        
        
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(radius, radius)].CGPath;
        
        button.layer.mask=maskLayer;
        
        [button addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=i;
        [self addSubview:button];
        
        if (animated) {
            [UIView animateWithDuration:self.animationDuration delay:i*0.1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                button.y=contentHeight-height-20;
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:.15 animations:^{
                    button.frame=CGRectMake(padding+(padding*i+barWidth*i), contentHeight-height, barWidth, height);
                }];
            }];
        }
        
        [buttons addObject:button];
        
        CGRect barBottomViewFrame = CGRectMake(button.frame.origin.x, contentHeight+1, barWidth, self.barBottomViewHeight+self.barBottomViewPadding-1);
        UIView *barBottomView = [[UIView alloc] initWithFrame:barBottomViewFrame];
        barBottomView.backgroundColor = [UIColor whiteColor];
        
        if (self.additionalBarBottomViews.count > i)
        {
            UIView *additionalView = self.additionalBarBottomViews[i];
            additionalView.frame = CGRectMake(0.0, self.barBottomViewPadding, self.barBottomViewHeight, self.barBottomViewHeight);
            additionalView.layer.cornerRadius = self.barBottomViewCornerRadius;
            additionalView.clipsToBounds = YES;
            [barBottomView addSubview:additionalView];
            
            additionalView.alpha = animated ? 0.0 : 1.0;
            
            if (animated)
            {
                [UIView animateWithDuration:self.animationDuration delay:i*0.1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    additionalView.alpha = 1.0;
                } completion:nil];
            }
        }
        
        [self addSubview:barBottomView];
        [self.barBottomViews addObject:barBottomView];
    }
    
    
    
    shouldAnimate=NO;
    
}

- (CGFloat)animationDuration{
    return _animationDuration>0.0 ? _animationDuration : .25;
}





- (void)animate{
    
    self.waitToUpdate=NO;
    
    shouldAnimate=YES;
    
    [self setNeedsDisplay];
}







@end
