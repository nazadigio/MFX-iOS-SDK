//
//  AdaptersViewController.m
//  MFXTester
//
//  Created by ofirkariv on 25/08/2019.
//  Copyright © 2019 MobFox Mobile Advertising GmbH. All rights reserved.
//

#import "AdaptersViewController.h"
#if __has_include(<MoPub/MoPub.h>)
#import <MoPub/MoPub.h>
#elif __has_include(<MoPubSDKFramework/MoPub.h>)
#import <MoPubSDKFramework/MoPub.h>
#endif
#import "MFAdNetworkExtras.h"
@import GoogleMobileAds;

@interface AdaptersViewController () <MPNativeAdDelegate, GADBannerViewDelegate, GADInterstitialDelegate, GADAdLoaderDelegate, GADUnifiedNativeAdLoaderDelegate, MPAdViewDelegate, MPInterstitialAdControllerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *adMobRewardedButtonLabel;

@property (strong, nonatomic) IBOutlet UIImageView *imgIcon;
@property (strong, nonatomic) IBOutlet UIImageView *imgMain;
@property (strong, nonatomic) IBOutlet UIButton *btnCTA;
@property (strong, nonatomic) IBOutlet UILabel *lblDesc;
@property (strong, nonatomic) IBOutlet UILabel *lblRating;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblSponsored;



@property(nonatomic, strong) GADBannerView *adMobBannerView;
@property(nonatomic, strong) GADInterstitial *adMobInterstitial;
@property(nonatomic, strong) GADAdLoader *adMobAdLoader;
@property(nonatomic, strong) GADUnifiedNativeAd *adMobNative;


@property (strong, nonatomic) MPAdView*       mMoPubBanner;
@property (strong, nonatomic) MPInterstitialAdController* mMoPubInterstitial;
@property (strong, nonatomic) MPNativeAd *nativeAd;


@end

@implementation AdaptersViewController
CGPoint adMobbannerCenterPoint;
//CGPoint adMobbannerCenterPoint;


- (void)viewDidLoad {
    [super viewDidLoad];
    _adMobRewardedButtonLabel.enabled = NO;
    // Do any additional setup after loading the view.
}

#define MOPUB_HASH_ADAPTER_BANNER @"234dd5a1b1bf4a5f9ab50431f9615784"
#define MOPUB_HASH_ADAPTER_INTER  @"a5277fa1fd57418b867cfaa949df3b4a"
#define MOPUB_HASH_ADAPTER_NATIVE @"97ea9854b278483bb455c899002a3f79"


#pragma MoPubBanner
// ###############################################################################
// #####   B A N N E R                                                       #####
// ###############################################################################

- (IBAction)moPubBanner:(id)sender {
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    
    self.mMoPubBanner = [[MPAdView alloc] initWithAdUnitId:MOPUB_HASH_ADAPTER_BANNER
                                                      size:MOPUB_BANNER_SIZE];
    self.mMoPubBanner.delegate = self;
    self.mMoPubBanner.frame = CGRectMake((w - MOPUB_BANNER_SIZE.width)/2, 140,
                                         MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"31", @"demo_age", @"m", @"demo_gender", nil];
    self.mMoPubBanner.localExtras = dic;
    [self.mMoPubBanner loadAd];
}

- (void)adViewDidLoadAd:(MPAdView *)view
{
    NSLog(@"MoPub BANNER: adViewDidLoadAd");
    [self.view addSubview:self.mMoPubBanner];
}

- (void)adView:(MPAdView *)view didFailToLoadAdWithError:(NSError *)error
{
    NSLog(@"MoPub BANNER: didFailToLoadAdWithError %@",[error localizedDescription]);
}

- (void)willPresentModalViewForAd:(MPAdView *)view
{
    NSLog(@"MoPub BANNER: willPresentModalViewForAd");
}

- (void)didDismissModalViewForAd:(MPAdView *)view
{
    NSLog(@"MoPub BANNER: didDismissModalViewForAd");
}

- (void)willLeaveApplicationFromAd:(MPAdView *)view
{
    NSLog(@"MoPub BANNER: willLeaveApplicationFromAd");
}

#pragma MoPubInterstitial
// ###############################################################################
// #####   I N T E R S T I T I A L                                           #####
// ###############################################################################

- (IBAction)moPubInterstitial:(id)sender {
    self.mMoPubInterstitial = [MPInterstitialAdController
                               interstitialAdControllerForAdUnitId:MOPUB_HASH_ADAPTER_INTER];
    self.mMoPubInterstitial.delegate = self;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"42", @"demo_age", @"f", @"demo_gender", nil];
    self.mMoPubInterstitial.localExtras = dic;
    // Fetch the interstitial ad.
    [self.mMoPubInterstitial loadAd];
}

