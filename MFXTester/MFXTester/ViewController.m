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
#import <CoreLocation/CoreLocation.h>

#if __has_include(<MoPub/MoPub.h>)
#import <MoPub/MoPub.h>
#elif __has_include(<MoPubSDKFramework/MoPub.h>)
#import <MoPubSDKFramework/MoPub.h>
#elif __has_include(<MoPub.h>)
#import <MoPub.h>
#endif

#import <GoogleMobileAds/GoogleMobileAds.h>

//@import GoogleMobileAds;

@interface ViewController () <CLLocationManagerDelegate>

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
@property (strong, nonatomic) IBOutlet UIButton* btnInterstitialVideo;
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

@property (strong, nonatomic) MFXBannerAd *mBannerAd;
@property (strong, nonatomic) MFXInterstitialAd *mInterAd;
@property (strong, nonatomic) MFXNativeAd *mNativeAd;

@property(nonatomic, strong) GADBannerView *adMobBannerView;
@property(nonatomic, strong) GADInterstitial *adMobInterstitial;
@property(nonatomic, strong) GADRewardedAd *adMobRewarded;
@property(nonatomic, strong) GADAdLoader *adMobAdLoader;
@property(nonatomic, strong) GADUnifiedNativeAd *adMobNative;

@property (strong, nonatomic) MPAdView *mMoPubBanner;
@property (strong, nonatomic) MPInterstitialAdController *mMoPubInterstitial;
@property (strong, nonatomic) MPNativeAd *nativeAd;

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@interface ViewController(MobFoxDelegates) <MFXBannerAdDelegate, MFXInterstitialAdDelegate, MFXNativeAdDelegate>
@end

@interface ViewController(MoPubDelegates) <MPAdViewDelegate, MPInterstitialAdControllerDelegate, MPRewardedVideoDelegate, MPNativeAdDelegate>
@end

@interface ViewController(AdMobDelegates) <GADBannerViewDelegate, GADInterstitialDelegate, GADRewardedAdDelegate, GADUnifiedNativeAdLoaderDelegate>
@end

@implementation ViewController

CGPoint bannerCenterPoint;

#define ADAPTER_TYPE_MOBFOX 0
#define ADAPTER_TYPE_ADMOB  1
#define ADAPTER_TYPE_MOPUB  2
NSInteger mAdapterType = ADAPTER_TYPE_MOBFOX;

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"%s: status = %i", __PRETTY_FUNCTION__, status);
    [manager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"%s: locations = %@", __PRETTY_FUNCTION__, locations);
}

#pragma mark - App UI stuff

- (void)updateTabs {
    _imgMobfox.image =  [UIImage imageNamed:(mAdapterType == ADAPTER_TYPE_MOBFOX) ? @"mobfox_logo" : @"mobfox_logo_grey"];
    _imgAdMob.image =   [UIImage imageNamed:(mAdapterType == ADAPTER_TYPE_ADMOB ) ? @"admob_logo" : @"admob_logo_grey"];
    _imgMoPub.image =   [UIImage imageNamed:(mAdapterType == ADAPTER_TYPE_MOPUB ) ? @"mopub_logo" : @"mopub_logo_grey"];

    switch (mAdapterType) {
        case ADAPTER_TYPE_MOBFOX:
            _btnBannerSmall.enabled =       YES;
            _btnBannerLarge.enabled =       YES;
            _btnBannerVideo.enabled =       YES;
            _btnInterstitial.enabled =      YES;
            _btnInterstitialVideo.enabled = YES;
            _btnRewarded.enabled =          YES;
            _btnNative.enabled =            YES;
            break;
        case ADAPTER_TYPE_MOPUB:
            _btnBannerSmall.enabled =       YES;
            _btnBannerLarge.enabled =       YES;
            _btnBannerVideo.enabled =       NO;
            _btnInterstitial.enabled =      YES;
            _btnInterstitialVideo.enabled = YES;
            _btnRewarded.enabled =          YES;
            _btnNative.enabled =            YES;
            break;
        case ADAPTER_TYPE_ADMOB:
            _btnBannerSmall.enabled =       YES;
            _btnBannerLarge.enabled =       YES;
            _btnBannerVideo.enabled =       NO;
            _btnInterstitial.enabled =      YES;
            _btnInterstitialVideo.enabled = YES;
            _btnRewarded.enabled =          YES;
            _btnNative.enabled =            NO;
            break;
    }
}

#pragma mark -

- (IBAction)btnMobfoxPressed:(id)sender {
    [self clearAllAds];
    mAdapterType = ADAPTER_TYPE_MOBFOX;
    [self updateTabs];
}

- (IBAction)btnAdMobPressed:(id)sender {
    [self clearAllAds];
    mAdapterType = ADAPTER_TYPE_ADMOB;
    [self updateTabs];
}

- (IBAction)btnMoPubPressed:(id)sender {
    [self clearAllAds];
    mAdapterType = ADAPTER_TYPE_MOPUB;
    [self updateTabs];
}

