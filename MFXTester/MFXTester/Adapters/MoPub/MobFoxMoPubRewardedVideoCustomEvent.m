//
//  MobFoxMoPubRewardedVideoCustomEvent.m
//  MFXTester
//
//  Created by Michael Kessler on 09/12/2019.
//  Copyright © 2019 MobFox Mobile Advertising GmbH. All rights reserved.
//

#import "MobFoxMoPubRewardedVideoCustomEvent.h"
#import <MFXSDKCore/MobFoxSDK.h>
#import <MFXSDKCore/MFXInterstitialAd.h>

@interface MobFoxMoPubRewardedVideoCustomEvent() <MFXInterstitialAdDelegate>
@property (nonatomic, strong) MFXInterstitialAd *rewardedAd;
@property (nonatomic, assign) BOOL isAdAvailable;
@end

@implementation MobFoxMoPubRewardedVideoCustomEvent

- (void)requestRewardedVideoWithCustomEventInfo:(NSDictionary *)info {
    NSString *adUnitID = info[@"invh"];
    if ([adUnitID isKindOfClass:[NSString class]]) {
        self.rewardedAd = [MobFoxSDK createInterstitial:adUnitID withRootViewContoller:nil withDelegate:self];
        self.rewardedAd.isRewarded = YES;
        [MobFoxSDK loadInterstitial:self.rewardedAd];
    }
}

- (BOOL)hasAdAvailable {
    return self.isAdAvailable;
}

- (void)presentRewardedVideoFromViewController:(UIViewController *)viewController {
    [MobFoxSDK showInterstitial:self.rewardedAd aboveViewController:viewController];
}

@end

@implementation MobFoxMoPubRewardedVideoCustomEvent (MFXInterstitialAdDelegate)

- (void)interstitialAdLoaded:(MFXInterstitialAd *)interstitial {
    self.isAdAvailable = YES;
    [self.delegate rewardedVideoDidLoadAdForCustomEvent:self];
}

- (void)interstitialAdLoadFailed:(MFXInterstitialAd *_Nullable)interstitial withError:(NSString *)errorString {
    self.isAdAvailable = NO;
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errorString};
    NSError *error = [NSError errorWithDomain:@"GADMMobFoxMediationAdapter" code:0 userInfo:userInfo];
    [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:error];
}

- (void)interstitialAdShown:(MFXInterstitialAd *)interstitial {
    [self.delegate rewardedVideoWillAppearForCustomEvent:self];
    [self.delegate rewardedVideoDidAppearForCustomEvent:self];
}

- (void)interstitialAdClicked:(MFXInterstitialAd *)interstitial withUrl:(NSString *)url {
    [self.delegate rewardedVideoDidReceiveTapEventForCustomEvent:self];
}

- (void)interstitialAdFinished:(MFXInterstitialAd *)interstitial {
    MPRewardedVideoReward *reward = [[MPRewardedVideoReward alloc] initWithCurrencyAmount:@(kMPRewardedVideoRewardCurrencyAmountUnspecified)];
    [self.delegate rewardedVideoShouldRewardUserForCustomEvent:self reward:reward];
}

- (void)interstitialAdClosed:(MFXInterstitialAd *)interstitial {
    [self.delegate rewardedVideoWillDisappearForCustomEvent:self];
    [self.delegate rewardedVideoDidDisappearForCustomEvent:self];
}

@end
