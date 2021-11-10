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
#import "Preferences.h"

#import "MobFoxMoPubNativeAdView.h"

#import <CoreLocation/CoreLocation.h>

@import GoogleMobileAds;

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
@property(nonatomic, strong) GADInterstitialAd *adMobInterstitial;
@property(nonatomic, strong) GADRewardedAd *adMobRewarded;
@property(nonatomic, strong) GADAdLoader *adMobAdLoader;
@property(nonatomic, strong) GADNativeAd *adMobNative;
@property(nonatomic, strong) GADNativeAdView *adMobNativeAdView;

@property (strong, nonatomic) MPAdView *mMoPubBanner;
@property (strong, nonatomic) MPInterstitialAdController *mMoPubInterstitial;
@property (strong, nonatomic) MPNativeAd *mMoPubNativeAd;
@property (strong, nonatomic) UIView* mMoPubNativeView;

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@interface ViewController(MobFoxDelegates) <MFXBannerAdDelegate, MFXInterstitialAdDelegate, MFXNativeAdDelegate>
@end

@interface ViewController(MoPubDelegates) <MPAdViewDelegate, MPInterstitialAdControllerDelegate, MPRewardedVideoDelegate, MPNativeAdDelegate>
@end

@interface ViewController(AdMobDelegates) <GADBannerViewDelegate, GADFullScreenContentDelegate, GADNativeAdLoaderDelegate, GADNativeAdDelegate>
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
            _btnRewarded.enabled =          NO;
            _btnNative.enabled =            YES;
            break;
        case ADAPTER_TYPE_MOPUB:
            _btnBannerSmall.enabled =       YES;
            _btnBannerLarge.enabled =       YES;
            _btnBannerVideo.enabled =       YES;
            _btnInterstitial.enabled =      YES;
            _btnInterstitialVideo.enabled = YES;
            _btnRewarded.enabled =          YES;
            _btnNative.enabled =            YES;
            break;
        case ADAPTER_TYPE_ADMOB:
            _btnBannerSmall.enabled =       YES;
            _btnBannerLarge.enabled =       YES;
            _btnBannerVideo.enabled =       YES;
            _btnInterstitial.enabled =      YES;
            _btnInterstitialVideo.enabled = YES;
            _btnRewarded.enabled =          YES;
            _btnNative.enabled =            YES;
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

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    [self updateTestSettings];
}

-(void)updateTestSettings
{
    Preferences *appPrefs = [Preferences sharedInstance];
    
    switch ([appPrefs getPrefIntByKey:kPref_HandleSubjectToGDPR])
    {
        case 0:
            // NOP
            break;
        case 1:
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"IABConsent_SubjectToGDPR"];
            break;
        case 2:
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"IABConsent_SubjectToGDPR"];
            break;
    }
    
    switch ([appPrefs getPrefIntByKey:kPref_HandleGDPRString])
    {
        case 0:
            // NOP
            break;
        case 1:
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"IABConsent_ConsentString"];
            break;
        case 2:
            [[NSUserDefaults standardUserDefaults] setObject:@"BOEFEAyOEFEAyAHABDENAI4AAAB9vABAASA" forKey:@"IABConsent_ConsentString"];
            break;
    }
    
    switch ([appPrefs getPrefIntByKey:kPref_HandleCOPPA])
    {
        case 0:
            // NOP
            break;
        case 1:
            [MobFoxSDK setCoppa:NO];
            break;
        case 2:
            [MobFoxSDK setCoppa:YES];
            break;
    }
    
    switch ([appPrefs getPrefIntByKey:kPref_HandleCCPA])
    {
        case 0:
            [[NSUserDefaults standardUserDefaults] setObject:@"1---" forKey:@"IABUSPrivacy_String"];
            break;
        case 1:
            [[NSUserDefaults standardUserDefaults] setObject:@"1NNN" forKey:@"IABUSPrivacy_String"];
            break;
        case 2:
            [[NSUserDefaults standardUserDefaults] setObject:@"1YNN" forKey:@"IABUSPrivacy_String"];
            break;
    }
}

