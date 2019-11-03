//
//  ViewController.m
//  MFXTester
//
//  Created by ofirkariv on 24/04/2019.
//  Copyright © 2019 MobFox Mobile Advertising GmbH. All rights reserved.
//

#import "ViewController.h"
#import "MFXSDKCore/MFXSDKCore.h"
#import "MFAdNetworkExtras.h"

@import GoogleMobileAds;

#define HASH_BANNER_HTML  @"fe96717d9875b9da4339ea5367eff1ec"
#define HASH_BANNER_VIDEO @"80187188f458cfde788d961b6882fd53"
#define HASH_INTER_HTML   @"267d72ac3f77a3f447b32cf7ebf20673"
#define HASH_INTER_VIDEO  @"80187188f458cfde788d961b6882fd53"
#define HASH_NATIVE       @"d8bd50e4ba71a708ad224464bdcdc237" //@"a764347547748896b84e0b8ccd90fd62"

@interface ViewController () <GADBannerViewDelegate,
                            GADInterstitialDelegate,
                            GADAdLoaderDelegate,
                            GADUnifiedNativeAdLoaderDelegate,
                            MPAdViewDelegate,
                            MPInterstitialAdControllerDelegate>


@property (strong, nonatomic) IBOutlet UIView* viewAll;

@property (strong, nonatomic) IBOutlet UIButton* btnMobfox;
@property (strong, nonatomic) IBOutlet UIButton* btnAdMob;
@property (strong, nonatomic) IBOutlet UIButton* btnMoPub;

@property (strong, nonatomic) IBOutlet UIImageView* imgMobfox;
@property (strong, nonatomic) IBOutlet UIImageView* imgAdMob;
@property (strong, nonatomic) IBOutlet UIImageView* imgMoPub;

@property (strong, nonatomic) IBOutlet UIButton* btnBannerSmall;
@property (strong, nonatomic) IBOutlet UIButton* btnBannerLarge;
@property (strong, nonatomic) IBOutlet UIButton* btnBannerVideo;
@property (strong, nonatomic) IBOutlet UIButton* btnInterstitial;
@property (strong, nonatomic) IBOutlet UIButton* btnRewarded;
@property (strong, nonatomic) IBOutlet UIButton* btnNative;


@property (strong, nonatomic) IBOutlet UIView*      viewNative;
@property (strong, nonatomic) IBOutlet UIImageView* imgIcon;
@property (strong, nonatomic) IBOutlet UIImageView* imgMain;
@property (strong, nonatomic) IBOutlet UILabel*     lblRating;
@property (strong, nonatomic) IBOutlet UILabel*     lblTitle;
@property (strong, nonatomic) IBOutlet UILabel*     lblDesc;
@property (strong, nonatomic) IBOutlet UILabel*     lblSponsored;
@property (strong, nonatomic) IBOutlet UIButton*    btnCTA;

@property (strong, nonatomic) MFXBannerAd*       mBannerAd;
@property (strong, nonatomic) MFXInterstitialAd* mInterAd;
@property (strong, nonatomic) MFXNativeAd*       mNativeAd;


@property(nonatomic, strong) GADBannerView *adMobBannerView;
@property(nonatomic, strong) GADInterstitial *adMobInterstitial;
@property(nonatomic, strong) GADAdLoader *adMobAdLoader;
@property(nonatomic, strong) GADUnifiedNativeAd *adMobNative;


@property (strong, nonatomic) MPAdView*       mMoPubBanner;
@property (strong, nonatomic) MPInterstitialAdController* mMoPubInterstitial;
@property (strong, nonatomic) MPNativeAd *nativeAd;

@end

@implementation ViewController

CGPoint bannerCenterPoint;

#define ADAPTER_TYPE_MOBFOX 0
#define ADAPTER_TYPE_ADMOB  1
#define ADAPTER_TYPE_MOPUB  2
NSInteger mAdapterType = ADAPTER_TYPE_MOBFOX;

//###########################################################################################
//###########################################################################################
//#####                                                                                 #####
//#####   A p p   U I   s t u f f                                                       #####
//#####                                                                                 #####
//###########################################################################################
//###########################################################################################

