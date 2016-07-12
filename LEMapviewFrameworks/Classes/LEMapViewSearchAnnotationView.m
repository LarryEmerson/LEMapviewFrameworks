//
//  LEMapViewSearchAnnotationView.m
//  https://github.com/LarryEmerson/LEMapviewFrameworks
//
//  Created by Larry Emerson on 15/8/27.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "LEMapViewSearchAnnotationView.h"

@implementation LEMapViewSearchAnnotationView

- (id) initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]){
        self.annotation=annotation;
        UIImage *imageIcon = [[LEUIFramework sharedInstance] getImageFromLEFrameworksWithName:@"map_pin_searched"];
        UIImageView *pinIcon = [[UIImageView alloc] initWithImage:imageIcon];
        [self addSubview:pinIcon];
        [pinIcon setUserInteractionEnabled:YES];
        [self setFrame:CGRectMake(-imageIcon.size.width/2, -imageIcon.size.height/2, imageIcon.size.width, imageIcon.size.height)];
    }
    return self;
}

@end