/*
- (IBAction)btnSettingsPressed:(UIButton *)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Settings"
                                                                         message:nil
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak ViewController *weakSelf = self;

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"COPPA" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf presentCOPPASettings];
    }]];
    
    NSString *currCCPA = [NSUserDefaults.standardUserDefaults objectForKey:@"IABUSPrivacy_String"];
    NSString *title = ([currCCPA length]==0)?@"CCPA":[NSString stringWithFormat:@"CCPA (%@)",currCCPA];
    [actionSheet addAction:[UIAlertAction actionWithTitle:title
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf presentCCPASettings];
    }]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    actionSheet.popoverPresentationController.sourceView = sender;
    actionSheet.popoverPresentationController.sourceRect = sender.bounds;
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

- (void)presentCCPASettings {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"CCPA"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    __block UITextField *ccpaTextField = nil;

    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"Set CCPA (1/0)";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        ccpaTextField = textField;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Set" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BOOL ccpa = ccpaTextField.text.boolValue;
        [NSUserDefaults.standardUserDefaults setObject:ccpa?@"1YNN":@""
                                                forKey:@"IABUSPrivacy_String"];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
*/

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
            [self startMoPubVideoBanner];
            break;
        case ADAPTER_TYPE_ADMOB:
            [self startAdMobVideoBanner];
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
            [self startMoPubVideoInterstitial];
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
    GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers = @[ GADSimulatorID ];
    
    _locationManager = [CLLocationManager new];
    _locationManager.delegate = self;
    [_locationManager requestWhenInUseAuthorization];
    
    [self updateTabs];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self clearMobFoxNatives];
    [self clearMoPubNatives];
    [self clearAdMobNatives];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    
    [self updateTestSettings];
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
    
    [self clearAdMobNatives];
    if (self.adMobNative != nil)
    {
        self.adMobNative = nil;
    }

    //------------------------------------
    
    [self clearMoPubNatives];
    if (self.mMoPubNativeAd != nil)
    {
        self.mMoPubNativeAd = nil;
    }

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
        [_mBannerAd setBannerRefresh:30];
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
        
        [_mBannerAd setBannerRefresh:30];
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
    [self clearMoPubNatives];
    [self clearAdMobNatives];

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

-(void)clearMoPubNatives {
    if (self.mMoPubNativeView!=nil)
    {
        [self.mMoPubNativeView removeFromSuperview];
        self.mMoPubNativeView = nil;
    }
}