- (IBAction)btnSettingsPressed:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Settings"
                                                                         message:nil
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak ViewController *weakSelf = self;

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"COPPA" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf presentCOPPASettings];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)presentCOPPASettings {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"COPPA"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    __block UITextField *coppaTextField = nil;

    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Set COPPA (1/0)";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        coppaTextField = textField;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Set" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BOOL coppa = coppaTextField.text.boolValue;
        [MobFoxSDK setCoppa:coppa];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -

- (IBAction)btnBannerSmallPressed:(id)sender {
    [self clearAllAds];
    
    switch (mAdapterType) {
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

- (IBAction)btnBannerLargePressed:(id)sender {
    [self clearAllAds];
    
    switch (mAdapterType) {
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

- (IBAction)btnVideoBannerPressed:(id)sender {
    [self clearAllAds];
    
    switch (mAdapterType) {
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

- (IBAction)btnInterstitialPressed:(id)sender {
    [self clearAllAds];
    
    switch (mAdapterType) {
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

- (IBAction)btnInterstitialVideoPressed:(id)sender {
    [self clearAllAds];
    
    switch (mAdapterType) {
        case ADAPTER_TYPE_MOBFOX:
            [self startMobFoxInterstitialVideo:NO];
            break;
        case ADAPTER_TYPE_MOPUB:
            // mytodo:
            break;
        case ADAPTER_TYPE_ADMOB:
            [self startAdMobVideoInterstitial];
            break;
    }
}

- (IBAction)btnRewardedPressed:(id)sender {
    [self clearAllAds];
    
    switch (mAdapterType) {
        case ADAPTER_TYPE_MOBFOX:
            [self startMobFoxInterstitialVideo:YES];
            break;
        case ADAPTER_TYPE_MOPUB:
            [self startMoPubRewarded];
            break;
        case ADAPTER_TYPE_ADMOB:
            [self startAdMobRewarded];
            break;
    }
}

- (IBAction)btnNativePressed:(id)sender {
    [self clearAllAds];
    
    switch (mAdapterType) {
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

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    _locationManager = [CLLocationManager new];
    _locationManager.delegate = self;
    [_locationManager requestWhenInUseAuthorization];
    
    [self updateTabs];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self clearMobFoxNatives];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
}

#pragma mark -

- (void)clearAllAds {
    if (_mBannerAd != nil) {
        [_mBannerAd releaseBanner];
        _mBannerAd = nil;
    }

    if (_mInterAd != nil) {
        [MobFoxSDK releaseInterstitial:_mInterAd];
        _mInterAd = nil;
    }

    if (_mNativeAd != nil) {
        [MobFoxSDK releaseNativeAd:_mNativeAd];
        _mNativeAd = nil;
    }

    [self clearMobFoxNatives];

    //------------------------------------
    
    if (self.adMobBannerView != nil) {
        [self.adMobBannerView removeFromSuperview];
        self.adMobBannerView = nil;
    }
    
    if (self.adMobInterstitial != nil) {
        self.adMobInterstitial = nil;
    }
    
    if (self.adMobAdLoader != nil) {
        self.adMobAdLoader = nil;
    }
    
    //------------------------------------
    
    if (self.mMoPubBanner != nil) {
        [self.mMoPubBanner removeFromSuperview];
        self.mMoPubBanner = nil;
    }
    
    if (self.mMoPubInterstitial != nil) {
        self.mMoPubInterstitial = nil;
    }
}

#pragma mark - MobFox

#define HASH_BANNER_HTML  @"fe96717d9875b9da4339ea5367eff1ec"
#define HASH_BANNER_VIDEO @"80187188f458cfde788d961b6882fd53"
#define HASH_INTER_HTML   @"267d72ac3f77a3f447b32cf7ebf20673"
#define HASH_INTER_VIDEO  @"80187188f458cfde788d961b6882fd53"
#define HASH_NATIVE       @"d8bd50e4ba71a708ad224464bdcdc237" //@"a764347547748896b84e0b8ccd90fd62"

#pragma mark Banner

- (void)startMobFoxSmallBanner {
    [self clearAllAds];
    
    _mBannerAd = [MobFoxSDK createBanner:HASH_BANNER_HTML
                                   width:320
                                  height:50
                            withDelegate:self];
   
    if (_mBannerAd != nil) {
        [_mBannerAd setBannerRefresh:0];
        [MobFoxSDK loadBanner:_mBannerAd];
    }
}

- (void)startMobFoxLargeBanner {
    [self clearAllAds];

    _mBannerAd = [MobFoxSDK createBanner:HASH_BANNER_HTML
                                   width:300
                                  height:250
                            withDelegate:self];
    if (_mBannerAd != nil) {
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        bannerCenterPoint = CGPointMake(w/2,240);
        
        [MobFoxSDK loadBanner:_mBannerAd];
    }
}

- (void)startMobFoxVideoBanner {
    [self clearAllAds];

    _mBannerAd = [MobFoxSDK createBanner:HASH_BANNER_VIDEO
                                   width:300
                                  height:250
                            withDelegate:self];
    if (_mBannerAd != nil) {
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        bannerCenterPoint = CGPointMake(w/2,240);
        [MobFoxSDK loadBanner:_mBannerAd];
    }
}

#pragma mark Interstitial

- (void)startMobFoxInterstitialHtml {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self clearAllAds];

    _mInterAd = [MobFoxSDK createInterstitial:HASH_INTER_HTML
                        withRootViewContoller:self
                                 withDelegate:self];
    if (_mInterAd != nil) {
        [MobFoxSDK loadInterstitial:_mInterAd];
    }
}

- (void)startMobFoxInterstitialVideo:(BOOL)isRewarded {
    NSLog(@"%s: isRewarded = %@", __PRETTY_FUNCTION__, isRewarded?@"YES":@"NO");
    [self clearAllAds];

    _mInterAd = [MobFoxSDK createInterstitial:HASH_INTER_VIDEO
                        withRootViewContoller:self
                                 withDelegate:self];
    if (_mInterAd != nil) {
        if (isRewarded) {
            _mInterAd.isRewarded = isRewarded;
        }
        [MobFoxSDK loadInterstitial:_mInterAd];
    }
}

#pragma mark Native

- (void)startMobFoxNative {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    [self clearAllAds];
    
    [self clearMobFoxNatives];

    _mNativeAd = [MobFoxSDK createNativeAd:HASH_NATIVE withDelegate:self];
    if (_mNativeAd != nil) {
        [MobFoxSDK loadNativeAd:_mNativeAd];
    }
}

- (IBAction)btnCTAPressed:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (_mNativeAd != nil) {
        [MobFoxSDK callToActionClicked:_mNativeAd];
    }
}

#pragma mark -

- (void)clearMobFoxNatives {
    [self UpdateNativeText:_lblTitle     withValue:nil];
    [self UpdateNativeText:_lblDesc      withValue:nil];
    [self UpdateNativeText:_lblRating    withValue:nil];
    [self UpdateNativeText:_lblSponsored withValue:nil];
    [self UpdateNativeButton:_btnCTA     withValue:nil];

    [self UpdateNativeImage:_imgIcon withImage:nil];
    [self UpdateNativeImage:_imgMain withImage:nil];
}

- (void)UpdateNativeText:(UILabel *)lbl withValue:(NSString *)value {
    if (value == nil) {
        lbl.hidden = YES;
    } else {
        lbl.hidden = NO;
        lbl.text   = value;
    }
}

- (void)UpdateNativeButton:(UIButton *)btn withValue:(NSString *)value {
    if (value == nil) {
        btn.hidden = YES;
    } else {
        btn.hidden = NO;
        [btn setTitle:value forState:UIControlStateNormal];
    }
}

- (void)UpdateNativeImage:(UIImageView *)img withImageURL:(NSString *)imageUrl {
    if (imageUrl == nil) {
        img.hidden = YES;
    } else {
        img.hidden = NO;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *url = [NSURL URLWithString:imageUrl];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [[UIImage alloc]initWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [img setImage:image];
            });
        });
    }
}

- (void)UpdateNativeImage:(UIImageView *)img withImage:(UIImage *)value {
    if (value == nil) {
        img.hidden = YES;
    } else {
        img.hidden = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [img setImage:value];
        });
    }
}

#pragma mark - MoPub

#define MOPUB_HASH_ADAPTER_BANNER   @"234dd5a1b1bf4a5f9ab50431f9615784"
#define MOPUB_HASH_ADAPTER_INTER    @"a5277fa1fd57418b867cfaa949df3b4a"
#define MOPUB_HASH_ADAPTER_REWARDED @"e3d4c8701d4547e68e8f837fa4fe5122"
#define MOPUB_HASH_ADAPTER_NATIVE   @"97ea9854b278483bb455c899002a3f79"

CGSize const MFX_MOPUB_BANNER_SIZE = { .width = 320.0f, .height = 50.0f };
CGSize const MFX_MOPUB_MEDIUM_RECT_SIZE = { .width = 300.0f, .height = 250.0f };

#pragma mark Banner

- (void)startMoPubSmallBanner {
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    
    self.mMoPubBanner = [[MPAdView alloc] initWithAdUnitId:MOPUB_HASH_ADAPTER_BANNER];
    self.mMoPubBanner.delegate = self;
    self.mMoPubBanner.frame = CGRectMake((w - MFX_MOPUB_BANNER_SIZE.width)/2, 140,
                                         MFX_MOPUB_BANNER_SIZE.width, MFX_MOPUB_BANNER_SIZE.height);
    [self.mMoPubBanner loadAdWithMaxAdSize:kMPPresetMaxAdSize50Height];
}

- (void)startMoPubLargeBanner {
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    
    self.mMoPubBanner = [[MPAdView alloc] initWithAdUnitId:MOPUB_HASH_ADAPTER_BANNER];
    self.mMoPubBanner.delegate = self;
    self.mMoPubBanner.frame = CGRectMake((w - MFX_MOPUB_MEDIUM_RECT_SIZE.width)/2, 140,
                                         MFX_MOPUB_MEDIUM_RECT_SIZE.width,
                                         MFX_MOPUB_MEDIUM_RECT_SIZE.height);
    
    [self.mMoPubBanner loadAdWithMaxAdSize:kMPPresetMaxAdSize250Height];
}

#pragma mark Interstitial

- (void)startMoPubHtmlInterstitial {
    self.mMoPubInterstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:MOPUB_HASH_ADAPTER_INTER];
    self.mMoPubInterstitial.delegate = self;
    // Fetch the interstitial ad.
    [self.mMoPubInterstitial loadAd];
}

#pragma mark Rewarded

- (void)startMoPubRewarded {
    [MPRewardedVideo loadRewardedVideoAdWithAdUnitID:MOPUB_HASH_ADAPTER_REWARDED withMediationSettings:nil];
    [MPRewardedVideo setDelegate:self forAdUnitId:MOPUB_HASH_ADAPTER_REWARDED];
}

#pragma mark Native

- (void)startMoPubNative {
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
            NSLog(@"%s: error = %@", __PRETTY_FUNCTION__, [error description]); // Handle error.
        } else {
            NSDictionary *propertiesDict = response.properties;
            __strong ViewController *strongSelf = weakself;
            [strongSelf UpdateNativeText:strongSelf.lblTitle     withValue:[propertiesDict objectForKey:kAdTitleKey]];
            [strongSelf UpdateNativeText:strongSelf.lblDesc      withValue:[propertiesDict objectForKey:kAdTextKey]];
            [strongSelf UpdateNativeText:strongSelf.lblRating    withValue:[propertiesDict objectForKey:kAdStarRatingKey]];
            [strongSelf UpdateNativeButton:strongSelf.btnCTA     withValue:[propertiesDict objectForKey:kAdCTATextKey]];
            [strongSelf UpdateNativeImage:strongSelf.imgMain withImageURL:[propertiesDict objectForKey:kAdMainImageKey]];
            
            strongSelf.nativeAd = response;
            strongSelf.nativeAd.delegate = strongSelf;
            UIView *nativeAdView = [response retrieveAdViewWithError:nil];
            nativeAdView.frame = CGRectMake(0, 0, 400, 500);
            [strongSelf.view addSubview:nativeAdView];
        }}];
}

