//
//  MFXNativeInner.h
//  MFXSDKCore
//
//  Created by ofirkariv on 02/06/2019.
//  Copyright © 2019 MobFox Mobile Advertising GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MFXNativeInner;

@protocol MFXNativeInnerDelegate <NSObject>

@optional

- (void)nativeAdLoadFailed:(MFXNativeInner * _Nullable)native withError:(NSString*)error;
- (void)nativeAdLoaded:(MFXNativeInner *)native;
- (void)nativeAdImagesReady:(MFXNativeInner *)native;
- (void)nativeAdClicked:(MFXNativeInner *)native;

@end

@interface MFXNativeInner : NSObject <UIGestureRecognizerDelegate>


@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *invh;
@property (nonatomic, assign) BOOL      gdpr;
@property (nonatomic, strong) NSString* gdpr_consent;

@property (nonatomic) double mCPM;

@property (nonatomic, weak) id <MFXNativeInnerDelegate> delegate;


//=====================================================================


-(instancetype)initWithHash:(NSString *)invh
               withDelegate:(id <MFXNativeInnerDelegate>)delegate;

-(void)loadNativeAd;

-(void)loadNativeAdImages;

-(void)HandleNativeAdResponse:(NSDictionary*)adResponse;

-(void)registerNativeAdForInteraction:(UIView*)view;
-(void)callToActionClicked;

-(NSString*)getNativeAdLink;
-(NSDictionary*)getNativeAdTexts;
-(NSDictionary*)getNativeAdImageUrls;
-(NSDictionary*)getNativeAdImages;

-(void)setNativeAdContext:(NSString*)context;
-(void)setNativeAdPlacementType:(NSString*)placementType;

-(void)setNativeAdIconImage:(BOOL)required withSize:(NSInteger)size;
-(void)setNativeAdMainImage:(BOOL)required withSize:(CGSize)size;
-(void)setNativeAdTitle:(BOOL)required withMaxLen:(NSInteger)maxLen;
-(void)setNativeAdDesc:(BOOL)required withMaxLen:(NSInteger)maxLen;


- (void)setNativeFloorPrice:(NSNumber*)floorPrice;
- (NSNumber*)getNativeFloorPrice;




- (NSString *)getUUID;
- (NSString *)getINVH;

@end

NS_ASSUME_NONNULL_END