-(void)clearAdMobNatives {
    if (self.adMobNativeAdView!=nil)
    {
        [self.adMobNativeAdView removeFromSuperview];
        self.adMobNativeAdView = nil;
    }
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

#define MOPUB_HASH_ADAPTER_BANNER       @"234dd5a1b1bf4a5f9ab50431f9615784" // Test iOS App / Banner Ad
#define MOPUB_HASH_ADAPTER_VIDEO_BANNER @"62f37ebc4c0b40359a26af136d1e0866" // Test iOS App / Banner Video
#define MOPUB_HASH_ADAPTER_INTER        @"6aee1c416d44412ca9978b4355902d3f" // Test iOS App / iOS Inter html
#define MOPUB_HASH_ADAPTER_VIDEO_INTER  @"a5277fa1fd57418b867cfaa949df3b4a" // Test iOS App / Fullscreen Ad-demoApp
#define MOPUB_HASH_ADAPTER_REWARDED     @"e3d4c8701d4547e68e8f837fa4fe5122" // Test iOS App / iOS Rewarded
#define MOPUB_HASH_ADAPTER_NATIVE       @"ac0f139a2d9544fface76d06e27bc02a" //@"97ea9854b278483bb455c899002a3f79" // Test iOS App / Native Ad

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

- (void)startMoPubVideoBanner {
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    
    self.mMoPubBanner = [[MPAdView alloc] initWithAdUnitId:MOPUB_HASH_ADAPTER_VIDEO_BANNER];
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

- (void)startMoPubVideoInterstitial {
    self.mMoPubInterstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:MOPUB_HASH_ADAPTER_VIDEO_INTER];
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
    settings.renderingViewClass = [MobFoxMoPubNativeAdView class];
    
    MPNativeAdRendererConfiguration *config = [MPStaticNativeAdRenderer rendererConfigurationWithRendererSettings:settings];
    config.supportedCustomEvents = @[@"MobFoxMoPubNativeCustomEvent"];
    
    //NSString *strHash = @"11a17b188668469fb0412708c3d16813";
    //NSString *strHash = @"97ea9854b278483bb455c899002a3f79";
    NSString *strHash = MOPUB_HASH_ADAPTER_NATIVE;
    
    MPNativeAdRequest *adRequest = [MPNativeAdRequest requestWithAdUnitIdentifier:strHash rendererConfigurations:@[config]];
    
    MPNativeAdRequestTargeting *targeting = [MPNativeAdRequestTargeting targeting];
    targeting.desiredAssets = [NSSet setWithObjects:kAdTitleKey,
                               kAdTextKey,
                               kAdCTATextKey,
                               kAdIconImageKey,
                               kAdMainImageKey,
                               kAdStarRatingKey,
                               kAdSponsoredByCompanyKey,
                               //kAdPrivacyIconUIImageKey,
                               //kAdPrivacyIconImageUrlKey,
                               //kAdPrivacyIconClickUrlKey,
                               nil];
    targeting.keywords = @"marital:single,age:27";
    targeting.location = [[CLLocation alloc] initWithLatitude:34.1212 longitude:32.1212];
    adRequest.targeting = targeting;
    
    __weak ViewController *weakself = self;
    [adRequest startWithCompletionHandler:^(MPNativeAdRequest *request, MPNativeAd *response, NSError *error) {
        if (error) {
            NSLog(@"%s: error = %@", __PRETTY_FUNCTION__, [error description]); // Handle error.
        } else {
            __strong ViewController *strongSelf = weakself;
            
            strongSelf.mMoPubNativeAd = response;
            strongSelf.mMoPubNativeAd.delegate = strongSelf;
            strongSelf.mMoPubNativeView = [response retrieveAdViewWithError:nil];
            strongSelf.mMoPubNativeView.frame = CGRectMake(0, 0, strongSelf.viewNative.frame.size.width, strongSelf.viewNative.frame.size.height);
            
            [strongSelf.viewNative addSubview:strongSelf.mMoPubNativeView];
        }}];
}

#pragma mark - AdMob

#define ADMOB_HASH_BANNER_HTML  @"ca-app-pub-6224828323195096/7846687276"   // Test iOS - Test iOS Banner
#define ADMOB_HASH_BANNER_VIDEO @"ca-app-pub-6224828323195096/7835888455"   // Test iOS - Test iOS Banner Video
#define ADMOB_HASH_INTER_HTML   @"ca-app-pub-6224828323195096/7876284361"   // Test iOS - Test iOS Inter
#define ADMOB_HASH_INTER_VIDEO  @"ca-app-pub-6224828323195096/4477534086"   // Test iOD - inter video
#define ADMOB_HASH_INTER_REWARD @"ca-app-pub-6224828323195096/9409251358"   // Test iOS - rewarded_adunit_for_testing
#define ADMOB_HASH_NATIVE       @"ca-app-pub-6224828323195096/9365553005"   // Test iOS - AdMob Native iOS

#pragma mark Banner

- (void)startAdMobSmallBanner {
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    bannerCenterPoint = CGPointMake(w/2,140);
    [self startAdMobBannerWithSize:GADAdSizeBanner andHash:ADMOB_HASH_BANNER_HTML];
}

- (void)startAdMobLargeBanner {
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    bannerCenterPoint = CGPointMake(w/2,240);
    [self startAdMobBannerWithSize:GADAdSizeMediumRectangle andHash:ADMOB_HASH_BANNER_HTML];
}

- (void)startAdMobVideoBanner {
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    bannerCenterPoint = CGPointMake(w/2,240);
    [self startAdMobBannerWithSize:GADAdSizeMediumRectangle andHash:ADMOB_HASH_BANNER_VIDEO];
}

- (void)startAdMobBannerWithSize:(GADAdSize)size andHash:(NSString*)hashCode {
    self.adMobBannerView = [[GADBannerView alloc] initWithAdSize:size];
    
    [self.view addSubview:self.adMobBannerView];
    
    self.adMobBannerView.center = bannerCenterPoint;
    self.adMobBannerView.adUnitID = hashCode;
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
    __weak ViewController *weakSelf = self;
    [GADInterstitialAd loadWithAdUnitID:ADMOB_HASH_INTER_HTML
                                request:[GADRequest request]
                      completionHandler:^(GADInterstitialAd * _Nullable interstitialAd, NSError * _Nullable error) {
        __strong ViewController *strongSelf = weakSelf;
        
        if (error || !strongSelf) {
            return;
        }
        
        strongSelf.adMobInterstitial = interstitialAd;
        strongSelf.adMobInterstitial.fullScreenContentDelegate = strongSelf;
    }];
}

- (void)startAdMobVideoInterstitial {
    __weak ViewController *weakSelf = self;
    [GADInterstitialAd loadWithAdUnitID:ADMOB_HASH_INTER_VIDEO
                                request:[GADRequest request]
                      completionHandler:^(GADInterstitialAd * _Nullable interstitialAd, NSError * _Nullable error) {
        __strong ViewController *strongSelf = weakSelf;
        
        if (error || !strongSelf) {
            return;
        }
        
        strongSelf.adMobInterstitial = interstitialAd;
        strongSelf.adMobInterstitial.fullScreenContentDelegate = strongSelf;
    }];
}

- (void)startAdMobRewarded {
    __weak ViewController *weakSelf = self;
    [GADRewardedAd loadWithAdUnitID:ADMOB_HASH_INTER_REWARD
                            request:[GADRequest request]
                  completionHandler:^(GADRewardedAd * _Nullable rewardedAd, NSError * _Nullable error) {
        __strong ViewController *strongSelf = weakSelf;
        
        if (error || !strongSelf) {
            return;
        }
        
        strongSelf.adMobRewarded = rewardedAd;
        [strongSelf.adMobRewarded presentFromRootViewController:strongSelf userDidEarnRewardHandler:^{
            NSLog(@"AdMob Rewarded: %s: reward = {%@, %@}", __PRETTY_FUNCTION__, rewardedAd.adReward.type, rewardedAd.adReward.amount.stringValue);
        }];
    }];
}

#pragma mark Native

- (void)startAdMobNative {
    GADVideoOptions *videoOptions = [GADVideoOptions new];
    videoOptions.startMuted = YES;
    
    self.adMobAdLoader = [[GADAdLoader alloc] initWithAdUnitID:ADMOB_HASH_NATIVE
                                            rootViewController:self
                                                       adTypes:@[GADAdLoaderAdTypeNative]
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
    NSLog(@"MoPub Rewarded: ad loaded with reward = {%@, %@}", reward.amount, reward.currencyType);
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
    NSLog(@"MoPub Rewarded: %s: user should get reward = {%@, %@}", __PRETTY_FUNCTION__, reward.amount, reward.currencyType);
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

- (void)bannerViewDidReceiveAd:(GADBannerView *)bannerView {
    NSLog(@"AdMob Banner: %s", __PRETTY_FUNCTION__);
}

- (void)bannerView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"AdMob Banner: %s: error = %@", __PRETTY_FUNCTION__, [error localizedDescription]);
}

/// Tells the delegate that a full-screen view will be presented in response
/// to the user clicking on an ad.
- (void)bannerViewWillPresentScreen:(GADBannerView *)bannerView {
    NSLog(@"AdMob Banner: %s", __PRETTY_FUNCTION__);
}

/// Tells the delegate that the full-screen view will be dismissed.
- (void)bannerViewWillDismissScreen:(GADBannerView *)bannerView {
    NSLog(@"AdMob Banner: %s", __PRETTY_FUNCTION__);
}

/// Tells the delegate that the full-screen view has been dismissed.
- (void)bannerViewDidDismissScreen:(GADBannerView *)bannerView {
    NSLog(@"AdMob Banner: %s", __PRETTY_FUNCTION__);
}

#pragma mark -

- (void)adDidRecordImpression:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"AdMob Inter: %s", __PRETTY_FUNCTION__);
}

