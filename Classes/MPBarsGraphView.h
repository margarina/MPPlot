//
//  MPBarsGraphView.h
//  MPPlot
//
//  Created by Alex Manzella on 22/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPPlot.h"

@interface MPBarsGraphView : MPPlot{
    
    BOOL shouldAnimate;
}

@property (nonatomic,readwrite) CGFloat topCornerRadius;
@property (nonatomic, assign) CGFloat maxBarWidth;
@property (nonatomic, assign) CGFloat maxBarPadding;
@property (nonatomic, assign) CGFloat barBottomViewHeight;
@property (nonatomic, assign) CGFloat barBottomViewCornerRadius;
@property (nonatomic, assign) CGFloat barBottomViewPadding;
@property (nonatomic, strong) NSArray *additionalBarBottomViews;

@end
