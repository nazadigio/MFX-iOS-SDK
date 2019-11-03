//
//  MFXBannerAd.h
//  MFXSDKCore
//
//  Created by ofirkariv on 07/05/2019.
//  Copyright © 2019 MobFox Mobile Advertising GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class MFXBannerAd;

@protocol MFXBannerAdDelegate <NSObject>

@optional

- (void)bannerAdLoaded:(MFXBannerAd *)banner;
- (void)bannerAdLoadFailed:(MFXBannerAd * _Nullable)banner withError:(NSString*)error;
- (void)bannerAdShown:(MFXBannerAd *)banner;
- (void)bannerAdClicked:(MFXBannerAd *)banner;
- (void)bannerAdFinished:(MFXBannerAd *)banner;
- (void)bannerAdClosed:(MFXBannerAd *)banner;

@end

@interface MFXBannerAd : NSObject

//Public methods

@property (nonatomic, copy) NSString *invh;
@property (nonatomic, strong) NSNumber* mFloorPrice;


-(void) loadBanner;
-(void) addBannerViewToView:(UIView*)view atRect:(CGRect)rc;
-(void) addBannerViewToView:(UIView*)view centeredAt:(CGPoint)pt;
-(UIView*) getBannerAsView;
-(void) setBannerRefresh:(NSInteger)intervalInSeconds;
-(void) releaseBanner;
- (void)setBannerFloorPrice:(NSNumber *)floorPrice;

@end

NS_ASSUME_NONNULL_END
