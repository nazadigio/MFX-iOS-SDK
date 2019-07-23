//
//  MobFoxSDK.h
//  MFXSDKCore
//
//  Created by ofirkariv on 23/04/2019.
//  Copyright © 2019 MobFox Mobile Advertising GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "MFXBannerAd.h"
#import "MFXInterstitialAd.h"
#import "MFXNativeAd.h"



NS_ASSUME_NONNULL_BEGIN

#define VIDEO_CACHE_PORT 12345
#define VIDEO_CACHE_FOLDER @"/MobFoxVideoCache"

#ifndef MFXLog
#ifdef DEBUG
#define MFXLog(_format_, ...) NSLog(_format_, ## __VA_ARGS__)
#else
#define MFXLog(_format_, ...)
#endif
#endif

// ----------------------------------------------------------------------

@interface MobFoxSDK : NSObject

FOUNDATION_EXPORT NSString *const kNativeAdContext_Content;
FOUNDATION_EXPORT NSString *const kNativeAdContext_Social;
FOUNDATION_EXPORT NSString *const kNativeAdContext_Product;

FOUNDATION_EXPORT NSString *const kNativeAdPlacementType_InFeed;
FOUNDATION_EXPORT NSString *const kNativeAdPlacementType_Atomic;
FOUNDATION_EXPORT NSString *const kNativeAdPlacementType_Outside;
FOUNDATION_EXPORT NSString *const kNativeAdPlacementType_Recommendation;

///////////////////////////
/*          SDK          */
///////////////////////////

+ (instancetype) sharedInstance;
+ (BOOL)isInitialized;

+ (void)setGDPR:(BOOL)bConsented;
+ (void)setGDPRConsentString:(NSString *)consentString;

+ (NSString*)sdkVersion;

+ (void)setDemoAge:(NSString *)demo_age;
+ (void)setDemoGender:(NSString *)demo_gender;
+ (void)setDemoKeywords:(NSString *)demo_keywords;

+ (void)setLongitude:(NSNumber *)longitude;
+ (void)setLatitude:(NSNumber *)latitude;

///////////////////////////
/*      BANNER          */
//////////////////////////

+(MFXBannerAd *)createBanner:(NSString *)invh
                       width:(NSInteger)width
                      height:(NSInteger)height
                withDelegate:(id <MFXBannerAdDelegate>)delegate;
+(void)loadBanner:(MFXBannerAd *)mAd;
+(void)addBanner:(MFXBannerAd*)mAd toView:(UIView*)targetView atRect:(CGRect)rc;
+(void)addBanner:(MFXBannerAd*)mAd toView:(UIView*)targetView centeredAt:(CGPoint)pt;
+(UIView*)getBannerAsView:(MFXBannerAd *)mAd;
+(void)setBannerRefresh:(MFXBannerAd *)mAd withSeconds:(NSInteger)intervalInSeconds;
+(void)releaseBanner:(MFXBannerAd *)mAd;
+(void)setBannerFloorPrice:(MFXBannerAd *)mAd withValue:(NSNumber *)floor;

///////////////////////////
/*      INTERSTITIAL     */
//////////////////////////
+(MFXInterstitialAd *)createInterstitial:(NSString *)invh
                   withRootViewContoller:(UIViewController* _Nullable)root
                            withDelegate:(id <MFXInterstitialAdDelegate>)delegate;
+(void)loadInterstitial:(MFXInterstitialAd *)mAd;
+(void)showInterstitial:(MFXInterstitialAd *)mAd;
+(void)showInterstitial:(MFXInterstitialAd *)mAd aboveViewController:(UIViewController*)parentVC;
+(void)releaseInterstitial:(MFXInterstitialAd *)mAd;
+(void)setInterstitialFloorPrice:(MFXInterstitialAd *)mAd withValue:(NSNumber *)floor;

///////////////////////////
/*      NATIVE_AD       */
//////////////////////////

+(MFXNativeAd *)createNativeAd:(NSString *)invh
                  withDelegate:(id <MFXNativeAdDelegate>)delegate;

+(void)loadNativeAd:(MFXNativeAd *)mAd;

+(void)loadNativeAdImages:(MFXNativeAd *)mAd;

+(void)registerNativeAdForInteraction:(MFXNativeAd *)mAd onView:(UIView*)view;
+(void)callToActionClicked:(MFXNativeAd *)mAd;

+(NSString*)getNativeAdLink:(MFXNativeAd *)mAd;
+(NSDictionary*)getNativeAdTexts:(MFXNativeAd *)mAd;
+(NSDictionary*)getNativeAdImageUrls:(MFXNativeAd *)mAd;
+(NSDictionary*)getNativeAdImages:(MFXNativeAd *)mAd;

+(void)setNativeAdContext:(MFXNativeAd *)mAd withContext:(NSString*)context;
+(void)setNativeAdPlacementType:(MFXNativeAd *)mAd withPlacementType:(NSString*)placementType;

+(void)setNativeAdIconImage:(MFXNativeAd *)mAd isRequired:(BOOL)required withSize:(NSInteger)size;
+(void)setNativeAdMainImage:(MFXNativeAd *)mAd isRequired:(BOOL)required withSize:(CGSize)size;
+(void)setNativeAdTitle:(MFXNativeAd *)mAd isRequired:(BOOL)required withMaxLen:(NSInteger)maxLen;
+(void)setNativeAdDesc:(MFXNativeAd *)mAd isRequired:(BOOL)required withMaxLen:(NSInteger)maxLen;
+(void)setNativeFloorPrice:(MFXInterstitialAd *)mAd withValue:(NSNumber *)floor;
+(void)releaseNativeAd:(MFXNativeAd *)mAd;


@end

NS_ASSUME_NONNULL_END
