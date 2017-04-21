//
//  LEMapViewAnnotationSubView.m
//  https://github.com/LarryEmerson/LEMapviewFrameworks
//
//  Created by Larry Emerson on 15/8/27.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "LEMapViewAnnotationSubView.h"
@interface LEMapViewAnnotationSubView()
@property (nonatomic) id<LEMapViewDelegate> leCallOutDelegate;
@property (nonatomic) UIView *callOutViewContainer;
@property (nonatomic) LEMapCallOutViewAnnotation *annotation;
@property (nonatomic) UIImageView *curBG;
@property (nonatomic) LEMapCallOutAnnotationView *curAnnotationView;
@end
@implementation LEMapViewAnnotationSubView{
    UIImage *imgBG; 
}
-(id) initWithAnnotation:(LEMapCallOutViewAnnotation *) anno{
    self.annotation=anno;
    self=[super init];
    imgBG=anno.leGetCalloutBackground;
    self.curBG=[[UIImageView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self EdgeInsects:UIEdgeInsetsZero]];
    [self.curBG setImage:[imgBG stretchableImageWithLeftCapWidth:imgBG.size.width/2 topCapHeight:imgBG.size.height/2]];
    [self leSetSize:imgBG.size];
    self.callOutViewContainer=[[UIView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self EdgeInsects:UIEdgeInsetsZero]];
    [self.callOutViewContainer setUserInteractionEnabled:NO];
    [self leAdditionalInits];
    [self addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    return self;
}
-(LEMapCallOutViewAnnotation *) leGetAnnotation{
    return self.annotation;
}
-(UIImageView *) leGetCalloutBackground{
    return self.curBG;
}
-(UIView *) leGetCalloutViewContainer{
    return self.callOutViewContainer;
}
-(void) leSetDelegate:(id<LEMapViewDelegate>) delegate{
    self.leCallOutDelegate=delegate;
}
-(void) leSetData:(NSDictionary *) data{
}
-(void) leSetCurrentAnnotationView:(LEMapCallOutAnnotationView *) view{
    self.curAnnotationView=view;
}
-(void) onClick{
    if(self.leCallOutDelegate){
        [self.leCallOutDelegate leOnCallOutViewClickedWithData:self.annotation.leMapData];
    }
}
@end
