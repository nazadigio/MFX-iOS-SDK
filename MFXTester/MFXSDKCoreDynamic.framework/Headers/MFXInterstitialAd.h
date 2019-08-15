//
//  MFXInterstitialAd.h
//  MFXSDKCore
//
//  Created by ofirkariv on 02/06/2019.
//  Copyright © 2019 MobFox Mobile Advertising GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class MFXInterstitialAd;

@protocol MFXInterstitialAdDelegate <NSObject>

@optional

- (void)interstitialAdLoaded:(MFXInterstitialAd *)interstitial;
- (void)interstitialAdLoadFailed:(MFXInterstitialAd *_Nullable)interstitial withError:(NSString*)error;
- (void)interstitialAdShown:(MFXInterstitialAd *)interstitial;
- (void)interstitialAdClicked:(MFXInterstitialAd *)interstitial withUrl:(NSString*)url;
- (void)interstitialAdFinished:(MFXInterstitialAd *)interstitial;
- (void)interstitialAdClosed:(MFXInterstitialAd *)interstitial;

@end

@interface MFXInterstitialAd : NSObject 

-(instancetype)initWithHash:(NSString *)invh
      withRootViewContoller:(UIViewController*)root
               withDelegate:(id <MFXInterstitialAdDelegate>)delegate;
-(void)loadInterstitial;
-(void)showInterstitial;
-(void)showInterstitialAboveViewController:(UIViewController*)parentVC;
-(void)releaseInterstitial;
- (void)setInterstitialFloorPrice:(NSNumber *)floorPrice;

@end

NS_ASSUME_NONNULL_END
