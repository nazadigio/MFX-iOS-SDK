//
//  Preferences.m
//  MFXTester
//
//  Created by Shimon Shnitzer on 31/03/2020.
//  Copyright © 2020 MobFox Mobile Advertising GmbH. All rights reserved.
//

#import "Preferences.h"

@implementation Preferences

@synthesize prefsDict;
@synthesize prefsFilePath;

static Preferences *sharedInstance = nil;

//-------------------------------------------------------

- (NSInteger)getPrefIntByKey:(NSString *)prefKey
{
    if (prefKey==nil) return 0;
    NSNumber *addr = [prefsDict objectForKey:prefKey];
    if (addr!=nil)
    {
        return [addr integerValue];
    }
    return 0;
}

- (NSInteger )getPrefIntByKey:(NSString *)prefKey defVal:(NSInteger)defVal
{
    if (prefKey==nil) return defVal;
    NSNumber *addr = [prefsDict objectForKey:prefKey];
    if (addr!=nil)
    {
        return [addr integerValue];
    }
    return defVal;
}

- (void)setPrefIntBykey:(NSString *)prefKey newVal:(NSInteger)newVal
{
    if (prefKey==nil) return;
    [prefsDict setObject:[NSNumber numberWithInteger:newVal] forKey:prefKey];
}

//-------------------------------------------------------

+ (Preferences *)sharedInstance {
    
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

- (void)initPrefsFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    self.prefsFilePath = [documentsDirectory stringByAppendingPathComponent:@"appPrefs.xml"];
}


// Load the prefs from file, if the file does not exist it is created
// and some defaults set
- (void)loadPrefs {
    
    // If the preferences file path is not yet set, ensure it is initialised
    if (prefsFilePath == nil) {
        [self initPrefsFilePath];
    }
    
    // If the preferences file exists, then load it
    if ([[NSFileManager defaultManager] fileExistsAtPath:prefsFilePath])
    {
        // Changed after build 1.60: analyze memory leaks
        //self.prefsDict = [[NSMutableDictionary alloc] initWithContentsOfFile:prefsFilePath];
        prefsDict = [[NSMutableDictionary alloc] initWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:prefsFilePath] copyItems:TRUE];
    } else {
        // Changed after build 1.60: analyze memory leaks
        //self.prefsDict = [[NSMutableDictionary alloc] init];
        prefsDict = [[NSMutableDictionary alloc] init];
    }
}


- (void)savePrefs {
    
    // Changed after build 1.60: analyze memory leaks
    //[prefsDict writeToFile:prefsFilePath atomically:YES];
    [NSKeyedArchiver archiveRootObject:prefsDict toFile:prefsFilePath];
    
}

-(id)init {
    
    if (self = [super init]) {
        
        // Load or init the preferences
        [self loadPrefs];
    }
    
    return self;
}

- (void)dealloc {
    
    // Ensure the prefs are saved
    [self savePrefs];
}

@end
