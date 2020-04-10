//
//  GADMNativeAdapterMobFox.m
//  Adapters
//
//  Created by Shimi Sheetrit on 12/7/16.
//  Copyright © 2016 Matomy Media Group Ltd. All rights reserved.
//

#import "GADMNativeAdapterMobFox.h"
#import "MFMediatedNativeContentAd.h"

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

    self.mfNative = [MobFoxSDK createNativeAd:serverParameter
                               withDelegate:self];
    
    if (self.mfNative != nil) {
        [MobFoxSDK loadNativeAd:self.mfNative];
    }
}

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
        
    [MobFoxSDK loadNativeAdImages:native];
}

- (void)nativeAdImagesReady:(MFXNativeAd *)native
{
    NSLog(@"MobFox >> GADMNativeAdapterMobFox >> Native Ad Images Loaded");
        
    MFMediatedNativeContentAd *ad = [[MFMediatedNativeContentAd alloc] initWithMFNativeContentAd:native];
        
    //[MobFoxSDK registerNativeAdForInteraction:native onView:_viewNative];

    [self.delegate customEventNativeAd:self didReceiveMediatedUnifiedNativeAd:ad];
}

- (void)nativeAdClicked:(MFXNativeAd *)native
{
    NSLog(@"MobFox >> GADMNativeAdapterMobFox >> Native Ad Clicked");
}

// Because the Sample SDK has click and impression tracking via
// methods on its native ad object which the developer is required
// to call, there's no need to pass it a reference to the UIView
// being used to display the native ad. So there's no need to
// implement mediatedNativeAd:didRenderInView:viewController:clickableAssetViews:nonClickableAssetViews
// here. If your mediated network does need a reference to the view,
// this method can be used to provide one. You can also access the
// clickable and non-clickable views by asset key if the mediation
// network needs this information.
- (void)didRenderInView:(UIView *)view
    clickableAssetViews:(NSDictionary<GADUnifiedNativeAssetIdentifier, UIView *> *)clickableAssetViews
 nonclickableAssetViews:(NSDictionary<GADUnifiedNativeAssetIdentifier, UIView *> *)nonclickableAssetViews
         viewController:(UIViewController *)viewController {
    // This method is called when the native ad view is rendered.
    // Here you would pass the UIView back to the mediated
    // network's SDK.
    // Playing video using SampleNativeAd's playVideo method
    //[_sampleAd playVideo];
    
    [MobFoxSDK registerNativeAdForInteraction:self.mfNative onView:view];
}

- (BOOL)handlesUserClicks {
    return NO;
}

- (BOOL)handlesUserImpressions {
    return NO;
}

- (void)getBannerWithSize:(GADAdSize)adSize {
}


- (void)getInterstitial {
}


- (void)presentInterstitialFromRootViewController:(UIViewController *)rootViewController {
}


- (void)stopBeingDelegate {
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

@synthesize delegate;

@end
