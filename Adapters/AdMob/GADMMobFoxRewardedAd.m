//
//  GADMMobFoxRewardedAd.m
//  MFXTester
//
//  Created by Michael Kessler on 28/11/2019.
//  Copyright © 2019 MobFox Mobile Advertising GmbH. All rights reserved.
//

#import "GADMMobFoxRewardedAd.h"
#import <MFXSDKCore/MobFoxSDK.h>
#import <MFXSDKCore/MFXInterstitialAd.h>

@interface GADMMobFoxRewardedAd() <MFXInterstitialAdDelegate>
@property (nonatomic, strong) MFXInterstitialAd *rewardedAd;
@property (nonatomic, copy) GADMediationRewardedLoadCompletionHandler completionHandler;
@property (nonatomic, weak) id<GADMediationRewardedAdEventDelegate> delegate;
@end

@implementation GADMMobFoxRewardedAd

- (void)loadRewardedAdForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration
                       completionHandler:(GADMediationRewardedLoadCompletionHandler)completionHandler {
    self.completionHandler = completionHandler;
    NSString *adUnitID = [adConfiguration credentials].settings[@"parameter"];
    self.rewardedAd = [MobFoxSDK createInterstitial:adUnitID withRootViewContoller:nil withDelegate:self];
    self.rewardedAd.isRewarded = YES;
    [MobFoxSDK loadInterstitial:self.rewardedAd];
}

- (void)presentFromViewController:(nonnull UIViewController *)viewController {
    [MobFoxSDK showInterstitial:self.rewardedAd aboveViewController:viewController];
}

@end

@implementation GADMMobFoxRewardedAd (MFXInterstitialAdDelegate)

- (void)interstitialAdLoaded:(MFXInterstitialAd *)interstitial {
    self.delegate = self.completionHandler(self, nil);
    self.completionHandler = nil;
}

- (void)interstitialAdLoadFailed:(MFXInterstitialAd *_Nullable)interstitial withError:(NSString*)errorString {
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errorString};
    NSError *error = [NSError errorWithDomain:@"GADMMobFoxMediationAdapter" code:0 userInfo:userInfo];
    self.completionHandler(nil, error);
    self.completionHandler = nil;
}

- (void)interstitialAdShown:(MFXInterstitialAd *)interstitial {
    [self.delegate willPresentFullScreenView];
    [self.delegate reportImpression];
    [self.delegate didStartVideo];// TODO: Add a separate callback for this event?
}

- (void)interstitialAdClicked:(MFXInterstitialAd *)interstitial withUrl:(NSString*)url {
    [self.delegate reportClick];
}

- (void)interstitialAdFinished:(MFXInterstitialAd *)interstitial {
    // If reward is not defined in AdMob then an "empty reward" will be returned 
    GADAdReward *reward = [[GADAdReward alloc] initWithRewardType:@""
                                                     rewardAmount:[NSDecimalNumber decimalNumberWithString:@"1"]];
    [self.delegate didRewardUserWithReward:reward];
    [self.delegate didEndVideo];
}

- (void)interstitialAdClosed:(MFXInterstitialAd *)interstitial {
    [self.delegate didDismissFullScreenView];
}

@end