// ==============================================================

- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial
{
    NSLog(@"MoPub INTERSTITIAL: interstitialDidLoadAd");
    
    if (self.mMoPubInterstitial.ready) [self.mMoPubInterstitial showFromViewController:self];
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial
{
    NSLog(@"MoPub INTERSTITIAL: interstitialDidFailToLoadAd");
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial
                          withError:(NSError *)error
{
    NSLog(@"MoPub INTERSTITIAL: interstitialDidFailToLoadAd: %@",error.localizedDescription);
}

- (void)interstitialWillAppear:(MPInterstitialAdController *)interstitial
{
    NSLog(@"MoPub INTERSTITIAL: interstitialWillAppear");
}

- (void)interstitialDidAppear:(MPInterstitialAdController *)interstitial
{
    NSLog(@"MoPub INTERSTITIAL: interstitialDidAppear");
}

- (void)interstitialWillDisappear:(MPInterstitialAdController *)interstitial
{
    NSLog(@"MoPub INTERSTITIAL: interstitialWillDisappear");
}

- (void)interstitialDidDisappear:(MPInterstitialAdController *)interstitial
{
    NSLog(@"MoPub INTERSTITIAL: interstitialDidDisappear");
}

- (void)interstitialDidExpire:(MPInterstitialAdController *)interstitial
{
    NSLog(@"MoPub INTERSTITIAL: interstitialDidExpire");
}

- (void)interstitialDidReceiveTapEvent:(MPInterstitialAdController *)interstitial
{
    NSLog(@"MoPub INTERSTITIAL: interstitialDidReceiveTapEvent");
}


#pragma MoPubNativeAd
// ###############################################################################
// #####   N A T I V E                                                       #####
// ###############################################################################

- (IBAction)moPubNativeAd:(id)sender {
    MPStaticNativeAdRendererSettings *settings = [[MPStaticNativeAdRendererSettings alloc] init];
    settings.renderingViewClass = [self.view class];
    MPNativeAdRendererConfiguration *config = [MPStaticNativeAdRenderer rendererConfigurationWithRendererSettings:settings];
    config.supportedCustomEvents = @[@"MobFoxMoPubNativeCustomEvent"];
    //NSString *strHash = @"11a17b188668469fb0412708c3d16813";
    NSString *strHash = @"97ea9854b278483bb455c899002a3f79";
    MPNativeAdRequest *adRequest = [MPNativeAdRequest requestWithAdUnitIdentifier:strHash rendererConfigurations:@[config]];
    MPNativeAdRequestTargeting *targeting = [MPNativeAdRequestTargeting targeting];
    targeting.desiredAssets = [NSSet setWithObjects:kAdTitleKey, kAdTextKey, kAdCTATextKey, kAdIconImageKey, kAdMainImageKey, kAdStarRatingKey, nil];
    targeting.keywords = @"marital:single,age:27";
    targeting.location = [[CLLocation alloc] initWithLatitude:34.1212 longitude:32.1212];
    adRequest.targeting = targeting;
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"27", @"demo_age", nil];
    adRequest.targeting.localExtras = dic;
    __weak AdaptersViewController *weakself = self;
    [adRequest startWithCompletionHandler:^(MPNativeAdRequest *request, MPNativeAd *response, NSError *error) {
        if (error) {
            NSLog(@"%@",[error description]); // Handle error.
        }
        else{
            NSDictionary *propertiesDict = response.properties;
            __strong AdaptersViewController *strongself = weakself;
            [self UpdateNativeText:strongself.lblTitle     withValue:[propertiesDict objectForKey:kAdTitleKey]];
            [self UpdateNativeText:strongself.lblDesc      withValue:[propertiesDict objectForKey:kAdTextKey]];
            [self UpdateNativeText:strongself.lblRating    withValue:[propertiesDict objectForKey:kAdStarRatingKey]];
            [self UpdateNativeButton:strongself.btnCTA     withValue:[propertiesDict objectForKey:kAdCTATextKey]];
            [self UpdateNativeImage:strongself.imgMain withImageURL:[propertiesDict objectForKey:kAdMainImageKey]];
            
            
            
            self.nativeAd = response;
            self.nativeAd.delegate = self;
            UIView *nativeAdView = [response retrieveAdViewWithError:nil];
            nativeAdView.frame = CGRectMake(0, 0, 400, 500);
            [self.view addSubview:nativeAdView];
        }}];
    

}

//###########################################################################################
//###########################################################################################
//#####                                                                                 #####
//#####   A d M o b                                                                     #####
//#####                                                                                 #####
//###########################################################################################
//###########################################################################################

#define ADMOB_HASH_BANNER_HTML  @"ca-app-pub-6224828323195096/5240875564"
#define ADMOB_HASH_INTER_HTML   @"ca-app-pub-6224828323195096/7876284361"
#define ADMOB_HASH_INTER_VIDEO  @"ca-app-pub-6224828323195096/7876284361"
#define ADMOB_HASH_NATIVE       @"ca-app-pub-6224828323195096/6049137964"


#pragma adMobBanner
// ###############################################################################
// #####   B A N N E R                                                       #####
// ###############################################################################


- (IBAction)adMobBanner:(id)sender {
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    adMobbannerCenterPoint = CGPointMake(w/2,140);
    [self startAdMobBannerWithSize:kGADAdSizeBanner];
    
}

- (void)startAdMobBannerWithSize:(GADAdSize)size
{
    
    self.adMobBannerView = [[GADBannerView alloc] initWithAdSize:size];
    
    [self.view addSubview:self.adMobBannerView];
    
    self.adMobBannerView.center = adMobbannerCenterPoint;
    
    self.adMobBannerView.adUnitID = ADMOB_HASH_BANNER_HTML;
    self.adMobBannerView.rootViewController = self;
    
    self.adMobBannerView.delegate = self;
    
    
    GADRequest *request = [GADRequest request];
    
    // set location:
    [request setLocationWithLatitude:32.0719
                           longitude:34.7879
                            accuracy:1.0];
    
    // set keywords
    [request setKeywords:@[@"Football",@"Baseball"]];
    
    
    MFAdNetworkExtras *extras = [[MFAdNetworkExtras alloc] init];
    
    extras.demo_age = @"18";
    extras.demo_gender = @"Male";
    
    extras.subject_to_gdpr = [NSNumber numberWithBool:TRUE];
    extras.gdpr_consent = @"asdasdazfdadsads";
    
    extras.floor_price = [NSNumber numberWithFloat:0.05f];
    
    [request registerAdNetworkExtras:extras];
    
    [self.adMobBannerView loadRequest:request];
}
// ==============================================================

/// Tells the delegate an ad request loaded an ad.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"adViewDidReceiveAd");
}