#pragma mark - AdMob

#define ADMOB_HASH_BANNER_HTML  @"ca-app-pub-6224828323195096/5240875564"
#define ADMOB_HASH_INTER_HTML   @"ca-app-pub-6224828323195096/7876284361"
#define ADMOB_HASH_INTER_VIDEO  @"ca-app-pub-6224828323195096/7876284361"
#define ADMOB_HASH_INTER_REWARD @"ca-app-pub-6224828323195096/9409251358"
#define ADMOB_HASH_NATIVE       @"ca-app-pub-6224828323195096/6049137964"

#pragma mark Banner

- (void)startAdMobSmallBanner {
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    bannerCenterPoint = CGPointMake(w/2,140);
    [self startAdMobBannerWithSize:kGADAdSizeBanner];
}

- (void)startAdMobLargeBanner {
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    bannerCenterPoint = CGPointMake(w/2,240);
    [self startAdMobBannerWithSize:kGADAdSizeMediumRectangle];
}

- (void)startAdMobBannerWithSize:(GADAdSize)size {
    self.adMobBannerView = [[GADBannerView alloc] initWithAdSize:size];
    
    [self.view addSubview:self.adMobBannerView];
    
    self.adMobBannerView.center = bannerCenterPoint;
    self.adMobBannerView.adUnitID = ADMOB_HASH_BANNER_HTML;
    self.adMobBannerView.rootViewController = self;
    self.adMobBannerView.delegate = self;
    
    GADRequest *request = [GADRequest request];

    // set location:
    [request setLocationWithLatitude:32.0719 longitude:34.7879 accuracy:1.0];

    // set keywords
    [request setKeywords:@[@"Football", @"Baseball"]];
    
    // set extras
    MFAdNetworkExtras *extras = [[MFAdNetworkExtras alloc] init];
    extras.demo_age = @"18";
    extras.demo_gender = @"Male";
    extras.subject_to_gdpr = [NSNumber numberWithBool:YES];
    extras.gdpr_consent = @"asdasdazfdadsads";
    extras.floor_price = [NSNumber numberWithFloat:0.05f];
    
    [request registerAdNetworkExtras:extras];
    
    [self.adMobBannerView loadRequest:request];
}

