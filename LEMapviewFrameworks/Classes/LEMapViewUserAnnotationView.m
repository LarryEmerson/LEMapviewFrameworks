//
//  LEMapViewUserAnnotationView.m
//  https://github.com/LarryEmerson/LEMapviewFrameworks
//
//  Created by Larry Emerson on 15/8/27.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "LEMapViewUserAnnotationView.h"
#import "LEMapViewSettings.h"
@interface LEMapViewUserAnnotationView()
@property (nonatomic, readwrite) UIImageView *leUserImage;
@end
@implementation LEMapViewUserAnnotationView

- (id)initWithAnnotation:(id <MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        UIImage *imageIcon = [[LEMapViewSettings sharedInstance] lePinForUserAsArrow];
        self.leUserImage = [[UIImageView alloc]initWithImage:imageIcon];
        [self addSubview:self.leUserImage];
        [self.leUserImage setFrame:CGRectMake(-imageIcon.size.width/2, -imageIcon.size.height/2, imageIcon.size.width, imageIcon.size.height)];
    }
    return self;
}

@end
