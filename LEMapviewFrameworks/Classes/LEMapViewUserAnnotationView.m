//
//  LEMapViewUserAnnotationView.m
//  https://github.com/LarryEmerson/LEMapviewFrameworks
//
//  Created by Larry Emerson on 15/8/27.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "LEMapViewUserAnnotationView.h"

@implementation LEMapViewUserAnnotationView

- (id)initWithAnnotation:(id <MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        UIImage *imageIcon = [[LEUIFramework sharedInstance] getImageFromLEFrameworksWithName:@"map_userpin_arrow"];
        self.userImage = [[UIImageView alloc]initWithImage:imageIcon];
        [self addSubview:self.userImage];
        [self.userImage setFrame:CGRectMake(-imageIcon.size.width/2, -imageIcon.size.height/2, imageIcon.size.width, imageIcon.size.height)];
    }
    return self;
}

@end
