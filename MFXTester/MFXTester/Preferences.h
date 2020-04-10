//
//  Preferences.h
//  MFXTester
//
//  Created by Shimon Shnitzer on 31/03/2020.
//  Copyright © 2020 MobFox Mobile Advertising GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kPref_HandleSubjectToGDPR @"kPref_HandleSubjectToGDPR"
#define kPref_HandleGDPRString    @"kPref_HandleGDPRString"
#define kPref_HandleCOPPA         @"kPref_HandleCOPPA"
#define kPref_HandleCCPA          @"kPref_HandleCCPA"

@interface Preferences : NSObject {
        
    NSMutableDictionary *prefsDict;
    NSString *prefsFilePath;
}

@property (nonatomic,retain) NSMutableDictionary *prefsDict;
@property (nonatomic,retain) NSString *prefsFilePath;

+ (Preferences *)sharedInstance;
- (void)savePrefs;

- (NSInteger)getPrefIntByKey:(NSString *)prefKey;
- (NSInteger)getPrefIntByKey:(NSString *)prefKey defVal:(NSInteger)defVal;
- (void)setPrefIntBykey:(NSString *)prefKey newVal:(NSInteger)newVal;

@end

NS_ASSUME_NONNULL_END
