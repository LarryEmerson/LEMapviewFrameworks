//
//  LEMapViewAnnotationSubView.h
//  https://github.com/LarryEmerson/LEMapviewFrameworks
//
//  Created by Larry Emerson on 15/8/27.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEMapCallOutViewAnnotation.h"
#import "LEUIFramework.h" 
#import "LEMapCallOutAnnotationView.h"
@interface LEMapViewAnnotationSubView : UIButton
-(id) initWithAnnotation:(LEMapCallOutViewAnnotation *) anno;
-(void) leSetDelegate:(id<LEMapViewDelegate>) delegate;
-(void) leSetData:(NSDictionary *) data;
-(void) leSetCurrentAnnotationView:(LEMapCallOutAnnotationView *) view;
-(UIView *) leGetCalloutViewContainer;
-(UIImageView *) leGetCalloutBackground;
-(LEMapCallOutViewAnnotation *) leGetAnnotation;
@end