- (void)updateTabs
{
    _imgMobfox.image = [UIImage imageNamed:(mAdapterType==ADAPTER_TYPE_MOBFOX)?@"mobfox_logo":@"mobfox_logo_grey"];
    _imgAdMob .image = [UIImage imageNamed:(mAdapterType==ADAPTER_TYPE_ADMOB )?@"admob_logo" :@"admob_logo_grey"];
    _imgMoPub .image = [UIImage imageNamed:(mAdapterType==ADAPTER_TYPE_MOPUB )?@"mopub_logo" :@"mopub_logo_grey"];

    switch (mAdapterType)
    {
        case ADAPTER_TYPE_MOBFOX:
            _btnBannerSmall.enabled =      TRUE;
            _btnBannerLarge.enabled =      TRUE;
            _btnBannerVideo.enabled =      TRUE;
            _btnInterstitial.enabled =     TRUE;
            _btnRewarded.enabled =         TRUE;
            _btnNative.enabled =           TRUE;
            break;
        case ADAPTER_TYPE_MOPUB:
            _btnBannerSmall.enabled =      TRUE;
            _btnBannerLarge.enabled =      FALSE;
            _btnBannerVideo.enabled =      FALSE;
            _btnInterstitial.enabled =     TRUE;
            _btnRewarded.enabled =         TRUE;
            _btnNative.enabled =           TRUE;
            break;
        case ADAPTER_TYPE_ADMOB:
            _btnBannerSmall.enabled =      TRUE;
            _btnBannerLarge.enabled =      TRUE;
            _btnBannerVideo.enabled =      FALSE;
            _btnInterstitial.enabled =     TRUE;
            _btnRewarded.enabled =         TRUE;
            _btnNative.enabled =           FALSE;
            break;
    }
}

// ###############################################################################

- (IBAction)btnMobfoxPressed:(id)sender
{
    [self clearAllAds];
    mAdapterType = ADAPTER_TYPE_MOBFOX;
    [self updateTabs];
}

- (IBAction)btnAdMobPressed:(id)sender
{
    [self clearAllAds];
    mAdapterType = ADAPTER_TYPE_ADMOB;
    [self updateTabs];
}

- (IBAction)btnMoPubPressed:(id)sender
{
    [self clearAllAds];
    mAdapterType = ADAPTER_TYPE_MOPUB;
    [self updateTabs];
}

// ===============================================================================

- (IBAction)btnBannerSmallPressed:(id)sender
{
    [self clearAllAds];
    
    switch (mAdapterType)
    {
        case ADAPTER_TYPE_MOBFOX:
            [self startMobFoxSmallBanner];
            break;
        case ADAPTER_TYPE_MOPUB:
            [self startMoPubSmallBanner];
            break;
        case ADAPTER_TYPE_ADMOB:
            [self startAdMobSmallBanner];
            break;
    }
}

- (IBAction)btnBannerLargePressed:(id)sender
{
    [self clearAllAds];
    
    switch (mAdapterType)
    {
        case ADAPTER_TYPE_MOBFOX:
            [self startMobFoxLargeBanner];
            break;
        case ADAPTER_TYPE_MOPUB:
            [self startMoPubLargeBanner];
            break;
        case ADAPTER_TYPE_ADMOB:
            [self startAdMobLargeBanner];
            break;
    }
}

- (IBAction)btnVideoBannerPressed:(id)sender
{
    [self clearAllAds];
    
    switch (mAdapterType)
    {
        case ADAPTER_TYPE_MOBFOX:
            [self startMobFoxVideoBanner];
            break;
        case ADAPTER_TYPE_MOPUB:
            // NOP
            break;
        case ADAPTER_TYPE_ADMOB:
            // NOP
            break;
    }
}

- (IBAction)btnInterstitialPressed:(id)sender
{
    [self clearAllAds];
    
    switch (mAdapterType)
    {
        case ADAPTER_TYPE_MOBFOX:
            [self startMobFoxInterstitialHtml];
            break;
        case ADAPTER_TYPE_MOPUB:
            [self startMoPubHtmlInterstitial];
            break;
        case ADAPTER_TYPE_ADMOB:
            [self startAdMobHtmlInterstitial];
            break;
    }
}

- (IBAction)btnRewardedPressed:(id)sender
{
    [self clearAllAds];
    
    switch (mAdapterType)
    {
        case ADAPTER_TYPE_MOBFOX:
            [self startMobFoxInterstitialVideo];
            break;
        case ADAPTER_TYPE_MOPUB:
            // mytodo:
            break;
        case ADAPTER_TYPE_ADMOB:
            [self startAdMobVideoInterstitial];
            break;
    }
}

- (IBAction)btnNativePressed:(id)sender
{
    [self clearAllAds];
    
    switch (mAdapterType)
    {
        case ADAPTER_TYPE_MOBFOX:
            [self startMobFoxNative];
            break;
        case ADAPTER_TYPE_MOPUB:
            [self startMoPubNative];
            break;
        case ADAPTER_TYPE_ADMOB:
            [self startAdMobNative];
            break;
    }
}

