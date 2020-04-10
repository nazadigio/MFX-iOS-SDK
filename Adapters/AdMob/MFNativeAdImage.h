//
//  MFNativeAdImage.h
//  MFXTester
//
//  Created by Shimon Shnitzer on 02/02/2020.
//  Copyright © 2020 MobFox Mobile Advertising GmbH. All rights reserved.
//

#import <GoogleMobileAds/GoogleMobileAds.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFNativeAdImage : GADNativeAdImage

- (instancetype)initWithURL:(NSString*)url andImage:(UIImage*)img;

@end

NS_ASSUME_NONNULL_END
