//
//  GADMAdapterMobFox.m
//  DemoApp
//
//  Created by Shimi Sheetrit on 6/22/16.
//  Copyright © 2016 Matomy Media Group Ltd. All rights reserved.
//

#import "GADMAdapterMobFox.h"
#import "MFAdNetworkExtras.h"

@interface GADMAdapterMobFox()
@property (nonatomic, assign) BOOL smart;
@end

@implementation GADMAdapterMobFox

#pragma mark GADMAdNetworkAdapter Delegate

+ (NSString *)adapterVersion {
    return [MobFoxSDK sdkVersion];
}

+ (Class<GADAdNetworkExtras>)networkExtrasClass {
    return [MFAdNetworkExtras class];
}


- (id)initWithGADMAdNetworkConnector:(id<GADMAdNetworkConnector>)c {
    if ((self = [super init])) {
        _connector = c;
    }
    return self;
}

- (void)getBannerWithSize:(GADAdSize)adSize {
    
    self.smart = NO;
    NSLog(@"MobFox >> GADMAdapterMobFox >> Got Ad Request");
    
    NSString *invh = [[self.connector credentials] objectForKey:@"pubid"];

    //The adapter should fail immediately if the adSize is not supported
    if (GADAdSizeEqualToSize(adSize, kGADAdSizeBanner) ||
        GADAdSizeEqualToSize(adSize, kGADAdSizeMediumRectangle) ||
        GADAdSizeEqualToSize(adSize, kGADAdSizeFullBanner) ||
        GADAdSizeEqualToSize(adSize, kGADAdSizeLeaderboard)) {
        /**/
        
        self.banner = [MobFoxSDK createBanner:invh
                                        width:adSize.size.width
                                       height:adSize.size.height
                                 withDelegate:self];
        if (self.banner!=nil)
        {
            [self SetExtraGlobalParams];
            [self SetExtraBannerParams];
            
            [MobFoxSDK setBannerRefresh:self.banner withSeconds:0];
            
            [MobFoxSDK loadBanner:self.banner];
        }
        return;
    }
    
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(GADAdSizeEqualToSize(adSize, kGADAdSizeSmartBannerPortrait) && UIInterfaceOrientationIsPortrait(interfaceOrientation)){
        float width = 320.0f;
        float height = 50.0f;
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
            width = 728.0f;
            height = 90.0f;
        }

        
        self.banner = [MobFoxSDK createBanner:invh
                                        width:width
                                       height:height
                                 withDelegate:self];
        if (self.banner!=nil)
        {
            [self SetExtraGlobalParams];
            [self SetExtraBannerParams];
            
            [MobFoxSDK setBannerRefresh:self.banner withSeconds:0];
            
            [MobFoxSDK loadBanner:self.banner];
        }

        self.smart = YES;
        return;
    }
            
    NSString *errorDesc =
    [NSString stringWithFormat:@"Invalid ad type %@.",NSStringFromGADAdSize(adSize)];
    NSLog(@"MobFox >> GADAdapterMobFox: %@",errorDesc);
            
    NSDictionary *errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:errorDesc, NSLocalizedDescriptionKey, nil];
    NSError *error = [NSError errorWithDomain:kGADErrorDomain
                            code:kGADErrorMediationInvalidAdSize
                            userInfo:errorInfo];
    [self.connector adapter:self didFailAd:error];
}

- (void)getInterstitial {
    
    NSLog(@"MobFox >> GADMAdapterMobFox >> Got Interstitial Ad Request");

    NSString *invh = [[self.connector credentials] objectForKey:@"pubid"];
    
    //NSNumber* childDirectedTreatment = self.connector.childDirectedTreatment;
    //NSNumber* underAgeOfConsent      = self.connector.underAgeOfConsent;
    
    self.interstitial = [MobFoxSDK createInterstitial:invh
                                withRootViewContoller:nil
                                         withDelegate:self];
    
    if (self.interstitial!=nil)
    {
        [self SetExtraGlobalParams];
        [self SetExtraInterstitialParams];

        [MobFoxSDK loadInterstitial:self.interstitial];
    }
}

- (void)presentInterstitialFromRootViewController:(UIViewController *)rootViewController
{    
    NSLog(@"MobFox >> GADMAdapterMobFox >> Got Display Request");
    
    [MobFoxSDK showInterstitial:self.interstitial aboveViewController:rootViewController];
}

- (BOOL)isBannerAnimationOK:(GADMBannerAnimationType)animType {
    
    return YES;
}

//===============================================================

- (void)SetExtraBannerParams
{
    MFAdNetworkExtras *extras = [self.connector networkExtras];
    if (extras!=nil)
    {
        if (extras.floor_price!=nil)
        {
            [MobFoxSDK setBannerFloorPrice:self.banner withValue:extras.floor_price];
        }
    }
}

- (void)SetExtraInterstitialParams
{
    MFAdNetworkExtras *extras = [self.connector networkExtras];
    if (extras!=nil)
    {
        if (extras.floor_price!=nil)
        {
            [MobFoxSDK setInterstitialFloorPrice:self.interstitial withValue:extras.floor_price];
        }
    }
}

