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

- (void)sampleFunc {
    
    //MFMediatedNativeContentAd_ *mediaContent = [[MFMediatedNativeContentAd_ alloc] init];
    //[mediaContent changeStatus];
}

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

/*
- (void)getNativeAdWithAdTypes:(NSArray *)adTypes options:(NSArray *)options {
    
    NSString *invh = [[self.connector credentials] objectForKey:@"pubid"];
    self.native = [[MobFoxNativeAd alloc] init:invh];
    self.native.delegate = self;
    [self.native loadAd];
    
}*/

//===============================================================

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
        
    //MFMediatedNativeContentAd_ *mediatedNativeContentAd = [[MFMediatedNativeContentAd_ alloc] initWithMFNativeContentAd:adData];
    // MFMediatedNativeContentAd_ *mediatedNativeContentAd = [[MFMediatedNativeContentAd_ alloc] init];
    // [self.delegate customEventNativeAd:self didReceiveMediatedNativeAd:mediatedNativeContentAd];
    
    
    //MFMediatedNativeContentAd_ *media = [[MFMediatedNativeContentAd_ alloc] init];
    //[media changeStatus];
    
    //MFMediatedNativeContentAd_ *media = [[MFMediatedNativeContentAd_ alloc] initWithMFNativeContentAd:nil];
    
    
    
}

- (void)nativeAdImagesReady:(MFXNativeAd *)native
{
}

- (void)nativeAdClicked:(MFXNativeAd *)native
{
}



/*

//called when ad response is returned
- (void)MobFoxNativeAdDidLoad:(MobFoxNativeAd *)ad withAdData:(MobFoxNativeData *)adData {
    
    NSLog(@"MobFox >> GADMNativeAdapterMobFox >> Native Ad Loaded");
    
    for (MobFoxNativeTracker *tracker in adData.trackersArray) {
        
        if ([tracker.url absoluteString].length > 0)
        {
            // Fire tracking pixel
            UIWebView* wv = [[UIWebView alloc] initWithFrame:CGRectZero];
            NSString* userAgent = [wv stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
            NSURLSessionConfiguration* conf = [NSURLSessionConfiguration defaultSessionConfiguration];
            conf.HTTPAdditionalHeaders = @{ @"User-Agent" : userAgent };
            NSURLSession* session = [NSURLSession sessionWithConfiguration:conf];
            NSURLSessionDataTask* task = [session dataTaskWithURL:tracker.url completionHandler:
                                          ^(NSData *data,NSURLResponse *response, NSError *error){
                                              
                                              if(error) NSLog(@"err %@",[error description]);
                                              
                                          }];
            [task resume];
            
        }
        
    }
    
    //MFMediatedNativeContentAd_ *mediatedNativeContentAd = [[MFMediatedNativeContentAd_ alloc] initWithMFNativeContentAd:adData];
   // MFMediatedNativeContentAd_ *mediatedNativeContentAd = [[MFMediatedNativeContentAd_ alloc] init];
   // [self.delegate customEventNativeAd:self didReceiveMediatedNativeAd:mediatedNativeContentAd];
    
    
    //MFMediatedNativeContentAd_ *media = [[MFMediatedNativeContentAd_ alloc] init];
    //[media changeStatus];
    
    //MFMediatedNativeContentAd_ *media = [[MFMediatedNativeContentAd_ alloc] initWithMFNativeContentAd:nil];

    
    
    
}

//called when ad response cannot be returned
- (void)MobFoxNativeAdDidFailToReceiveAdWithError:(NSError *)error {
    
    NSLog(@"MobFox >> GADMNativeAdapterMobFox >> DidFailToReceiveAdWithError: %@", [error description]);
        
    [self.delegate customEventNativeAd:self didFailToLoadWithError:error];

}
*/

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
