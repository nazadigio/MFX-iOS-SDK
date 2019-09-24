//
//  MFXNativeAd.h
//  MFXSDKCore
//
//  Created by ofirkariv on 02/06/2019.
//  Copyright © 2019 MobFox Mobile Advertising GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MFXNativeAd;

@protocol MFXNativeAdDelegate <NSObject>

@optional

- (void)nativeAdLoadFailed:(MFXNativeAd *_Nullable)native withError:(NSString*)error;
- (void)nativeAdLoaded:(MFXNativeAd *)native;
- (void)nativeAdImagesReady:(MFXNativeAd *)native;
- (void)nativeAdClicked:(MFXNativeAd *)native;

@end

@interface MFXNativeAd : NSObject

@property (nonatomic, readonly) id <MFXNativeAdDelegate> delegate;

- (void)loadNativeAd;

- (void)loadNativeAdImages;

- (void)registerNativeAdForInteraction:(UIView *)view;
- (void)callToActionClicked;

- (NSString *)getNativeAdLink;
- (NSDictionary *)getNativeAdTexts;
- (NSDictionary *)getNativeAdImageUrls;
- (NSDictionary *)getNativeAdImages;

- (void)setNativeAdContext:(NSString *)context;
- (void)setNativeAdPlacementType:(NSString *)placementType;

- (void)setNativeAdIconImage:(BOOL)required withSize:(NSInteger)size;
- (void)setNativeAdMainImage:(BOOL)required withSize:(CGSize)size;
- (void)setNativeAdTitle:(BOOL)required withMaxLen:(NSInteger)maxLen;
- (void)setNativeAdDesc:(BOOL)required withMaxLen:(NSInteger)maxLen;
- (void)setNativeFloorPrice:(NSNumber *)floorPrice;

- (void)releaseNativeAd __attribute((deprecated("Use [MobFoxSDK releaseNativeAd:ad] instead.")));

@end

NS_ASSUME_NONNULL_END
