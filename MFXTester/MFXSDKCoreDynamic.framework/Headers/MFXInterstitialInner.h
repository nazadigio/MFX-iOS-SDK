//
//  MFXInterstitialInner.h
//  MFXSDKCore
//
//  Created by ofirkariv on 02/06/2019.
//  Copyright © 2019 MobFox Mobile Advertising GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFXWebView.h"

NS_ASSUME_NONNULL_BEGIN

@class MFXInterstitialInner;

@protocol MFXInterstitialInnerDelegate <NSObject>
    
@optional



- (void)interstitialAdLoaded:(MFXInterstitialInner *)interstitial;
- (void)interstitialAdLoadFailed:(MFXInterstitialInner * _Nullable)interstitial withError:(NSString*)error;
- (void)interstitialAdShown:(MFXInterstitialInner *)interstitial;
- (void)interstitialAdClicked:(MFXInterstitialInner *)interstitial withUrl:(NSString*)url;
- (void)interstitialAdFinished:(MFXInterstitialInner *)interstitial;
- (void)interstitialAdClosed:(MFXInterstitialInner *)interstitial;
    
@end

@interface MFXInterstitialInner : NSObject

@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *invh;
@property (nonatomic, copy) NSNumber* adspace_width;
@property (nonatomic, copy) NSNumber* adspace_height;
@property (nonatomic, copy) NSDictionary* response;
@property (nonatomic, assign) BOOL      gdpr;
@property (nonatomic, strong) NSString* gdpr_consent;

@property (nonatomic, weak  ) id <MFXInterstitialInnerDelegate> delegate;
@property (nonatomic, strong) UIViewController *rootViewController;

-(instancetype)initWithHash:(NSString *)invh
      withRootViewContoller:(UIViewController*)root
               withDelegate:(id <MFXInterstitialInnerDelegate>)delegate;
-(void)loadInterstitial;
-(void)showInterstitial;
-(void)showInterstitialAboveViewController:(UIViewController*)parentVC;

- (NSInteger)getAdWidth;
- (NSInteger)getAdHeight;

- (NSString *)getUUID;
- (NSString *)getINVH;

- (void)closeInterstitialAd;
- (void)killInterstitialAd;

- (void)setInterstitialFloorPrice:(NSNumber*)floorPrice;
- (NSNumber*)getInterstitialFloorPrice;

@end

NS_ASSUME_NONNULL_END
