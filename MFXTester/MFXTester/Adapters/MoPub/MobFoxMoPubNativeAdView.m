//
//  MobFoxMoPubNativeAdView.m
//  MFXTester
//
//  Created by Shimon Shnitzer on 09/03/2020.
//  Copyright © 2020 MobFox Mobile Advertising GmbH. All rights reserved.
//

#import "MobFoxMoPubNativeAdView.h"

@implementation MobFoxMoPubNativeAdView

- (MobFoxMoPubNativeAdView*)init{
    self = [super init];
    if (self) {
        self.titleLabel             = [[UILabel alloc] init];
        self.titleLabel.font        = [UIFont systemFontOfSize:9.0];
        self.mainTextLabel          = [[UILabel alloc] init];
        self.mainTextLabel.font     = [UIFont systemFontOfSize:9.0];
        self.callToActionLabel      = [[UILabel alloc] init];
        self.callToActionLabel.font = [UIFont systemFontOfSize:13.0];
        self.callToActionLabel.backgroundColor = [UIColor lightGrayColor];
        self.callToActionLabel.textAlignment = NSTextAlignmentCenter;
        self.sponsoredByLabel       = [[UILabel alloc] init];
        self.sponsoredByLabel.font  = [UIFont systemFontOfSize:9.0];
        self.ratingLabel            = [[UILabel alloc] init];
        self.ratingLabel.font       = [UIFont systemFontOfSize:9.0];

        self.iconImageView = [[UIImageView alloc] init];
        self.mainImageView = [[UIImageView alloc] init];
        self.privacyInformationIconImageView = [[UIImageView alloc] init];

        [self addSubview:self.titleLabel];
        [self addSubview:self.mainTextLabel];
        [self addSubview:self.callToActionLabel];
        [self addSubview:self.sponsoredByLabel];
        [self addSubview:self.ratingLabel];

        [self addSubview:self.iconImageView];
        [self addSubview:self.mainImageView];
        [self addSubview:self.privacyInformationIconImageView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // layout your views
    
    CGRect  rc = self.frame;
    CGFloat w  = rc.size.width;

    self.titleLabel.frame        = CGRectMake(   64,   0,  w-64, 21);
    self.mainTextLabel.frame     = CGRectMake(   64,  23,  w-64, 49);
    self.callToActionLabel.frame = CGRectMake(w-174, 206,   174, 27);
    self.sponsoredByLabel.frame  = CGRectMake(    0, 212, w-180, 21);
    self.ratingLabel.frame       = CGRectMake(    0,  61,    58, 21);
    
    self.iconImageView.frame     = CGRectMake(    0,   0,    58, 58);
    self.mainImageView.frame     = CGRectMake(w-293,  83,   293, 115);
    
    self.privacyInformationIconImageView.frame = CGRectMake(w-30, 0, 30, 30);
}

- (void)layoutCustomAssetsWithProperties:(NSDictionary *)customProperties imageLoader:(MPNativeAdRenderingImageLoader *)imageLoader
{
    self.ratingLabel.text = customProperties[@"starrating"];
}

- (UILabel *)nativeMainTextLabel
{
    return self.mainTextLabel;
}

- (UILabel *)nativeTitleTextLabel
{
    return self.titleLabel;
}

- (UILabel *)nativeCallToActionTextLabel
{
    return self.callToActionLabel;
}

- (UILabel *)nativeSponsoredByCompanyTextLabel
{
    return self.sponsoredByLabel;
}

- (UIImageView *)nativeIconImageView
{
    return self.iconImageView;
}

- (UIImageView *)nativeMainImageView
{
    return self.mainImageView;
}

- (UIImageView *)nativePrivacyInformationIconImageView
{
    return self.privacyInformationIconImageView;
}

@end
