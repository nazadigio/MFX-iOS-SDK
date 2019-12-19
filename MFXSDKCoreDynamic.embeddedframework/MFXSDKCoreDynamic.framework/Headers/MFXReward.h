//
//  MFXReward.h
//  MFXSDKCore
//
//  Created by ofirkariv on 24/10/2019.
//  Copyright © 2019 MobFox Mobile Advertising GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFXReward : NSObject

@property (nonatomic, copy) NSString *rewardType;
@property (nonatomic, copy) NSNumber *rewardAmount;

+ (MFXReward *)rewardWithType:(NSString *)type amount:(NSNumber *)amount;

@end

NS_ASSUME_NONNULL_END
