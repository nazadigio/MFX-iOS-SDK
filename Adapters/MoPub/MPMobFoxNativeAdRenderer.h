#ifndef MPMobFoxNativeAdRenderer_h
#define MPMobFoxNativeAdRenderer_h

#import <Foundation/Foundation.h>
#if __has_include(<MoPub/MoPub.h>)
#import <MoPub/MoPub.h>
#elif __has_include(<MoPubSDKFramework/MoPub.h>)
#import <MoPubSDKFramework/MoPub.h>
#elif __has_include(<MoPub.h>)
#import <MoPub.h>
#else
#import "MPNativeAdRenderer.h"
#import "MPNativeAdRendererSettings.h"
#endif

@class MPNativeAdRendererConfiguration;
@class MPStaticNativeAdRendererSettings;


@interface MPMobFoxNativeAdRenderer : NSObject <MPNativeAdRenderer>

@property (nonatomic, strong) MPNativeViewSizeHandler viewSizeHandler;

+ (MPNativeAdRendererConfiguration *)rendererConfigurationWithRendererSettings:(id<MPNativeAdRendererSettings>)rendererSettings;

@end

#endif