// ###############################################################################

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self updateTabs];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self clearMobFoxNatives];
}

// ###############################################################################

- (void)clearAllAds
{
    if (_mBannerAd!=nil)
    {
        [_mBannerAd releaseBanner];
        _mBannerAd = nil;
    }

    if (_mInterAd!=nil)
    {
        [_mInterAd releaseInterstitial];
        _mInterAd = nil;
    }

    if (_mNativeAd!=nil)
    {
        [_mNativeAd releaseNativeAd];
        _mNativeAd = nil;
    }

    [self clearMobFoxNatives];

    //------------------------------------
    
    if (self.adMobBannerView!=nil)
    {
        [self.adMobBannerView removeFromSuperview];
        self.adMobBannerView = nil;
    }
    
    if (self.adMobInterstitial!=nil)
    {
        self.adMobInterstitial = nil;
    }
    
    if (self.adMobAdLoader!=nil)
    {
        self.adMobAdLoader = nil;
    }
    
    //------------------------------------
    
    if (self.mMoPubBanner!=nil)
    {
        [self.mMoPubBanner removeFromSuperview];
        self.mMoPubBanner = nil;
    }
    
    if (self.mMoPubInterstitial!=nil)
    {
        self.mMoPubInterstitial = nil;
    }
}

//###########################################################################################
//###########################################################################################
//#####                                                                                 #####
//#####   M o b f o x                                                                   #####
//#####                                                                                 #####
//###########################################################################################
//###########################################################################################

// ###############################################################################
// #####   B A N N E R                                                       #####
// ###############################################################################

- (void)startMobFoxSmallBanner
{
    [self clearAllAds];
    
    _mBannerAd = [MobFoxSDK createBanner:HASH_BANNER_HTML
                                   width:320
                                  height:50
                            withDelegate:self];
   
    if (_mBannerAd!=nil)
    {
        
        
        [_mBannerAd setBannerRefresh:0];
        [MobFoxSDK loadBanner:_mBannerAd];
    }
}

- (void)startMobFoxLargeBanner
{
    [self clearAllAds];

    _mBannerAd = [MobFoxSDK createBanner:HASH_BANNER_HTML
                                                    width:300
                                                   height:250
                                             withDelegate:self];
    if (_mBannerAd!=nil)
    {
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        bannerCenterPoint = CGPointMake(w/2,240);
        
        [MobFoxSDK loadBanner:_mBannerAd];
       
    }
}

- (void)startMobFoxVideoBanner
{
    [self clearAllAds];

    _mBannerAd = [MobFoxSDK createBanner:HASH_BANNER_VIDEO
                                                    width:300
                                                   height:250
                                             withDelegate:self];
    if (_mBannerAd!=nil)
    {
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        bannerCenterPoint = CGPointMake(w/2,240);
        [MobFoxSDK loadBanner:_mBannerAd];
    }
}

// ==============================================================

- (void)bannerAdLoaded:(MFXBannerAd *)banner
{
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    bannerCenterPoint = CGPointMake(w/2,240);
    [MobFoxSDK addBanner:_mBannerAd toView:self.view centeredAt:bannerCenterPoint];
    NSLog(@"dbg: ### bannerAdLoaded ###");
    
    
  
}

- (void)bannerAdLoadFailed:(MFXBannerAd *)banner withError:(NSString*)error
{
    NSLog(@"dbg: ### bannerAdLoadFailed(%@) ###",error);
}

- (void)bannerAdShown:(MFXBannerAd *)banner
{
    NSLog(@"dbg: ### bannerAdShown ###");
}

- (void)bannerAdClicked:(MFXBannerAd *)banner
{
    NSLog(@"dbg: ### bannerAdClicked ###");
}

- (void)bannerAdFinished:(MFXBannerAd *)banner
{
    NSLog(@"dbg: ### bannerAdFinished ###");
}

- (void)bannerAdClosed:(MFXBannerAd *)banner
{
    NSLog(@"dbg: ### bannerAdClosed ###");
}

// ###############################################################################
// #####   I N T E R S T I T I A L                                           #####
// ###############################################################################

- (void)startMobFoxInterstitialHtml
{
    [self clearAllAds];

    _mInterAd = [MobFoxSDK createInterstitial:HASH_INTER_HTML
                                         withRootViewContoller:self
                                                  withDelegate:self];
    if (_mInterAd!=nil)
    {
        [MobFoxSDK loadInterstitial:_mInterAd];
    }
}

