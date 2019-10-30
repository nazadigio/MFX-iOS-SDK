//
//  GADMNativeAdapterMobFox.m
//  Adapters
//
//  Created by Shimi Sheetrit on 12/7/16.
//  Copyright © 2016 Matomy Media Group Ltd. All rights reserved.
//

#import "GADMNativeAdapterMobFox.h"


@implementation GADMNativeAdapterMobFox

#pragma mark GADMAdNetworkAdapter Delegate


+ (NSString *)adapterVersion {
    
    return [MobFoxSDK sdkVersion];
}

+ (Class<GADAdNetworkExtras>)networkExtrasClass {
    
    return nil;
}

- (id)initWithGADMAdNetworkConnector:(id<GADMAdNetworkConnector>)c {
    if ((self = [super init])) {
        _connector = c;
    }
    return self;
}

- (void)requestNativeAdWithParameter:(NSString *)serverParameter
                             request:(GADCustomEventRequest *)request
                             adTypes:(NSArray *)adTypes
                             options:(NSArray *)options
                  rootViewController:(UIViewController *)rootViewController {
    
    NSLog(@"MobFox >> GADMNativeAdapterMobFox >> Got Native Ad Request");

    self.native = [MobFoxSDK createNativeAd:serverParameter
                               withDelegate:self];
    
    if (self.native!=nil)
    {
        [MobFoxSDK loadNativeAd:self.native];
    }
    
    //MFMediatedNativeContentAd_ *media = [[MFMediatedNativeContentAd_ alloc] initWithMFNativeContentAd:nil];
    
}

#pragma mark MobFox Native Ad Delegate

- (void)nativeAdLoadFailed:(MFXNativeAd *_Nullable)native withError:(NSString*)error
{
    NSLog(@"MobFox >> GADMNativeAdapterMobFox >> DidFailToReceiveAdWithError: %@", [error description]);
    
    NSString *domain = @"com.mobfox.mfxsdkcore.ErrorDomain";
    NSDictionary *userInfo = [[NSDictionary alloc]
                              initWithObjectsAndKeys:error,
                              @"NSLocalizedDescriptionKey",NULL];
    NSError* resError = [NSError errorWithDomain:domain
                                            code:-101
                                        userInfo:userInfo];

    [self.delegate customEventNativeAd:self didFailToLoadWithError:resError];
}

- (void)nativeAdLoaded:(MFXNativeAd *)native
{
    NSLog(@"MobFox >> GADMNativeAdapterMobFox >> Native Ad Loaded");
    
}

- (void)nativeAdImagesReady:(MFXNativeAd *)native
{
}

- (void)nativeAdClicked:(MFXNativeAd *)native
{
}



#pragma mark GADCustomEventNativeAd Delegate

- (BOOL)handlesUserClicks {
    
    return YES;
    
}

- (BOOL)handlesUserImpressions {
    
    return YES;

}

- (void)getBannerWithSize:(GADAdSize)adSize {
    
}


- (void)getInterstitial {
    
}


- (void)presentInterstitialFromRootViewController:(UIViewController *)rootViewController {
    
}


- (void)stopBeingDelegate {
    
}


@synthesize delegate;

@end
