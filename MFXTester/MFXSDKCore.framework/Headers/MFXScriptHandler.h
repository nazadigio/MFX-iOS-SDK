//
//  MobFoxScriptHandler.h
//  MobFoxSDKCore
//
//
//  Copyright © 2019 Mobfox Ltd. All rights reserved.
//

#ifndef MobFoxScriptHandler_h
#define MobFoxScriptHandler_h
#import <WebKit/WebKit.h>

@class MFXScriptHandler;

@protocol MFXScriptHandlerDelegate <NSObject>

- (void)MobFoxScriptHandlerOnSuccess;
- (void)MobFoxScriptHandlerOnReady;
- (void)MobFoxScriptHandlerOnFail:(NSString *)reason;
- (void)MobFoxScriptHandlerOnAdClose;
- (void)MobFoxScriptHandlerOnAdClick:(NSString *)url;
- (void)MobFoxScriptHandlerOnFinished;

@end


@interface MFXScriptHandler : NSObject <WKScriptMessageHandler>

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message;

@property (nonatomic, weak) id <MFXScriptHandlerDelegate> delegate;

@end


#endif /* MobFoxScriptHandler_h */