- (void)startMobFoxInterstitialVideo
{
    [self clearAllAds];

    _mInterAd = [MobFoxSDK createInterstitial:HASH_INTER_VIDEO
                                         withRootViewContoller:self
                                                  withDelegate:self];
    if (_mInterAd!=nil)
    {
        [MobFoxSDK loadInterstitial:_mInterAd];
    }
}

// ==============================================================

- (void)interstitialAdLoaded:(MFXInterstitialAd *)interstitial
{
    NSLog(@"dbg: ### interstitialAdLoaded ###");
    
    [MobFoxSDK showInterstitial:interstitial];
}

- (void)interstitialAdLoadFailed:(MFXInterstitialAd *)interstitial withError:(NSString*)error
{
    NSLog(@"dbg: ### interstitialAdLoadFailed(%@) ###",error);
}

- (void)interstitialAdShown:(MFXInterstitialAd *)interstitial
{
    NSLog(@"dbg: ### interstitialAdShown ###");
}

- (void)interstitialAdClicked:(MFXInterstitialAd *)interstitial withUrl:(NSString*)url
{
    NSLog(@"dbg: ### interstitialAdClicked ###");
}

- (void)interstitialAdFinished:(MFXInterstitialAd *)interstitial
{
    NSLog(@"dbg: ### interstitialAdFinished ###");
}

- (void)interstitialAdClosed:(MFXInterstitialAd *)interstitial
{
    NSLog(@"dbg: ### interstitialAdClosed ###");
}

// ###############################################################################
// #####   N A T I V E                                                       #####
// ###############################################################################

- (void)startMobFoxNative
{
    NSLog(@"dbg: ### Native ###");

    [self clearAllAds];
    
    [self clearMobFoxNatives];

    _mNativeAd = [MobFoxSDK createNativeAd:HASH_NATIVE
                                               withDelegate:self];
    if (_mNativeAd!=nil)
    {
        [MobFoxSDK loadNativeAd:_mNativeAd];
    }
  
}

- (IBAction)btnCTAPressed:(id)sender
{
    if (_mNativeAd!=nil)
    {
        [MobFoxSDK callToActionClicked:_mNativeAd];
    }
}

// ==============================================================

- (void)clearMobFoxNatives
{
    [self UpdateNativeText:_lblTitle     withValue:nil];
    [self UpdateNativeText:_lblDesc      withValue:nil];
    [self UpdateNativeText:_lblRating    withValue:nil];
    [self UpdateNativeText:_lblSponsored withValue:nil];
    [self UpdateNativeButton:_btnCTA     withValue:nil];

    [self UpdateNativeImage:_imgIcon withImage:nil];
    [self UpdateNativeImage:_imgMain withImage:nil];
}

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

// ==============================================================

- (void)nativeAdLoadFailed:(MFXNativeAd *)native withError:(NSString*)error
{
    NSLog(@"dbg: ### nativeAdLoadFailed(%@) ###",error);
}

- (void)nativeAdLoaded:(MFXNativeAd *)native
{
    NSLog(@"dbg: ### nativeAdLoaded ###");
    
    NSDictionary* dictTexts = [MobFoxSDK getNativeAdTexts:native];
    [self UpdateNativeText:_lblTitle     withValue:[dictTexts objectForKey:@"title"]];
    [self UpdateNativeText:_lblDesc      withValue:[dictTexts objectForKey:@"desc"]];
    [self UpdateNativeText:_lblRating    withValue:[dictTexts objectForKey:@"rating"]];
    [self UpdateNativeText:_lblSponsored withValue:[dictTexts objectForKey:@"sponsored"]];
    [self UpdateNativeButton:_btnCTA     withValue:[dictTexts objectForKey:@"ctatext"]];

    //NSDictionary* dictImages = [MobFoxSDK getNativeAdImageUrls:native];
    //[self UpdateNativeImage:_imgIcon withImageURL:[dictImages objectForKey:@"icon"]];
    //[self UpdateNativeImage:_imgMain withImageURL:[dictImages objectForKey:@"main"]];

    [MobFoxSDK loadNativeAdImages:native];
    
    [MobFoxSDK registerNativeAdForInteraction:native onView:_viewNative];
}

- (void)nativeAdImagesReady:(MFXNativeAd *)native
{
    NSLog(@"dbg: ### nativeAdImagesReady ###");

    NSDictionary* dictImages = [MobFoxSDK getNativeAdImages:native];
    [self UpdateNativeImage:_imgIcon withImage:[dictImages objectForKey:@"icon"]];
    [self UpdateNativeImage:_imgMain withImage:[dictImages objectForKey:@"main"]];
}

