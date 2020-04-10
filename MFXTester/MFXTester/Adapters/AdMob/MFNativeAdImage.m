//
//  MFNativeAdImage.m
//  MFXTester
//
//  Created by Shimon Shnitzer on 02/02/2020.
//  Copyright © 2020 MobFox Mobile Advertising GmbH. All rights reserved.
//

#import "MFNativeAdImage.h"

@interface MFNativeAdImage()

/// The image. If image autoloading is disabled, this property will be nil.
@property(nonatomic, strong, nullable) UIImage *my_image;

/// The image's URL.
@property(nonatomic, copy, nullable) NSURL *my_imageURL;

@property(nonatomic, readonly, assign) CGFloat my_scale;

@end

@implementation MFNativeAdImage

- (instancetype)initWithURL:(NSString*)url andImage:(UIImage*)img
{
        self = [super initWithImage:img];
        if (self) {
            
            self.my_image = img;
            
            self.my_imageURL = [NSURL URLWithString:url];
        }
        return self;
}

- (UIImage *)image {
    return self.my_image;
}

- (NSURL *)imageURL {
    return self.my_imageURL;
}

- (CGFloat)svale {
    return 0.0f;
}


@end
