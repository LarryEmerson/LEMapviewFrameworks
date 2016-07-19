//
//  LEMapCallOutAnnotationView.m
//  https://github.com/LarryEmerson/LEMapviewFrameworks
//
//  Created by Larry Emerson on 15/9/6.
//  Copyright (c) 2015年 360cbs. All rights reserved.
//

#import "LEMapCallOutAnnotationView.h"
#import "LEMapViewAnnotationSubView.h" 
@interface LEMapCallOutAnnotationView()
@property (nonatomic) id<LEMapViewDelegate> leCallOutDelegate;
@end

@implementation LEMapCallOutAnnotationView{
    UIImageView *curAnnotationIcon;
    
    CGRect normalFrame;
    NSString *subViewClassName;
    LEMapViewAnnotationSubView *callOutView;
    UIImage *imgPin;
}
-(void) leSetDelegate:(id<LEMapViewDelegate>) delegate{
    self.leCallOutDelegate=delegate;
}
-(id<LEMapViewDelegate>) leGetDelegate{
    return self.leCallOutDelegate;
}
- (id)initWithAnnotation:(id <MAAnnotation>)annotation reuseIdentifier:(NSString *) reuseIdentifier CallOutDelegate:(id) delegate SubViewClass:(NSString *) subClass{
    self.leCallOutDelegate=delegate;
    subViewClassName=subClass;
    return [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
}
-(void) leExtraInits{
    LEMapCallOutViewAnnotation *anno=(LEMapCallOutViewAnnotation *)self.annotation;
    imgPin=anno.leCurrentAnnotationIcon;
    LESuppressPerformSelectorLeakWarning(
                                         callOutView=[[NSClassFromString(subViewClassName) alloc] performSelector:NSSelectorFromString(@"initWithAnnotation:") withObject:self.annotation];
                                         );
    [self addSubview:callOutView];
    [callOutView leSetDelegate:self.leCallOutDelegate];
    [callOutView leSetCurrentAnnotationView:self];
    [callOutView leSetData:anno.leMapData];
    [self setFrame:CGRectMake(0, 0, callOutView.bounds.size.width, callOutView.bounds.size.height)];
    [self setCenterOffset:CGPointMake(0, -imgPin.size.height -callOutView.bounds.size.height/2 )];
}
-(void) leReSetCenterOffset:(int) offset{ 
    [self setFrame:CGRectMake(0, 0, self.bounds.size.width, offset )];
    [self setCenterOffset:CGPointMake(0, -imgPin.size.height -offset/2 )];
}
-(void) leRefreshUI{
    [callOutView leSetData:self.leGetMapData];
}
@end
