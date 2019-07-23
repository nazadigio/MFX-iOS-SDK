//
//  MFXInterstitialViewController.h
//  MFXSDKCore
//
//  Created by ofirkariv on 16/06/2019.
//  Copyright © 2019 MobFox Mobile Advertising GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFXWebView.h"
#import "MFXInterstitialInner.h"

#ifndef MFXLog
#ifdef DEBUG
#define MFXLog(_format_, ...) NSLog(_format_, ## __VA_ARGS__)
#else
#define MFXLog(_format_, ...)
#endif
#endif

@interface MFXInterstitialViewController : UIViewController <MFXWebViewAdDelegate>

@property (nonatomic,assign) bool rotateToLandscape;

- (instancetype _Nullable )initWithUUID:(NSString*_Nonnull)uuid
                     andINVH:(NSString*_Nonnull)invh;

- (void)setTagHTML:(nonnull NSString*)html
          response:(NSString*_Nullable)resp
   completionBlock:(void(^_Nullable)( NSString* _Nullable result , NSError* _Nullable error))completionBlock;

- (void)callTagFunc:(NSString*_Nullable)funcName
             params:(NSString*_Nullable)paramsJsonStr
    completionBlock:(void(^_Nullable)(NSString* _Nullable result, NSError * _Nullable error))completionBlock;

- (void)closeInterstitialVC;

- (void)pausePlay;
- (void)resumePlay;

- (NSString* _Nullable)getUUID;
- (NSString* _Nullable)getINVH;

- (void)resetVCForNextLoad;

@end
