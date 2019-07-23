//
//  MFXBannerInner.h
//  MFXSDKCore
//
//  Created by ofirkariv on 02/06/2019.
//  Copyright © 2019 MobFox Mobile Advertising GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFXWebView.h"

NS_ASSUME_NONNULL_BEGIN

@class MFXBannerInner;

@protocol MFXBannerInnerDelegate <NSObject>

@optional

- (void)bannerAdLoaded:(MFXBannerInner *)banner;
- (void)bannerAdLoadFailed:(MFXBannerInner * _Nullable)banner withError:(NSString*)error;
- (void)bannerAdShown:(MFXBannerInner *)banner;
- (void)bannerAdClicked:(MFXBannerInner *)banner;
- (void)bannerAdFinished:(MFXBannerInner *)banner;
- (void)bannerAdClosed:(MFXBannerInner *)banner;

@end

@interface MFXBannerInner : NSObject <MFXWebViewAdDelegate>

@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *invh;
@property (nonatomic, copy) NSNumber* adspace_width;
@property (nonatomic, copy) NSNumber* adspace_height;
@property (nonatomic) double cpm;
@property (nonatomic) BOOL wvIsLoaded;

// changed to weak
@property (nonatomic, weak) id <MFXBannerInnerDelegate> delegate;

@property (nonatomic, assign) BOOL      gdpr;
@property (nonatomic, strong) NSString* gdpr_consent;

-(instancetype) initWithHash:(NSString *)invh
                       width:(NSInteger)width
                      height:(NSInteger)height
                withDelegate:(id <MFXBannerInnerDelegate>)delegate;
- (void)addBannerViewToView:(UIView*)targetView atRect:(CGRect)rc;
- (void)addBannerViewToView:(UIView*)targetView centeredAt:(CGPoint)pt;
- (void)loadBanner;
- (void)setAppRefreshRate:(NSInteger)intervalInSeconds;
- (NSInteger)getAppRefreshRate;

- (void)triggerRefreshIn:(NSInteger)intervalInSeconds;

- (void)closeBannerAd;
- (void)killBannerAd;

- (void)pausePlay;
- (void)resumePlay;

- (NSString *)getUUID;
- (NSString *)getINVH;
- (NSString *)getType;
- (NSInteger)getAdWidth;
- (NSInteger)getAdHeight;

- (UIView*)getBannerAsView;

- (void)setBannerFloorPrice:(NSNumber*)floorPrice;
- (NSNumber*)getBannerFloorPrice;

- (void)setTagHTML:(nonnull NSString*)html
          response:(NSString*)resp
   completionBlock:(void(^)(NSString* result, NSError *error))completionBlock;

- (void)callTagFunc:(NSString*)funcName
             params:(NSString*)paramsJsonStr
    completionBlock:(void(^)(NSString* result, NSError *error))completionBlock;
@end

NS_ASSUME_NONNULL_END