#pragma mark Interstitial

- (void)startAdMobHtmlInterstitial {
    self.adMobInterstitial = [[GADInterstitial alloc] initWithAdUnitID:ADMOB_HASH_INTER_HTML];
    self.adMobInterstitial.delegate = self;
    [self.adMobInterstitial loadRequest:[GADRequest request]];
}

- (void)startAdMobVideoInterstitial {
    self.adMobInterstitial = [[GADInterstitial alloc] initWithAdUnitID:ADMOB_HASH_INTER_VIDEO];
    self.adMobInterstitial.delegate = self;
    [self.adMobInterstitial loadRequest:[GADRequest request]];
}

- (void)startAdMobRewarded {
    self.adMobRewarded = [[GADRewardedAd alloc] initWithAdUnitID:ADMOB_HASH_INTER_REWARD];
    
    GADRequest *request = [GADRequest request];
    
    __weak ViewController *weakSelf = self;
    [self.adMobRewarded loadRequest:request completionHandler:^(GADRequestError * _Nullable error) {
        NSLog(@"%s loadRequest completed", __PRETTY_FUNCTION__);
        __strong ViewController *strongSelf = weakSelf;
        if (strongSelf != nil) {
            if (error) {
                NSLog(@"%s loadRequest: error = %@", __PRETTY_FUNCTION__, error);
            } else {
                NSLog(@"%s loadRequest: no error", __PRETTY_FUNCTION__);
                [strongSelf.adMobRewarded presentFromRootViewController:strongSelf delegate:strongSelf];
            }
        }
    }];
}

