//
//  MobFoxMoPubCustomAdapter.m
//  DemoApp
//
//
//  Copyright © 2019 Mobfox Ltd. All rights reserved.
//

#import "MobFoxMoPubCustomAdapter.h"

@interface MobFoxMoPubCustomAdapter () <MPNativeAdAdapter>

@property (nonatomic, strong) NSDictionary *adData;

@end

@implementation MobFoxMoPubCustomAdapter

- (instancetype)initWithAd:(NSDictionary *)ad {
    self = [super init];
    if (self) {
        self.localProperties = [NSMutableDictionary new];
        self.adData = ad;
    }
    return self;
}

- (NSURL *)defaultActionURL {
    return [self.localProperties objectForKey:kDefaultActionURLKey];
}

- (void)setAdData:(NSDictionary *)ad {
    _adData = ad;
    if ([ad objectForKey:@"title"]) [self.localProperties setObject:[ad objectForKey:@"title"] forKey:kAdTitleKey];
    if ([ad objectForKey:@"desc"]) [self.localProperties setObject:[ad objectForKey:@"desc"] forKey:kAdTextKey];
    if ([ad objectForKey:@"icon"]) [self.localProperties setObject:[ad objectForKey:@"icon"] forKey:kAdIconImageKey];
    if ([ad objectForKey:@"main"]) [self.localProperties setObject:[ad objectForKey:@"main"] forKey:kAdMainImageKey];
    if ([ad objectForKey:@"ctatext"]) [self.localProperties setObject:[ad objectForKey:@"ctatext"] forKey:kAdCTATextKey];
    if ([ad objectForKey:@"rating"]) [self.localProperties setObject:[ad objectForKey:@"rating"] forKey:kAdStarRatingKey];
    if ([ad objectForKey:@"url"]) [self.localProperties setObject:[ad objectForKey:@"url"] forKey:kDefaultActionURLKey];
    
    /*
     [self UpdateNativeText:_lblRating    withValue:[ad objectForKey:@"rating"]];
     [self UpdateNativeText:_lblSponsored withValue:[ad objectForKey:@"sponsored"]];
     
     [self UpdateNativeImage:_imgIcon withValue:[ad objectForKey:@"icon"]];
     [self UpdateNativeImage:_imgMain withValue:[ad objectForKey:@"main"]];
     }
     */
    /* The next feature is native video, and was not developed in mobfox yet.
     self.localProperties[kVASTVideoKey] = ad.vastString;  */
}

/*
 - (NSURL *)defaultActionURL {
 return nil;
 }
 
 - (void)willAttachToView:(UIView *)view {
 if (!view) {
 return;
 }
 dispatch_async(dispatch_get_main_queue(), ^{
 for (MFXNativeTracker* impressionTracker in _adData.trackersArray) {
 if ([impressionTracker.url absoluteString].length > 0)
 {
 
 
 UIWebView* wv = [[UIWebView alloc] initWithFrame:CGRectZero];
 NSString* userAgent = [wv stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
 NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
 configuration.HTTPAdditionalHeaders = @{ @"User-Agent" : userAgent };
 
 static NSURLSession * sharedSessionMainQueue = nil;
 if(!sharedSessionMainQueue){
 sharedSessionMainQueue = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
 }
 NSURLSessionDataTask* task = [sharedSessionMainQueue dataTaskWithURL:impressionTracker.url completionHandler:
 ^(NSData *data,NSURLResponse *response, NSError *error){
 
 if(error) NSLog(@"err %@",[error description]);
 }];
 wv = nil;
 [task resume];
 
 
 
 }
 }
 
 
 });
 
 //  [self.ad registerViewForInteraction:view forClickableSubviews:nil];
 }
 
 
 
 - (void)trackClick{
 
 for (MFXNativeTracker* clickTracker in _adData.clickTrackersArray) {
 if ([clickTracker.url absoluteString].length > 0)
 {
 // Fire tracking pixel
 UIWebView* wv = [[UIWebView alloc] initWithFrame:CGRectZero];
 NSString* userAgent = [wv stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
 NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
 configuration.HTTPAdditionalHeaders = @{ @"User-Agent" : userAgent };
 
 static NSURLSession * sharedSessionMainQueue = nil;
 if(!sharedSessionMainQueue){
 sharedSessionMainQueue = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
 }
 NSURLSessionDataTask* task = [sharedSessionMainQueue dataTaskWithURL:clickTracker.url completionHandler:
 ^(NSData *data,NSURLResponse *response, NSError *error){
 
 if(error) NSLog(@"err %@",[error description]);
 }];
 [task resume];
 
 }
 
 }
 }
 */

- (void)displayContentForURL:(NSURL *)URL rootViewController:(UIViewController *)controller {
    // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.localProperties objectForKey:kDefaultActionURLKey]]];
}

- (NSDictionary *)properties {
    return self.localProperties;
}

@end
