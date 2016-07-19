//
//  LEMapViewAnnotationView.h
//  https://github.com/LarryEmerson/LEMapviewFrameworks
//
//  Created by Larry Emerson on 15/8/27.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "LEMapBaseAnnotationView.h"
#import "LEMapViewAnnotation.h"
@interface LEMapViewAnnotationView : LEMapBaseAnnotationView
//@property (nonatomic) UIImageView *curAnnotationIcon;
//@property (nonatomic) float originalAngle;
-(void) leOnSetAngle:(float) angle;
-(void) leOnSetViewCenter:(CGPoint) point;
-(void) leOnResetAngle;
@end
