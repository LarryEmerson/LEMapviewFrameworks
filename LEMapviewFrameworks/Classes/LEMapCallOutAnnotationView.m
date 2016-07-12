//
//  LEMapCallOutAnnotationView.m
//  https://github.com/LarryEmerson/LEMapviewFrameworks
//
//  Created by Larry Emerson on 15/9/6.
//  Copyright (c) 2015年 360cbs. All rights reserved.
//

#import "LEMapCallOutAnnotationView.h"
#import "LEMapViewAnnotationSubView.h" 
@implementation LEMapCallOutAnnotationView{
    UIImageView *curAnnotationIcon;
    
    CGRect normalFrame;
    NSString *subViewClassName;
    LEMapViewAnnotationSubView *callOutView;
    UIImage *imgPin;
}
- (id)initWithAnnotation:(id <MAAnnotation>)annotation reuseIdentifier:(NSString *) reuseIdentifier CallOutDelegate:(id) delegate SubViewClass:(NSString *) subClass{
    self.callOutDelegate=delegate;
    subViewClassName=subClass;
    return [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
}
-(void) initUI{
    LEMapCallOutViewAnnotation *anno=(LEMapCallOutViewAnnotation *)self.annotation;
    imgPin=anno.curAnnotationIcon;
    SuppressPerformSelectorLeakWarning(
                                       callOutView=[[NSClassFromString(subViewClassName) alloc] performSelector:NSSelectorFromString(@"initWithAnnotation:") withObject:self.annotation];
                                       );
    [self addSubview:callOutView];
    [callOutView setCallOutDelegate:self.callOutDelegate];
    [callOutView setCurAnnotationView:self];
    [callOutView setData:anno.curData];
    [self setFrame:CGRectMake(0, 0, callOutView.bounds.size.width, callOutView.bounds.size.height)];
    [self setCenterOffset:CGPointMake(0, -imgPin.size.height -callOutView.bounds.size.height/2 )];
}
-(void) reSetCenterOffset:(int) offset{ 
    [self setFrame:CGRectMake(0, 0, self.bounds.size.width, offset )];
    [self setCenterOffset:CGPointMake(0, -imgPin.size.height -offset/2 )];
}
-(void) refreshUI{
    [callOutView setData:self.curData];
}
@end
