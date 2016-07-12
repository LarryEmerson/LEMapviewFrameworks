//
//  LEMapViewAnnotationSubView.m
//  LEFrameworks
//
//  Created by Larry Emerson on 15/8/27.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "LEMapViewAnnotationSubView.h"

@implementation LEMapViewAnnotationSubView{
    UIImage *imgBG; 
}
 
-(void) initUI{
    
}
-(id) initWithAnnotation:(LEMapCallOutViewAnnotation *) anno{
    self.annotation=anno;
    self=[super init]; 
    imgBG=anno.callOutBackground;
    self.curBG=[[UIImageView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self EdgeInsects:UIEdgeInsetsZero]];
    [self.curBG setImage:[imgBG stretchableImageWithLeftCapWidth:imgBG.size.width/2 topCapHeight:imgBG.size.height/2]];
    [self leSetSize:imgBG.size];
    self.callOutViewContainer=[[UIView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self EdgeInsects:UIEdgeInsetsZero]];
    [self.callOutViewContainer setUserInteractionEnabled:NO];
    [self initUI];
    [self addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    return self;
}
-(void) setData:(NSDictionary *) data{ 
}
-(void) onClick{
    if(self.callOutDelegate){
        [self.callOutDelegate onCallOutViewClickedWithData:self.annotation.curData];
    }
}
@end