- (void)nativeAdClicked:(MFXNativeAd *)native
{
    NSLog(@"dbg: ### nativeAdClicked ###");
}

//###########################################################################################
//###########################################################################################
//#####                                                                                 #####
//#####   M o P u b                                                                     #####
//#####                                                                                 #####
//###########################################################################################
//###########################################################################################

#define MOPUB_HASH_ADAPTER_BANNER @"234dd5a1b1bf4a5f9ab50431f9615784"
#define MOPUB_HASH_ADAPTER_INTER  @"a5277fa1fd57418b867cfaa949df3b4a"
#define MOPUB_HASH_ADAPTER_NATIVE @"97ea9854b278483bb455c899002a3f79"

// ###############################################################################
// #####   B A N N E R                                                       #####
// ###############################################################################

- (void)startMoPubSmallBanner
{
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    
    self.mMoPubBanner = [[MPAdView alloc] initWithAdUnitId:MOPUB_HASH_ADAPTER_BANNER
                                                      size:MOPUB_BANNER_SIZE];
    self.mMoPubBanner.delegate = self;
    self.mMoPubBanner.frame = CGRectMake((w - MOPUB_BANNER_SIZE.width)/2, 140,
                                         MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
    [self.mMoPubBanner loadAd];
}

- (void)startMoPubLargeBanner
{
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    
    self.mMoPubBanner = [[MPAdView alloc] initWithAdUnitId:MOPUB_HASH_ADAPTER_BANNER
                                                      size:MOPUB_MEDIUM_RECT_SIZE];
    self.mMoPubBanner.delegate = self;
    self.mMoPubBanner.frame = CGRectMake((w - MOPUB_MEDIUM_RECT_SIZE.width)/2, 140,
                                         MOPUB_MEDIUM_RECT_SIZE.width,
                                         MOPUB_MEDIUM_RECT_SIZE.height);
    
    [self.mMoPubBanner loadAd];
}

// ==============================================================

- (UIViewController *)viewControllerForPresentingModalView
{
    NSLog(@"MoPub BANNER: viewControllerForPresentingModalView");
    return self;
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

// ###############################################################################
// #####   I N T E R S T I T I A L                                           #####
// ###############################################################################

- (void)startMoPubHtmlInterstitial
{
    self.mMoPubInterstitial = [MPInterstitialAdController
                               interstitialAdControllerForAdUnitId:MOPUB_HASH_ADAPTER_INTER];
    self.mMoPubInterstitial.delegate = self;
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

// ###############################################################################
// #####   N A T I V E                                                       #####
// ###############################################################################

- (void)startMoPubNative
{
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
    
    __weak ViewController *weakself = self;
    [adRequest startWithCompletionHandler:^(MPNativeAdRequest *request, MPNativeAd *response, NSError *error) {
        if (error) {
            NSLog(@"%@",[error description]); // Handle error.
        }
        else{
            NSDictionary *propertiesDict = response.properties;
            __strong ViewController *strongself = weakself;
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

// ###############################################################################
// #####   B A N N E R                                                       #####
// ###############################################################################

- (void)startAdMobSmallBanner
{
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    bannerCenterPoint = CGPointMake(w/2,140);
    [self startAdMobBannerWithSize:kGADAdSizeBanner];
}

- (void)startAdMobLargeBanner
{
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    bannerCenterPoint = CGPointMake(w/2,240);
    [self startAdMobBannerWithSize:kGADAdSizeMediumRectangle];
}

- (void)startAdMobBannerWithSize:(GADAdSize)size
{
    self.adMobBannerView = [[GADBannerView alloc] initWithAdSize:size];
    
    [self.view addSubview:self.adMobBannerView];
    
    self.adMobBannerView.center = bannerCenterPoint;
    
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

- (void)startAdMobHtmlInterstitial
{
    self.adMobInterstitial = [[GADInterstitial alloc] initWithAdUnitID:ADMOB_HASH_INTER_HTML];
    
    self.adMobInterstitial.delegate = self;
    
    GADRequest *request = [GADRequest request];
    [self.adMobInterstitial loadRequest:request];
}

- (void)startAdMobVideoInterstitial
{
    self.adMobInterstitial = [[GADInterstitial alloc] initWithAdUnitID:ADMOB_HASH_INTER_VIDEO];
    
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

- (void)startAdMobNative
{
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

@end
