//
//  ViewController.m
//  MFXTester
//
//  Created by ofirkariv on 24/04/2019.
//  Copyright © 2019 MobFox Mobile Advertising GmbH. All rights reserved.
//

#import "ViewController.h"
#import "MFXSDKCore/MFXSDKCore.h"



#define HASH_BANNER_HTML  @"fe96717d9875b9da4339ea5367eff1ec"
#define HASH_BANNER_VIDEO @"80187188f458cfde788d961b6882fd53"
#define HASH_INTER_HTML   @"267d72ac3f77a3f447b32cf7ebf20673"
#define HASH_INTER_VIDEO  @"80187188f458cfde788d961b6882fd53"
#define HASH_NATIVE       @"a764347547748896b84e0b8ccd90fd62"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIView* viewAll;

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



@end

@implementation ViewController

CGPoint bannerCenterPoint;

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
}

// ###############################################################################
// #####   B A N N E R                                                       #####
// ###############################################################################

- (IBAction)btnBannerSmallPressed:(id)sender
{
    
    NSLog(@"okok - version : %@", [MobFoxSDK sdkVersion]);
    [self clearAllAds];


    _mBannerAd = [MobFoxSDK createBanner:HASH_BANNER_HTML
                                                    width:10
                                                   height:10
                                             withDelegate:self];
    if (_mBannerAd!=nil)
    {
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        bannerCenterPoint = CGPointMake(w/2,140);
        [MobFoxSDK setBannerRefresh:_mBannerAd withSeconds:0];
        [MobFoxSDK loadBanner:_mBannerAd];
        

    }
    
}


- (IBAction)btnBannerLargePressed:(id)sender
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

        [MobFoxSDK setBannerRefresh:_mBannerAd withSeconds:0];

        [MobFoxSDK loadBanner:_mBannerAd];
    }
}

- (IBAction)btnVideoBannerPressed:(id)sender
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
    NSLog(@"dbg: ### bannerAdLoaded ###");
    
    [MobFoxSDK addBanner:banner toView:self.view centeredAt:bannerCenterPoint];
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

- (IBAction)btnInterstitialPressed:(id)sender
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

- (IBAction)btnRewardedPressed:(id)sender
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

- (void)interstitialAdClicked:(MFXInterstitialAd *)interstitia withUrl:(NSString*)url
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

- (IBAction)btnNativePressed:(id)sender
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



// ###############################################################################

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self clearMobFoxNatives];
}



@end
