//
//  MFXWebView.h
//  MFXSDKCore
//
//  Created by ofirkariv on 13/05/2019.
//  Copyright © 2019 MobFox Mobile Advertising GmbH. All rights reserved.
//

#ifndef MFXWebView_h
#define MFXWebView_h

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#import "MFXScriptHandler.h"

@class MFXWebView;

@protocol MFXWebViewAdDelegate <NSObject>

- (void)MobFoxWebViewAdClicked:(NSString*)url;
- (void)MobFoxWebViewAdReady;
- (void)MobFoxWebViewAdSucceeded;
- (void)MobFoxWebViewAdClose;
- (void)MobFoxWebViewAdFinished;

@end

@interface MFXWebView : WKWebView <MFXScriptHandlerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) id <MFXWebViewAdDelegate> adDelegate;


//+ (NSString*)tagOriginDomain;
//+ (NSString*)tagDomain;
//+ (NSString*)tagPath;

- (instancetype)initWithFrame:(CGRect)frame
                      andUUID:(NSString*)uuid
                      andINVH:(NSString*)invh
                        andVC:(UIViewController*)parentVC;

- (void)deallocateStuff;

- (void)resetWVForNextLoad;

@end

#endif /* MobFoxWebView_h */