/// Tells the delegate an ad request failed.
- (void)adView:(GADBannerView *)adView
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

/// Tells the delegate that a full-screen view will be presented in response
/// to the user clicking on an ad.
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillPresentScreen");
}

/// Tells the delegate that the full-screen view will be dismissed.
- (void)adViewWillDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillDismissScreen");
}

/// Tells the delegate that the full-screen view has been dismissed.
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewDidDismissScreen");
}

/// Tells the delegate that a user click will open another app (such as
/// the App Store), backgrounding the current app.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    NSLog(@"adViewWillLeaveApplication");
}

// ###############################################################################
// #####   I N T E R S T I T I A L                                           #####
// ###############################################################################


- (IBAction)adMobInterstitial:(id)sender {
    self.adMobInterstitial = [[GADInterstitial alloc] initWithAdUnitID:ADMOB_HASH_INTER_HTML];
    
    self.adMobInterstitial.delegate = self;
    
    GADRequest *request = [GADRequest request];
    [self.adMobInterstitial loadRequest:request];
}

// ==============================================================

/// Tells the delegate an ad request succeeded.
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    NSLog(@"interstitialDidReceiveAd");
    
    if (self.adMobInterstitial.isReady) {
        [self.adMobInterstitial presentFromRootViewController:self];
    }
}

/// Tells the delegate an ad request failed.
- (void)interstitial:(GADInterstitial *)ad
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"interstitial:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

/// Tells the delegate that an interstitial will be presented.
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialWillPresentScreen");
}

/// Tells the delegate the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialWillDismissScreen");
}

/// Tells the delegate the interstitial had been animated off the screen.
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialDidDismissScreen");
}

/// Tells the delegate that a user click will open another app
/// (such as the App Store), backgrounding the current app.
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    NSLog(@"interstitialWillLeaveApplication");
}


// ###############################################################################
// #####   N A T I V E                                                       #####
// ###############################################################################