#pragma mark Native

- (void)startAdMobNative {
    GADVideoOptions *videoOptions = [[GADVideoOptions alloc] init];
    videoOptions.startMuted = YES;
    
    self.adMobAdLoader = [[GADAdLoader alloc] initWithAdUnitID:ADMOB_HASH_NATIVE
                                            rootViewController:self
                                                       adTypes:@[kGADAdLoaderAdTypeUnifiedNative]
                                                       options:@[videoOptions]];
    self.adMobAdLoader.delegate = self;
    
    [self.adMobAdLoader loadRequest:[GADRequest request]];
}

@end

@implementation ViewController(MobFoxDelegates)

- (void)bannerAdLoaded:(MFXBannerAd *)banner {
    NSLog(@"MobFox Banner: %s", __PRETTY_FUNCTION__);
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    bannerCenterPoint = CGPointMake(w/2,240);
    [MobFoxSDK addBanner:_mBannerAd toView:self.view centeredAt:bannerCenterPoint];
}

- (void)bannerAdLoadFailed:(MFXBannerAd *)banner withError:(NSString *)error {
    NSLog(@"MobFox Banner: %s: error = %@", __PRETTY_FUNCTION__, error);
}

- (void)bannerAdShown:(MFXBannerAd *)banner {
    NSLog(@"MobFox Banner: %s", __PRETTY_FUNCTION__);
}

- (void)bannerAdClicked:(MFXBannerAd *)banner {
    NSLog(@"MobFox Banner: %s", __PRETTY_FUNCTION__);
}

- (void)bannerAdFinished:(MFXBannerAd *)banner {
    NSLog(@"MobFox Banner: %s", __PRETTY_FUNCTION__);
}

- (void)bannerAdClosed:(MFXBannerAd *)banner {
    NSLog(@"MobFox Banner: %s", __PRETTY_FUNCTION__);
}

#pragma mark -

- (void)interstitialAdLoaded:(MFXInterstitialAd *)interstitial {
    NSLog(@"MobFox Inter: %s", __PRETTY_FUNCTION__);

    [MobFoxSDK showInterstitial:interstitial];
}

- (void)interstitialAdLoadFailed:(MFXInterstitialAd *)interstitial withError:(NSString *)error {
    NSLog(@"MobFox Inter: %s: error = %@", __PRETTY_FUNCTION__, error);
}

- (void)interstitialAdShown:(MFXInterstitialAd *)interstitial {
    NSLog(@"MobFox Inter: %s", __PRETTY_FUNCTION__);
}

- (void)interstitialAdClicked:(MFXInterstitialAd *)interstitial withUrl:(NSString *)url {
    NSLog(@"MobFox Inter: %s", __PRETTY_FUNCTION__);
}

- (void)interstitialAdFinished:(MFXInterstitialAd *)interstitial {
    NSLog(@"MobFox Inter: %s", __PRETTY_FUNCTION__);
}

- (void)interstitialAdClosed:(MFXInterstitialAd *)interstitial {
    NSLog(@"MobFox Inter: %s", __PRETTY_FUNCTION__);
}

#pragma mark -

- (void)nativeAdLoadFailed:(MFXNativeAd *)native withError:(NSString *)error {
    NSLog(@"MobFox Native: %s: error = %@", __PRETTY_FUNCTION__, error);
}

- (void)nativeAdLoaded:(MFXNativeAd *)native {
    NSLog(@"MobFox Native: %s", __PRETTY_FUNCTION__);

    NSDictionary* dictTexts = [MobFoxSDK getNativeAdTexts:native];
    [self UpdateNativeText:_lblTitle     withValue:[dictTexts objectForKey:@"title"]];
    [self UpdateNativeText:_lblDesc      withValue:[dictTexts objectForKey:@"desc"]];
    [self UpdateNativeText:_lblRating    withValue:[dictTexts objectForKey:@"rating"]];
    [self UpdateNativeText:_lblSponsored withValue:[dictTexts objectForKey:@"sponsored"]];
    [self UpdateNativeButton:_btnCTA     withValue:[dictTexts objectForKey:@"ctatext"]];

    [MobFoxSDK loadNativeAdImages:native];
    
    [MobFoxSDK registerNativeAdForInteraction:native onView:_viewNative];
}