/// Tells the delegate that a click has been recorded for the ad.
- (void)adDidRecordClick:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"AdMob Inter: %s", __PRETTY_FUNCTION__);
}

/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    NSLog(@"AdMob Inter: %s: error = %@", __PRETTY_FUNCTION__, [error localizedDescription]);
}

/// Tells the delegate that the ad presented full screen content.
- (void)adDidPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"AdMob Inter: %s", __PRETTY_FUNCTION__);
}

/// Tells the delegate that the ad will dismiss full screen content.
- (void)adWillDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"AdMob Inter: %s", __PRETTY_FUNCTION__);
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"AdMob Inter: %s", __PRETTY_FUNCTION__);
}

#pragma mark -

/// Called after adLoader has finished loading.
- (void)adLoaderDidFinishLoading:(nonnull GADAdLoader *)adLoader {
    NSLog(@"AdMob Native: %s", __PRETTY_FUNCTION__);
}

- (void)adLoader:(nonnull GADAdLoader *)adLoader didFailToReceiveAdWithError:(nonnull NSError *)error {
    NSLog(@"AdMob Native: %s: error = %@", __PRETTY_FUNCTION__, error);
}

- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeAd:(GADNativeAd *)nativeAd {
    NSLog(@"AdMob Native: %s: nativeAd.headline = %@", __PRETTY_FUNCTION__, nativeAd.headline);
    
    nativeAd.delegate = self;

    // Create and place ad in view hierarchy.
    if (_adMobNativeAdView == nil)
    {
        _adMobNativeAdView = [[NSBundle mainBundle] loadNibNamed:@"UnifiedNativeAdView"
                                                           owner:nil
                                                         options:nil].firstObject;
        [_viewNative addSubview:_adMobNativeAdView];
    }
    
    // Associate the native ad view with the native ad object. This is
    // required to make the ad clickable.
    _adMobNativeAdView.nativeAd = nativeAd;

    // Set the mediaContent on the GADMediaView to populate it with available
    // video/image asset.
    _adMobNativeAdView.mediaView.mediaContent = nativeAd.mediaContent;

    // Populate the native ad view with the native ad assets.
    // The headline is guaranteed to be present in every native ad.
    ((UILabel *)_adMobNativeAdView.headlineView).text = nativeAd.headline;

    // These assets are not guaranteed to be present. Check that they are before
    // showing or hiding them.
    ((UILabel *)_adMobNativeAdView.bodyView).text = nativeAd.body;
    _adMobNativeAdView.bodyView.hidden = nativeAd.body ? NO : YES;

    [((UIButton *)_adMobNativeAdView.callToActionView)setTitle:nativeAd.callToAction
                                                forState:UIControlStateNormal];
    _adMobNativeAdView.callToActionView.hidden = nativeAd.callToAction ? NO : YES;

    ((UIImageView *)_adMobNativeAdView.iconView).image = nativeAd.icon.image;
    _adMobNativeAdView.iconView.hidden = nativeAd.icon ? NO : YES;

    NSArray<GADNativeAdImage *> *images = nativeAd.images;
    if ((images==nil) || ([images count]==0))
    {
        _adMobNativeAdView.imageView.hidden = YES;
    } else {
        ((UIImageView *)_adMobNativeAdView.imageView).image = [images firstObject].image;
        _adMobNativeAdView.imageView.hidden = NO;
    }

    ((UILabel *)_adMobNativeAdView.starRatingView).text = [NSString stringWithFormat:@"%@",nativeAd.starRating];
    _adMobNativeAdView.starRatingView.hidden = nativeAd.starRating ? NO : YES;

    ((UILabel *)_adMobNativeAdView.storeView).text = nativeAd.store;
    _adMobNativeAdView.storeView.hidden = nativeAd.store ? NO : YES;

    ((UILabel *)_adMobNativeAdView.priceView).text = nativeAd.price;
    _adMobNativeAdView.priceView.hidden = nativeAd.price ? NO : YES;

    
    ((UILabel *)_adMobNativeAdView.advertiserView).text = [nativeAd advertiser];
    _adMobNativeAdView.advertiserView.hidden = [nativeAd advertiser] ? NO : YES;

    // In order for the SDK to process touch events properly, user interaction
    // should be disabled.
    _adMobNativeAdView.callToActionView.userInteractionEnabled = NO;
}

