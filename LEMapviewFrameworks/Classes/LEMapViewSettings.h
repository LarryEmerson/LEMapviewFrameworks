//
//  LEMapViewSettings.h
//  Pods
//
//  Created by emerson larry on 16/7/13.
//
//

#import <Foundation/Foundation.h>
#import "LEFrameworks.h"
@interface LEMapViewSettings : NSObject
singleton_interface(LEMapViewSettings)
@property (nonatomic) NSBundle *leMapviewBundle;
@property (nonatomic) UIImage *leCompass;
@property (nonatomic) UIImage *leLocateStatusNormal;
@property (nonatomic) UIImage *leLocateStatusRotate;
@property (nonatomic) UIImage *leLocateStatusFollow;
@property (nonatomic) UIImage *leScaleBackground;
@property (nonatomic) UIImage *leScaleUp;
@property (nonatomic) UIImage *leScaleUpHighlighted;
@property (nonatomic) UIImage *leScaleDown;
@property (nonatomic) UIImage *leScaleDownHighlighted;
@property (nonatomic) UIImage *lePinForSearched;
@property (nonatomic) UIImage *lePinForUserAsArrow;
- (NSString *) getImagePathWithName:(NSString *) name;
- (UIImage *) getImageWithName:(NSString *) name;
@end
