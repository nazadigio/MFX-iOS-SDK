#import "MoPubAdapterMobFox.h"
#import "MobFoxMoPubUtils.h"

@interface MoPubAdapterMobFox()

@property (strong, nonatomic) MFXBannerAd* ad;
@property (nonatomic) CGRect bannerAdRect;
@property (nonatomic, strong) NSString *adUnit;
    

@end

@implementation MoPubAdapterMobFox


- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info{
    
  //  NSLog(@"MoPub >> MobFox >> invh: %@",[info valueForKey:@"invh"]);
    NSLog(@"MoPub >> MobFox >> custom event data: %@",[info description]);
    
    self.bannerAdRect = CGRectMake(0,0, size.width, size.height);
    self.ad = [MobFoxSDK createBanner:[info valueForKey:@"invh"]
                                width:size.width
                               height:size.height
                         withDelegate:self];
  
    if(self.localExtras){
        //Demographics params should be set in you viewcontoller, under <<MPAdView object>>.localExtras
        NSString *demo_age = self.localExtras[@"demo_age"];
        if(demo_age){
            [MobFoxSDK setDemoAge:demo_age];
        }
        NSString *demo_gender = self.localExtras[@"demo_gender"];
        if(demo_gender){
            [MobFoxSDK setDemoGender:demo_gender];
        }
    }
    
    [MobFoxSDK setBannerRefresh:self.ad withSeconds:0];
    [MobFoxMoPubUtils gdprHandler];
    [MobFoxSDK loadBanner:self.ad];
}

#pragma mark MobFox Ad Delegate

- (void)bannerAdLoaded:(MFXBannerAd *)banner
{
    NSLog(@"MoPub >> MobFox >> ad loaded");
    
    UIView* bannerView = [MobFoxSDK getBannerAsView:banner];

    MPLogAdEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)], @"");

    // [self.delegate trackImpression];

    [self.delegate bannerCustomEvent:self didLoadAd:bannerView];
}

- (void)bannerAdLoadFailed:(MFXBannerAd * _Nullable)banner withError:(NSString*)error
{
    NSLog(@"MoPub >> MobFox >> error : %@",[error description]);
    
    NSString *domain = @"com.mobfox.mfxsdkcore.ErrorDomain";
    NSDictionary *userInfo = [[NSDictionary alloc]
                              initWithObjectsAndKeys:error,
                              @"NSLocalizedDescriptionKey",NULL];
    NSError* resError = [NSError errorWithDomain:domain
                                            code:-101
                                        userInfo:userInfo];
    
    MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:(NSString *)self.class error:resError], _adUnit);

    [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:resError];
}

- (void)bannerAdShown:(MFXBannerAd *)banner
{
}

- (void)bannerAdClicked:(MFXBannerAd *)banner
{
    MPLogAdEvent([MPLogEvent adTappedForAdapter:NSStringFromClass(self.class)], _adUnit);
    [self.delegate trackClick];
    [self.delegate bannerCustomEventWillLeaveApplication:self];
}

- (void)bannerAdFinished:(MFXBannerAd *)banner
{
    [self.delegate bannerCustomEventDidFinishAction:self];
}

- (void)bannerAdClosed:(MFXBannerAd *)banner
{
    
}

//===============================================================

- (void)dealloc {
    [MobFoxSDK releaseBanner:self.ad];
    self.ad = nil;
}

@end