- (void)SetExtraGlobalParams
{
    if (self.connector.userKeywords!=nil)
    {
        NSString* keywordsString = [self.connector.userKeywords componentsJoinedByString:@","];
        [MobFoxSDK setDemoKeywords:keywordsString];
    }
    
    if (self.connector.userHasLocation)
    {
        [MobFoxSDK setLatitude: [NSNumber numberWithFloat:self.connector.userLatitude]];
        [MobFoxSDK setLongitude:[NSNumber numberWithFloat:self.connector.userLongitude]];
    }
    
    NSNumber *coppa = self.connector.childDirectedTreatment;
    if (coppa != nil) {
        [MobFoxSDK setCoppa:[coppa boolValue]];
    }
    
    MFAdNetworkExtras *extras = [self.connector networkExtras];
    if (extras!=nil)
    {
        if (extras.demo_gender!=nil)
        {
            [MobFoxSDK setDemoGender:extras.demo_gender];
        }
        if (extras.demo_age!=nil)
        {
            [MobFoxSDK setDemoAge:extras.demo_age];
        }
    }
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

//===============================================================

#pragma mark MobFox Ad Delegate

- (void)bannerAdLoaded:(MFXBannerAd *)banner
{
    UIViewController *vc = [self topViewController];
    NSLog(@"MobFox >> GADMAdapterMobFox >> Got Ad");
    UIView* bannerView = nil;
    
    if (banner!=nil)
    {
        bannerView = [MobFoxSDK getBannerAsView:banner];
        if (bannerView!=nil)
        {
            if(self.smart) {
                CGPoint ptCenter = bannerView.center;
                CGFloat w = [UIScreen mainScreen].bounds.size.width;
                bannerView.center = CGPointMake(w/2, ptCenter.y);
            }
        }
    }
    [MobFoxSDK addBanner:banner toView:vc.view atRect:bannerView.frame];
    [self.connector adapter:self didReceiveAdView:bannerView];
}

- (void)bannerAdLoadFailed:(MFXBannerAd * _Nullable)banner withError:(NSString*)error
{
    NSLog(@"MobFox >> GADMAdapterMobFox >> Error: %@",[error description]);
    
    NSString *domain = @"com.mobfox.mfxsdkcore.ErrorDomain";
    NSDictionary *userInfo = [[NSDictionary alloc]
                              initWithObjectsAndKeys:error,
                              @"NSLocalizedDescriptionKey",NULL];
    NSError* resError = [NSError errorWithDomain:domain
                                            code:-101
                                        userInfo:userInfo];
    
    [self.connector adapter:self didFailAd:resError];
}

- (void)bannerAdShown:(MFXBannerAd *)banner
{
}

- (void)bannerAdClicked:(MFXBannerAd *)banner
{
    [self.connector adapterWillPresentFullScreenModal:self];
    [self.connector adapterDidGetAdClick:self];
    //[self.connector adapterWillLeaveApplication:self];
}

- (void)bannerAdFinished:(MFXBannerAd *)banner
{
    
}

- (void)bannerAdClosed:(MFXBannerAd *)banner
{
    
}

//===============================================================

#pragma mark MobFox Interstitial Ad Delegate

- (void)interstitialAdLoaded:(MFXInterstitialAd *)interstitial
{
    NSLog(@"MobFox >> GADMAdapterMobFox >> Interstitial Ad Loaded");
    
    [self.connector adapterDidReceiveInterstitial:self];
}

- (void)interstitialAdLoadFailed:(MFXInterstitialAd *_Nullable)interstitial withError:(NSString*)error
{
    NSLog(@"MobFox >> GADMAdapterMobFox >> Interstitial Ad Load Error: %@",[error description]);
    
    NSString *domain = @"com.mobfox.mfxsdkcore.ErrorDomain";
    NSDictionary *userInfo = [[NSDictionary alloc]
                              initWithObjectsAndKeys:error,
                              @"NSLocalizedDescriptionKey",NULL];
    NSError* resError = [NSError errorWithDomain:domain
                                            code:-101
                                        userInfo:userInfo];

    [self.connector adapter:self didFailAd:resError];
}

- (void)interstitialAdShown:(MFXInterstitialAd *)interstitial
{
    NSLog(@"MobFox >> GADMAdapterMobFox >> Interstitial Ad will show");
    [self.connector adapterWillPresentInterstitial:self];
}

- (void)interstitialAdClicked:(MFXInterstitialAd *)interstitia withUrl:(NSString*)url
{
    NSLog(@"MobFox >> GADMAdapterMobFox >> Interstitial Ad Clicked");
    [self.connector adapterWillPresentFullScreenModal:self];
    [self.connector adapterDidGetAdClick:self];
    [self.connector adapterWillLeaveApplication:self];
}

- (void)interstitialAdFinished:(MFXInterstitialAd *)interstitial
{
    
}

- (void)interstitialAdClosed:(MFXInterstitialAd *)interstitial
{
    NSLog(@"MobFox >> GADMAdapterMobFox >> Interstitial Ad Closed");
    [self.connector adapterDidDismissInterstitial:self];
}

//===============================================================

- (void)stopBeingDelegate
{
}


@end
