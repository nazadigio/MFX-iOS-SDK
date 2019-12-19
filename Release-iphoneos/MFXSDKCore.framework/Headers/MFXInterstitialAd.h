//
//  MFXInterstitialAd.h
//  MFXSDKCore
//
//  Created by ofirkariv on 02/06/2019.
//  Copyright © 2019 MobFox Mobile Advertising GmbH. All rights reserved.
//

#import "MFXFullScreenAd.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFXInterstitialAd : MFXFullScreenAd

@property (nonatomic, assign) BOOL isRewarded;

@end

@protocol MFXInterstitialAdDelegate <NSObject>

@optional

- (void)interstitialAdLoaded:(MFXInterstitialAd *)interstitial;
- (void)interstitialAdLoadFailed:(MFXInterstitialAd *_Nullable)interstitial withError:(NSString*)error;
- (void)interstitialAdShown:(MFXInterstitialAd *)interstitial;
- (void)interstitialAdClicked:(MFXInterstitialAd *)interstitial withUrl:(NSString*)url;
- (void)interstitialAdFinished:(MFXInterstitialAd *)interstitial;
- (void)interstitialAdClosed:(MFXInterstitialAd *)interstitial;

@end

#pragma mark - Deprecated

@interface MFXInterstitialAd (Deprecated)

- (void)loadInterstitial __deprecated_msg("Use [MobFoxSDK loadInterstitial:] instead");
- (void)showInterstitial __deprecated_msg("Use [MobFoxSDK showInterstitial:] instead");
- (void)showInterstitialAboveViewController:(UIViewController *)parentVC __deprecated_msg("Use [MobFoxSDK showInterstitial:aboveViewController:] instead");
- (void)releaseInterstitial __deprecated_msg("Use [MobFoxSDK releaseInterstitial:] instead");
- (void)setInterstitialFloorPrice:(NSNumber *)floorPrice __deprecated_msg("Use [MobFoxSDK setInterstitialFloorPrice:] instead");

@end

NS_ASSUME_NONNULL_END
