#import "MPMobFoxNativeAdRenderer.h"
#import "MobFoxMoPubCustomAdapter.h"


@interface MPMobFoxNativeAdRenderer ()

@property (nonatomic, strong) MobFoxMoPubCustomAdapter *adapter;
@property (nonatomic, strong) id<MPNativeAdRendererSettings> rendererSettings;
@end


@implementation MPMobFoxNativeAdRenderer

- (instancetype)initWithRendererSettings:(id<MPNativeAdRendererSettings>)rendererSettings{
    if(self = [super init]){
        self.viewSizeHandler = rendererSettings.viewSizeHandler;
        self.rendererSettings = rendererSettings;
    }
    return self;
    
}

+ (MPNativeAdRendererConfiguration *)rendererConfigurationWithRendererSettings:(id<MPNativeAdRendererSettings>)rendererSettings
{
    MPNativeAdRendererConfiguration *config =  [MPNativeAdRendererConfiguration new];
    config.rendererClass = [self class];
    config.rendererSettings = rendererSettings;
    NSArray* events = config.supportedCustomEvents;
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    for(id e in events){
        [arr addObject:e];
    }
    [arr addObject:@"MobFoxMoPubCustomEvent"];
    /*** please add to arr array your mediation class names (as 'MoPubNativeAdapterMobFox') ***/
    config.supportedCustomEvents = arr;
    return config;
    
}

- (UIView *)retrieveViewWithAdapter:(id<MPNativeAdAdapter>)adapter error:(NSError *__autoreleasing *)error {
    return nil;
}


@end



