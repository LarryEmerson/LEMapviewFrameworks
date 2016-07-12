//
//  LEMapViewAnnotationView.h
//  LEFrameworks
//
//  Created by Larry Emerson on 15/8/27.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "LEMapBaseAnnotationView.h"

@interface LEMapViewAnnotationView : LEMapBaseAnnotationView
@property (nonatomic) UIImageView *curAnnotationIcon;
@property (nonatomic) float originalAngle;
-(void) onSetAngle:(float) angle;
-(void) onSetViewCenter:(CGPoint) point;
-(void) onResetAngle;
@end