- (void)nativeAdImagesReady:(MFXNativeAd *)native {
    NSLog(@"MobFox Native: %s", __PRETTY_FUNCTION__);

    NSDictionary *dictImages = [MobFoxSDK getNativeAdImages:native];
    [self UpdateNativeImage:_imgIcon withImage:[dictImages objectForKey:@"icon"]];
    [self UpdateNativeImage:_imgMain withImage:[dictImages objectForKey:@"main"]];
}

- (void)nativeAdClicked:(MFXNativeAd *)native {
    NSLog(@"MobFox Native: %s", __PRETTY_FUNCTION__);
}

@end

@implementation ViewController(MoPubDelegates)

- (UIViewController *)viewControllerForPresentingModalView {
    NSLog(@"MoPub Banner/Native: %s", __PRETTY_FUNCTION__);
    return self;
}

- (void)adViewDidLoadAd:(MPAdView *)view adSize:(CGSize)adSize {
    NSLog(@"MoPub Banner: %s", __PRETTY_FUNCTION__);
    CGRect adFrame = self.mMoPubBanner.frame;
    adFrame.size = adSize;
    self.mMoPubBanner.frame = adFrame;
    [self.view addSubview:self.mMoPubBanner];
}

- (void)adView:(MPAdView *)view didFailToLoadAdWithError:(NSError *)error {
    NSLog(@"MoPub Banner: %s: error = %@", __PRETTY_FUNCTION__, [error localizedDescription]);
}

- (void)willPresentModalViewForAd:(MPAdView *)view {
    NSLog(@"MoPub Banner: %s", __PRETTY_FUNCTION__);
}

- (void)didDismissModalViewForAd:(MPAdView *)view {
    NSLog(@"MoPub Banner: %s", __PRETTY_FUNCTION__);
}

- (void)willLeaveApplicationFromAd:(MPAdView *)view {
    NSLog(@"MoPub Banner: %s", __PRETTY_FUNCTION__);
}

#pragma mark -

- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial {
    NSLog(@"MoPub Inter: %s", __PRETTY_FUNCTION__);
    
    if (self.mMoPubInterstitial.ready) [self.mMoPubInterstitial showFromViewController:self];
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial {
    NSLog(@"MoPub Inter: %s", __PRETTY_FUNCTION__);
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial withError:(NSError *)error {
    NSLog(@"MoPub Inter: %s: error = %@", __PRETTY_FUNCTION__, error.localizedDescription);
}

- (void)interstitialWillAppear:(MPInterstitialAdController *)interstitial {
    NSLog(@"MoPub Inter: %s", __PRETTY_FUNCTION__);
}

- (void)interstitialDidAppear:(MPInterstitialAdController *)interstitial {
    NSLog(@"MoPub Inter: %s", __PRETTY_FUNCTION__);
}

- (void)interstitialWillDisappear:(MPInterstitialAdController *)interstitial {
    NSLog(@"MoPub Inter: %s", __PRETTY_FUNCTION__);
}

- (void)interstitialDidDisappear:(MPInterstitialAdController *)interstitial {
    NSLog(@"MoPub Inter: %s", __PRETTY_FUNCTION__);
}

- (void)interstitialDidExpire:(MPInterstitialAdController *)interstitial {
    NSLog(@"MoPub Inter: %s", __PRETTY_FUNCTION__);
}

- (void)interstitialDidReceiveTapEvent:(MPInterstitialAdController *)interstitial {
    NSLog(@"MoPub Inter: %s", __PRETTY_FUNCTION__);
}

#pragma mark -

/**
 * This method is called after an ad loads successfully.
 *
 * @param adUnitID The ad unit ID of the ad associated with the event.
 */
- (void)rewardedVideoAdDidLoadForAdUnitID:(NSString *)adUnitID {
    NSLog(@"MoPub Rewarded: %s", __PRETTY_FUNCTION__);
    
    MPRewardedVideoReward *reward = [[MPRewardedVideo availableRewardsForAdUnitID:adUnitID] firstObject];
    NSLog(@"MoPub Rewarded: %s: reward = {%@, %@}", __PRETTY_FUNCTION__, reward.amount, reward.currencyType);
    [MPRewardedVideo presentRewardedVideoAdForAdUnitID:adUnitID fromViewController:self withReward:reward customData:@""];
}

/**
 * This method is called after an ad fails to load.
 *
 * @param adUnitID The ad unit ID of the ad associated with the event.
 * @param error An error indicating why the ad failed to load.
 */
- (void)rewardedVideoAdDidFailToLoadForAdUnitID:(NSString *)adUnitID error:(NSError *)error {// The operation couldn’t be completed. (MoPubRewardedVideoAdsSDKDomain error -1100.)
    NSLog(@"MoPub Rewarded: %s: error = %@", __PRETTY_FUNCTION__, error);
}

/**
 * This method is called when a previously loaded rewarded video is no longer eligible for presentation.
 *
 * @param adUnitID The ad unit ID of the ad associated with the event.
 */
- (void)rewardedVideoAdDidExpireForAdUnitID:(NSString *)adUnitID {
    NSLog(@"MoPub Rewarded: %s", __PRETTY_FUNCTION__);
}

/**
 * This method is called when an attempt to play a rewarded video fails.
 *
 * @param adUnitID The ad unit ID of the ad associated with the event.
 * @param error An error describing why the video couldn't play.
 */
- (void)rewardedVideoAdDidFailToPlayForAdUnitID:(NSString *)adUnitID error:(NSError *)error {
    NSLog(@"MoPub Rewarded: %s: error = %@", __PRETTY_FUNCTION__, error);
}

/**
 * This method is called when a rewarded video ad is about to appear.
 *
 * @param adUnitID The ad unit ID of the ad associated with the event.
 */
- (void)rewardedVideoAdWillAppearForAdUnitID:(NSString *)adUnitID {
    NSLog(@"MoPub Rewarded: %s", __PRETTY_FUNCTION__);
}

/**
 * This method is called when a rewarded video ad has appeared.
 *
 * @param adUnitID The ad unit ID of the ad associated with the event.
 */
- (void)rewardedVideoAdDidAppearForAdUnitID:(NSString *)adUnitID {
    NSLog(@"MoPub Rewarded: %s", __PRETTY_FUNCTION__);
}

/**
 * This method is called when a rewarded video ad will be dismissed.
 *
 * @param adUnitID The ad unit ID of the ad associated with the event.
 */
- (void)rewardedVideoAdWillDisappearForAdUnitID:(NSString *)adUnitID {
    NSLog(@"MoPub Rewarded: %s", __PRETTY_FUNCTION__);
}

/**
 * This method is called when a rewarded video ad has been dismissed.
 *
 * @param adUnitID The ad unit ID of the ad associated with the event.
 */
- (void)rewardedVideoAdDidDisappearForAdUnitID:(NSString *)adUnitID {
    NSLog(@"MoPub Rewarded: %s", __PRETTY_FUNCTION__);
}

/**
 * This method is called when the user taps on the ad.
 *
 * @param adUnitID The ad unit ID of the ad associated with the event.
 */
- (void)rewardedVideoAdDidReceiveTapEventForAdUnitID:(NSString *)adUnitID {
    NSLog(@"MoPub Rewarded: %s", __PRETTY_FUNCTION__);
}

/**
 * This method is called when a rewarded video ad will cause the user to leave the application.
 *
 * @param adUnitID The ad unit ID of the ad associated with the event.
 */
- (void)rewardedVideoAdWillLeaveApplicationForAdUnitID:(NSString *)adUnitID {
    NSLog(@"MoPub Rewarded: %s", __PRETTY_FUNCTION__);
}

/**
 * This method is called when the user should be rewarded for watching a rewarded video ad.
 *
 * @param adUnitID The ad unit ID of the ad associated with the event.
 * @param reward The object that contains all the information regarding how much you should reward the user.
 */
- (void)rewardedVideoAdShouldRewardForAdUnitID:(NSString *)adUnitID reward:(MPRewardedVideoReward *)reward {
    NSLog(@"MoPub Rewarded: %s: reward = {%@, %@}", __PRETTY_FUNCTION__, reward.amount, reward.currencyType);
}

/**
 Called when an impression is fired on a Rewarded Video. Includes information about the impression if applicable.
 
 @param adUnitID The ad unit ID of the rewarded video that fired the impression.
 @param impressionData Information about the impression, or @c nil if the server didn't return any information.
 */
- (void)didTrackImpressionWithAdUnitID:(NSString *)adUnitID impressionData:(MPImpressionData *)impressionData {
    NSLog(@"MoPub Rewarded: %s", __PRETTY_FUNCTION__);
}

#pragma mark -

/// Sent when the native ad will present its modal content.
- (void)willPresentModalForNativeAd:(MPNativeAd *)nativeAd {
    NSLog(@"MoPub Native: %s", __PRETTY_FUNCTION__);
}

/// Sent when a native ad has dismissed its modal content, returning control to your application.
- (void)didDismissModalForNativeAd:(MPNativeAd *)nativeAd {
    NSLog(@"MoPub Native: %s", __PRETTY_FUNCTION__);
}

/// Sent when a user is about to leave your application as a result of tapping this native ad.
- (void)willLeaveApplicationFromNativeAd:(MPNativeAd *)nativeAd {
    NSLog(@"MoPub Native: %s", __PRETTY_FUNCTION__);
}

@end

@implementation ViewController(AdMobDelegates)

/// Tells the delegate an ad request loaded an ad.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"AdMob Banner: %s", __PRETTY_FUNCTION__);
}

/// Tells the delegate an ad request failed.
- (void)adView:(GADBannerView *)adView didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"AdMob Banner: %s: error = %@", __PRETTY_FUNCTION__, [error localizedDescription]);
}

/// Tells the delegate that a full-screen view will be presented in response
/// to the user clicking on an ad.
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    NSLog(@"AdMob Banner: %s", __PRETTY_FUNCTION__);
}

/// Tells the delegate that the full-screen view will be dismissed.
- (void)adViewWillDismissScreen:(GADBannerView *)adView {
    NSLog(@"AdMob Banner: %s", __PRETTY_FUNCTION__);
}

/// Tells the delegate that the full-screen view has been dismissed.
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    NSLog(@"AdMob Banner: %s", __PRETTY_FUNCTION__);
}

