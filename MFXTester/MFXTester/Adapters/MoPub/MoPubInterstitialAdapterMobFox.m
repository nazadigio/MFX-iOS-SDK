#import "MoPubInterstitialAdapterMobFox.h"
#import "MobFoxMoPubUtils.h"


@interface MoPubInterstitialAdapterMobFox()
    
@property (nonatomic, strong) NSString *adUnit;
@end

@implementation MoPubInterstitialAdapterMobFox

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info{

    _adUnit = @"";
    NSLog(@"MoPub inter >> MobFox >> init");
    NSLog(@"MoPub inter >> MobFox >> data: %@",[info description]);
    
    if(info[@"invh"]){
        _adUnit = info[@"invh"];
    }
    
    
    
    self.mobFoxInterAd = [MobFoxSDK createInterstitial:[info valueForKey:@"invh"]
                                 withRootViewContoller:nil
                                          withDelegate:self];
    
    if(self.localExtras){
        //Demographics params should be set in you viewcontoller, under <<MPInterstitialAdController object>>.localExtras
        NSString *demo_age = self.localExtras[@"demo_age"];
        if(demo_age){
            [MobFoxSDK setDemoAge:demo_age];
        }
        NSString *demo_gender = self.localExtras[@"demo_gender"];
        if(demo_gender){
            [MobFoxSDK setDemoGender:demo_gender];
        }
    }
    
    [MobFoxMoPubUtils gdprHandler];
    [MobFoxSDK loadInterstitial:self.mobFoxInterAd];
}

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController{
    NSLog(@"MoPub inter >> MobFox >> set root");
    MPLogInfo(@"MoPub inter >> MobFox >> set root");
    MPLogAdEvent([MPLogEvent adShowAttemptForAdapter:NSStringFromClass(self.class)], _adUnit);
     dispatch_async(dispatch_get_main_queue(), ^{
    [MobFoxSDK showInterstitial:self.mobFoxInterAd aboveViewController:rootViewController];
     });
}

/*
- (BOOL)enableAutomaticImpressionAndClickTracking
{
    // Subclasses may override this method to return NO to perform impression and click tracking
    // manually.
    return NO;
}
*/

//===============================================================

#pragma mark MobFox Interstitial Ad Delegate

- (void)interstitialAdLoaded:(MFXInterstitialAd *)interstitial
{
    self.mobFoxInterAd = interstitial;
    NSLog(@"MoPub inter >> MobFox >> ad loaded");
    MPLogAdEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)], @"");

    //[self.delegate trackImpression];
    dispatch_async(dispatch_get_main_queue(), ^{
    [self.delegate interstitialCustomEvent:self didLoadAd:interstitial];
    });
}

- (void)interstitialAdLoadFailed:(MFXInterstitialAd *_Nullable)interstitial withError:(NSString*)error
{
    NSLog(@"MoPub inter >> MobFox >> ad error: %@",[error description]);
    
    NSString *domain = @"com.mobfox.mfxsdkcore.ErrorDomain";
    NSDictionary *userInfo = [[NSDictionary alloc]
                              initWithObjectsAndKeys:error,
                              @"NSLocalizedDescriptionKey",NULL];
    NSError* resError = [NSError errorWithDomain:domain
                                            code:-101
                                        userInfo:userInfo];

    MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:(NSString *)self.class error:resError], _adUnit);

    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:resError];
}

- (void)interstitialAdShown:(MFXInterstitialAd *)interstitial
{
    MPLogAdEvent([MPLogEvent adShowSuccessForAdapter:(NSString *)self.class], _adUnit);
    [self.delegate interstitialCustomEventDidAppear:self];
}

- (void)interstitialAdClicked:(MFXInterstitialAd *)interstitial withUrl:(NSString*)url
{
    MPLogAdEvent([MPLogEvent adTappedForAdapter:NSStringFromClass(self.class)], _adUnit);
    [self.delegate trackClick];
    [self.delegate interstitialCustomEventWillLeaveApplication:self];
}

- (void)interstitialAdFinished:(MFXInterstitialAd *)interstitial
{
    
}

- (void)interstitialAdClosed:(MFXInterstitialAd *)interstitial
{
    MPLogAdEvent([MPLogEvent adWillDisappearForAdapter:(NSString *)self.class], _adUnit);
    [self.delegate interstitialCustomEventWillDisappear:self];
    MPLogAdEvent([MPLogEvent adDidDisappearForAdapter:(NSString *)self.class], _adUnit);
    [self.delegate interstitialCustomEventDidDisappear:self];
}

//===============================================================

- (void)dealloc {
    
    [MobFoxSDK releaseInterstitial:self.mobFoxInterAd];
    self.mobFoxInterAd = nil;    
}
 
@end
