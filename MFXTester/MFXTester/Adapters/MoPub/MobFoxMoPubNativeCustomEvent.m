//
//  MobFoxMoPubNativeCustomEvent.m
//  DemoApp
//
//  
//  Copyright © 2019 MobFox. All rights reserved.
//

#import "MobFoxMoPubCustomAdapter.h"
#import "MobFoxMoPubNativeCustomEvent.h"
#import "MobFoxMoPubUtils.h"



@implementation MobFoxMoPubNativeCustomEvent


- (void)requestAdWithCustomEventInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup
{
    [self requestAdWithCustomEventInfo:info];
}

- (void)requestAdWithCustomEventInfo:(NSDictionary *)info{
    
        if (!info) {
            NSLog(@"MobFoxMoPubNativeCustomEvent - empty info!");
            if(info[@"invh"]){
                _adUnit = info[@"invh"];
                
                NSLog(@"%@", _adUnit);
            }
            [self requestDidFail];
            return;
        }


    self.ad = [MobFoxSDK createNativeAd:[info valueForKey:@"invh"] withDelegate:self];
    if(self.localExtras){
        //Demographics params should be set in you viewcontoller, under <<MPNativeAd object>>.localExtras
        NSString *demo_age = self.localExtras[@"demo_age"];
        if(demo_age){
            [MobFoxSDK setDemoAge:demo_age];
        }
        NSString *demo_gender = self.localExtras[@"demo_gender"];
        if(demo_gender){
            [MobFoxSDK setDemoGender:demo_gender];
        }
    }
    
    
    NSLog(@"MoPub >> MobFox >> request: %@",[info description]);
    
    [MobFoxMoPubUtils gdprHandler];
    [MobFoxSDK loadNativeAd:self.ad];
}



- (void)requestDidFail {
    NSError *error = [[NSError alloc] initWithDomain:@"com.mopub.NativeCustomEvent" code:901 userInfo:nil];
    [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:error];
    
}


/* MobFox Native delegated */

// Native delegate "nativeAdLoaded" is called after the native text is ready, when "nativeAdImagesReady" is called after everything is ready.

- (void)nativeAdLoaded:(MFXNativeAd *)native{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[native getNativeAdTexts]];
    [dic addEntriesFromDictionary:[native getNativeAdImageUrls]];
    NSString *clickURL = [native getNativeAdLink];
    [dic setObject:clickURL forKey:@"url"];
    MobFoxMoPubCustomAdapter *mfAdapter = [[MobFoxMoPubCustomAdapter alloc] initWithAd:dic];
    MPNativeAd *mpAd = [[MPNativeAd alloc] initWithAdAdapter:mfAdapter];
    
    [self.delegate nativeCustomEvent:self didLoadAd:mpAd];
    
}


- (void)nativeAdImagesReady:(MFXNativeAd *)native{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[native getNativeAdTexts]];
    [dic addEntriesFromDictionary:[native getNativeAdImageUrls]];
    NSString *clickURL = [native getNativeAdLink];
    [dic setObject:clickURL forKey:@"url"];
    MobFoxMoPubCustomAdapter *mfAdapter = [[MobFoxMoPubCustomAdapter alloc] initWithAd:dic];
    MPNativeAd *mpAd = [[MPNativeAd alloc] initWithAdAdapter:mfAdapter];

    [self.delegate nativeCustomEvent:self didLoadAd:mpAd];
}

- (void)nativeAdLoadFailed:(MFXNativeAd *)native withError:(NSString *)error{
    NSLog(@"MoPub native >> MobFox >> ad error: %@",[error description]);
    
    NSString *domain = @"com.mobfox.mfxsdkcore.ErrorDomain";
    NSDictionary *userInfo = [[NSDictionary alloc]
                              initWithObjectsAndKeys:error,
                              @"NSLocalizedDescriptionKey",NULL];
    NSError* resError = [NSError errorWithDomain:domain
                                            code:-101
                                        userInfo:userInfo];
    
    MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:(NSString *)self.class error:resError], _adUnit);
    
    [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:resError];
    
}

- (void)nativeAdClicked:(MFXNativeAd *)native{
    
    NSLog(@"MoPub native >> MobFox >> clicked");
}




- (UIViewController *) topViewController {
    UIViewController *baseVC = UIApplication.sharedApplication.keyWindow.rootViewController;
    if ([baseVC isKindOfClass:[UINavigationController class]]) {
        return ((UINavigationController *)baseVC).visibleViewController;
    }
    
    if ([baseVC isKindOfClass:[UITabBarController class]]) {
        UIViewController *selectedTVC = ((UITabBarController*)baseVC).selectedViewController;
        if (selectedTVC) {
            return selectedTVC;
        }
    }
    
    if (baseVC.presentedViewController) {
        return baseVC.presentedViewController;
    }
    return baseVC;
}

@end
