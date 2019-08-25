#ifndef MPMobFoxNativeAdRenderer_h
#define MPMobFoxNativeAdRenderer_h

#import <Foundation/Foundation.h>
#import <MoPubSDKFramework/MoPub.h>

@class MPNativeAdRendererConfiguration;
@class MPStaticNativeAdRendererSettings;


@interface MPMobFoxNativeAdRenderer : NSObject <MPNativeAdRenderer>

@property (nonatomic, strong) MPNativeViewSizeHandler viewSizeHandler;

+ (MPNativeAdRendererConfiguration *)rendererConfigurationWithRendererSettings:(id<MPNativeAdRendererSettings>)rendererSettings;

@end

#endif
