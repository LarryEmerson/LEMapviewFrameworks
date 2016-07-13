//
//  LEMapViewSettings.m
//  Pods
//
//  Created by emerson larry on 16/7/13.
//
//

#import "LEMapViewSettings.h"


@implementation LEMapViewSettings
#pragma Singleton
static LEMapViewSettings *theSharedInstance = nil;
+ (instancetype) sharedInstance { @synchronized(self) { if (theSharedInstance == nil) { theSharedInstance = [[self alloc] init];
    
} } return theSharedInstance; }
+ (id) allocWithZone:(NSZone *)zone { @synchronized(self) { if (theSharedInstance == nil) { theSharedInstance = [super allocWithZone:zone]; return theSharedInstance; } } return nil; }
+ (id) copyWithZone:(NSZone *)zone { return self; }
+ (id) mutableCopyWithZone:(NSZone *)zone { return self; }

-(id) init{
    self=[super init];
    if(self){
        self.leMapviewBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"LEMapviewFrameworks" ofType:@"bundle"]];
        self.leCompass              =[self getImageWithName:@"map_compass"];
        self.leLocateStatusNormal   =[self getImageWithName:@"map_btn_status"];
        self.leLocateStatusRotate   =[self getImageWithName:@"map_btn_status2"];
        self.leLocateStatusFollow   =[self getImageWithName:@"map_btn_status3"];
        self.leScaleBackground      =[self getImageWithName:@"mapScaleBG"];
        self.leScaleUp              =[self getImageWithName:@"mapScaleUp"];
        self.leScaleDown            =[self getImageWithName:@"mapScaleDown"];
        self.leScaleUpHighlighted   =[self getImageWithName:@"mapScaleUp2"];
        self.leScaleDownHighlighted =[self getImageWithName:@"mapScaleDown2"];
        self.lePinForSearched       =[self getImageWithName:@"map_pin_searched"];
        self.lePinForUserAsArrow    =[self getImageWithName:@"map_userpin_arrow"];
    }
    return self;
}
- (NSString *) getImagePathWithName:(NSString *) name{
    NSString *path= [NSString stringWithFormat:@"%@/%@.png",self.leMapviewBundle.bundlePath,name];
    return path;
}
- (UIImage *) getImageWithName:(NSString *) name{
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[self getImagePathWithName:name]];
    return image;
}
@end
