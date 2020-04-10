//
//  MobFoxMoPubNativeAdView.h
//  MFXTester
//
//  Created by Shimon Shnitzer on 09/03/2020.
//  Copyright © 2020 MobFox Mobile Advertising GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#if __has_include(<MoPub/MoPub.h>)
#import <MoPub/MoPub.h>
#elif __has_include(<MoPubSDKFramework/MoPub.h>)
#import <MoPubSDKFramework/MoPub.h>
#elif __has_include(<MoPub.h>)
#import <MoPub.h>
#else
#import "MPNativeAdRenderer.h"
#import "MPNativeAdRendererSettings.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface MobFoxMoPubNativeAdView : UIView <MPNativeAdRendering>

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *mainTextLabel;
@property (strong, nonatomic) UILabel *callToActionLabel;
@property (strong, nonatomic) UILabel *sponsoredByLabel;
@property (strong, nonatomic) UILabel *ratingLabel;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UIImageView *mainImageView;
@property (strong, nonatomic) UIImageView *privacyInformationIconImageView;

@end

NS_ASSUME_NONNULL_END