- (IBAction)adMobNativeAd:(id)sender {
    GADVideoOptions *videoOptions = [[GADVideoOptions alloc] init];
    videoOptions.startMuted = TRUE;
    
    
    self.adMobAdLoader = [[GADAdLoader alloc]
                          initWithAdUnitID:ADMOB_HASH_NATIVE
                          rootViewController:self
                          adTypes:@[kGADAdLoaderAdTypeUnifiedNative]
                          options:@[videoOptions]];
    self.adMobAdLoader.delegate = self;
    
    [self.adMobAdLoader loadRequest:[GADRequest request]];
}
    


// ==============================================================

/// Called after adLoader has finished loading.
- (void)adLoaderDidFinishLoading:(nonnull GADAdLoader *)adLoader
{
    NSLog(@"AdMob Native: adLoaderDidFinishLoading");
    
}

- (void)adLoader:(nonnull GADAdLoader *)adLoader didFailToReceiveAdWithError:(nonnull GADRequestError *)error
{
    NSLog(@"AdMob Native: didFailToReceiveAdWithError %@",error);
    
}

- (void)adLoader:(GADAdLoader *)adLoader didReceiveUnifiedNativeAd:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"AdMob Native: didReceiveUnifiedNativeAd (%@)",nativeAd.headline);
    
    [self UpdateNativeText:_lblTitle     withValue:nativeAd.headline];
    [self UpdateNativeText:_lblDesc      withValue:nativeAd.body];
    if (nativeAd.starRating==nil)
    {
        [self UpdateNativeText:_lblRating withValue:@""];
    } else {
        [self UpdateNativeText:_lblRating withValue:[NSString stringWithFormat:@"%@",nativeAd.starRating]];
    }
    [self UpdateNativeText:_lblSponsored withValue:nativeAd.advertiser];
    [self UpdateNativeButton:_btnCTA     withValue:nativeAd.callToAction];
    
    [self UpdateNativeImage:_imgIcon withImage:nativeAd.icon.image];
    if ((nativeAd.images!=nil) && (nativeAd.images.count>0))
    {
        [self UpdateNativeImage:_imgMain withImage:nativeAd.images.firstObject.image];
    }
}

- (void)nativeAdDidRecordImpression:(GADUnifiedNativeAd *)nativeAd {
    // The native ad was shown.
    NSLog(@"AdMob Native: nativeAdDidRecordImpression");
}

- (void)nativeAdDidRecordClick:(GADUnifiedNativeAd *)nativeAd {
    // The native ad was clicked on.
    NSLog(@"AdMob Native: nativeAdDidRecordClick");
}

- (void)nativeAdWillPresentScreen:(GADUnifiedNativeAd *)nativeAd {
    // The native ad will present a full screen view.
    NSLog(@"AdMob Native: nativeAdWillPresentScreen");
}

- (void)nativeAdWillDismissScreen:(GADUnifiedNativeAd *)nativeAd {
    // The native ad will dismiss a full screen view.
    NSLog(@"AdMob Native: nativeAdWillDismissScreen");
}

- (void)nativeAdDidDismissScreen:(GADUnifiedNativeAd *)nativeAd {
    // The native ad did dismiss a full screen view.
    NSLog(@"AdMob Native: nativeAdDidDismissScreen");
}

- (void)nativeAdWillLeaveApplication:(GADUnifiedNativeAd *)nativeAd {
    // The native ad will cause the application to become inactive and
    // open a new application.
    NSLog(@"AdMob Native: nativeAdWillLeaveApplication");
}
//---------------------------------------//
- (void)UpdateNativeText:(UILabel*)lbl withValue:(NSString*)value
{
    if (value==nil)
    {
        lbl.hidden = TRUE;
    } else {
        lbl.hidden = FALSE;
        lbl.text   = value;
    }
}

- (void)UpdateNativeButton:(UIButton*)btn withValue:(NSString*)value
{
    if (value==nil)
    {
        btn.hidden = TRUE;
    } else {
        btn.hidden = FALSE;
        [btn setTitle:value forState:UIControlStateNormal];
    }
}



- (void)UpdateNativeImage:(UIImageView*)img withImageURL:(NSString*)imageUrl
{
    if (imageUrl==nil)
    {
        img.hidden = TRUE;
    } else {
        img.hidden = FALSE;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *url = [NSURL URLWithString:imageUrl];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage* image = [[UIImage alloc]initWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [img setImage:image];
            });
        });
    }
}

- (void)UpdateNativeImage:(UIImageView*)img withImage:(UIImage*)value
{
    if (value==nil)
    {
        img.hidden = TRUE;
    } else {
        img.hidden = FALSE;
        dispatch_async(dispatch_get_main_queue(), ^{
            [img setImage:value];
        });
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
