//
//  MFMediatedNativeContentAd.m
//  Adapters
//
//  Created by Shimi Sheetrit on 1/1/17.
//  Copyright © 2017 Matomy Media Group Ltd. All rights reserved.
//

#import "MFMediatedNativeContentAd.h"
#import "MFNativeAdImage.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface MFMediatedNativeContentAd()

@property (nonatomic, strong) MFXNativeAd *mfNative;

@property(nonatomic, strong) GADUnifiedNativeAd *gadNative;

/// Headline.
@property(nonatomic, copy, nullable) NSString *my_headline;

/// Description.
@property(nonatomic, copy, nullable) NSString *my_body;

/// Text that encourages user to take some action with the ad. For example "Install".
@property(nonatomic, copy, nullable) NSString *my_callToAction;

/// App store rating (0 to 5).
@property(nonatomic, copy, nullable) NSDecimalNumber *my_starRating;

/// The app store name. For example, "App Store".
@property(nonatomic, copy, nullable) NSString *my_store;

/// String representation of the app's price.
@property(nonatomic, copy, nullable) NSString *my_price;

/// Identifies the advertiser. For example, the advertiser’s name or visible URL.
@property(nonatomic, copy, nullable) NSString *my_advertiser;

/// Icon image.
@property(nonatomic, nullable) GADNativeAdImage *my_icon;

/// Array of GADNativeAdImage objects.
@property(nonatomic, nullable) NSArray<GADNativeAdImage *> *my_images;

@end

@implementation MFMediatedNativeContentAd

@synthesize advertiser;

- (instancetype)initWithMFNativeContentAd:(MFXNativeAd *)mfNative {
    if (mfNative == nil) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        
        self.mfNative = mfNative;
        //self.gadNative = [[GADNativeAd alloc] init];
        
        NSDictionary *dictTexts  = [MobFoxSDK getNativeAdTexts:mfNative];
                
        self.my_headline     = [dictTexts objectForKey:@"title"];
        self.my_body         = [dictTexts objectForKey:@"desc"];
        self.my_starRating   = [[NSDecimalNumber alloc] initWithString:[dictTexts objectForKey:@"rating"]];
        self.my_advertiser   = [dictTexts objectForKey:@"sponsored"];
        self.my_callToAction = [dictTexts objectForKey:@"ctatext"];
        //self.my_store        = [dictTexts objectForKey:@"store"];
        
        NSDictionary *dictImageUrls = [MobFoxSDK getNativeAdImageUrls:mfNative];
        NSDictionary *dictImages = [MobFoxSDK getNativeAdImages:mfNative];
        
        NSString *iconUrl = [dictImageUrls objectForKey:@"icon"];
        UIImage *iconImg = [dictImages objectForKey:@"icon"];
        if (iconUrl != nil && iconImg != nil) {
            self.my_icon = [[MFNativeAdImage alloc] initWithURL:iconUrl
                                                       andImage:iconImg];
        }
        
        NSString *mainUrl = [dictImageUrls objectForKey:@"main"];
        UIImage *mainImg = [dictImages objectForKey:@"main"];
        if (mainUrl != nil && mainImg != nil) {
            self.my_images = @[
                [[MFNativeAdImage alloc] initWithURL:mainUrl andImage:mainImg]
            ];
        }
    }

    return self;
}

- (NSString *)headline {
    return self.my_headline;
}
    
- (NSArray *)images {
    return self.my_images;
}
    
- (NSString *)body {
    return self.my_body;
}
    
- (GADNativeAdImage *)icon {
    return self.my_icon;
}
    
- (NSString *)callToAction {
    return self.my_callToAction;
}
    
- (NSDecimalNumber *)starRating {
    return self.my_starRating;
}
    
- (NSString *)store {
    return self.my_store;
}
    
- (NSString *)price {
    return self.my_price;
}
    
- (NSString *)advertiser {
    return self.my_advertiser;
}

- (NSDictionary *)extraAssets {
    return nil;//self.extras;
}
    
#pragma mark - Impressions and Clicks
    
- (void)didRecordImpression {
}

- (void)didRecordClickOnAssetWithName:(GADUnifiedNativeAssetIdentifier)assetName
                                 view:(UIView *)view
                       viewController:(UIViewController *)viewController {
    [self.mfNative callToActionClicked];
}

@end