/// Tells the delegate that a user click will open another app (such as
/// the App Store), backgrounding the current app.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    NSLog(@"AdMob Banner: %s", __PRETTY_FUNCTION__);
}

#pragma mark -

/// Tells the delegate an ad request succeeded.
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    NSLog(@"AdMob Inter: %s", __PRETTY_FUNCTION__);
    
    if (self.adMobInterstitial.isReady) {
        [self.adMobInterstitial presentFromRootViewController:self];
    }
}

/// Tells the delegate an ad request failed.
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"AdMob Inter: %s: error = %@", __PRETTY_FUNCTION__, [error localizedDescription]);
}

/// Tells the delegate that an interstitial will be presented.
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    NSLog(@"AdMob Inter: %s", __PRETTY_FUNCTION__);
}

/// Tells the delegate the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    NSLog(@"AdMob Inter: %s", __PRETTY_FUNCTION__);
}

/// Tells the delegate the interstitial had been animated off the screen.
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    NSLog(@"AdMob Inter: %s", __PRETTY_FUNCTION__);
}

/// Tells the delegate that a user click will open another app
/// (such as the App Store), backgrounding the current app.
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    NSLog(@"AdMob Inter: %s", __PRETTY_FUNCTION__);
}

#pragma mark -

/// Tells the delegate that the user earned a reward.
- (void)rewardedAd:(nonnull GADRewardedAd *)rewardedAd userDidEarnReward:(nonnull GADAdReward *)reward {
    NSLog(@"AdMob Rewarded: %s: reward = {%@, %@}", __PRETTY_FUNCTION__, reward.type, reward.amount.stringValue);
}

/// Tells the delegate that the rewarded ad failed to present.
- (void)rewardedAd:(nonnull GADRewardedAd *)rewardedAd didFailToPresentWithError:(nonnull NSError *)error {
    NSLog(@"AdMob Rewarded: %s: error = %@", __PRETTY_FUNCTION__, error);
}

/// Tells the delegate that the rewarded ad was presented.
- (void)rewardedAdDidPresent:(nonnull GADRewardedAd *)rewardedAd {
    NSLog(@"AdMob Rewarded: %s", __PRETTY_FUNCTION__);
}

/// Tells the delegate that the rewarded ad was dismissed.
- (void)rewardedAdDidDismiss:(nonnull GADRewardedAd *)rewardedAd {
    NSLog(@"AdMob Rewarded: %s", __PRETTY_FUNCTION__);
}

#pragma mark -

/// Called after adLoader has finished loading.
- (void)adLoaderDidFinishLoading:(nonnull GADAdLoader *)adLoader {
    NSLog(@"AdMob Native: %s", __PRETTY_FUNCTION__);
}

- (void)adLoader:(nonnull GADAdLoader *)adLoader didFailToReceiveAdWithError:(nonnull GADRequestError *)error {
    NSLog(@"AdMob Native: %s: error = %@", __PRETTY_FUNCTION__, error);
}

- (void)adLoader:(GADAdLoader *)adLoader didReceiveUnifiedNativeAd:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"AdMob Native: %s: nativeAd.headline = %@", __PRETTY_FUNCTION__, nativeAd.headline);
    
    [self UpdateNativeText:_lblTitle withValue:nativeAd.headline];
    [self UpdateNativeText:_lblDesc withValue:nativeAd.body];
    if (nativeAd.starRating == nil) {
        [self UpdateNativeText:_lblRating withValue:@""];
    } else {
        [self UpdateNativeText:_lblRating withValue:[NSString stringWithFormat:@"%@", nativeAd.starRating]];
    }
    [self UpdateNativeText:_lblSponsored withValue:nativeAd.advertiser];
    [self UpdateNativeButton:_btnCTA withValue:nativeAd.callToAction];
    
    [self UpdateNativeImage:_imgIcon withImage:nativeAd.icon.image];
    if ((nativeAd.images != nil) && (nativeAd.images.count > 0)) {
        [self UpdateNativeImage:_imgMain withImage:nativeAd.images.firstObject.image];
    }
}

/// The native ad was shown.
- (void)nativeAdDidRecordImpression:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"AdMob Native: %s", __PRETTY_FUNCTION__);
}

/// The native ad was clicked on.
- (void)nativeAdDidRecordClick:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"AdMob Native: %s", __PRETTY_FUNCTION__);
}

/// The native ad will present a full screen view.
- (void)nativeAdWillPresentScreen:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"AdMob Native: %s", __PRETTY_FUNCTION__);
}

/// The native ad will dismiss a full screen view.
- (void)nativeAdWillDismissScreen:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"AdMob Native: %s", __PRETTY_FUNCTION__);
}

/// The native ad did dismiss a full screen view.
- (void)nativeAdDidDismissScreen:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"AdMob Native: %s", __PRETTY_FUNCTION__);
}

/// The native ad will cause the application to become inactive and
/// open a new application.
- (void)nativeAdWillLeaveApplication:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"AdMob Native: %s", __PRETTY_FUNCTION__);
}

@end