/// The native ad was shown.

- (void)nativeAdDidRecordImpression:(GADNativeAd *)nativeAd {
    NSLog(@"AdMob Native: %s", __PRETTY_FUNCTION__);
}

/// The native ad was clicked on.
- (void)nativeAdDidRecordClick:(GADNativeAd *)nativeAd {
    NSLog(@"AdMob Native: %s", __PRETTY_FUNCTION__);
}

/// The native ad will present a full screen view.
- (void)nativeAdWillPresentScreen:(GADNativeAd *)nativeAd {
    NSLog(@"AdMob Native: %s", __PRETTY_FUNCTION__);
}

/// The native ad will dismiss a full screen view.
- (void)nativeAdWillDismissScreen:(GADNativeAd *)nativeAd {
    NSLog(@"AdMob Native: %s", __PRETTY_FUNCTION__);
}

/// The native ad did dismiss a full screen view.
- (void)nativeAdDidDismissScreen:(GADNativeAd *)nativeAd {
    NSLog(@"AdMob Native: %s", __PRETTY_FUNCTION__);
}

/// The native ad will cause the application to become inactive and
/// open a new application.
- (void)nativeAdWillLeaveApplication:(GADNativeAd *)nativeAd {
    NSLog(@"AdMob Native: %s", __PRETTY_FUNCTION__);
}

@end
