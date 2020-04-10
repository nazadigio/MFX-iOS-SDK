//
//  SettingsScreen.m
//  MFXTester
//
//  Created by Shimon Shnitzer on 31/03/2020.
//  Copyright © 2020 MobFox Mobile Advertising GmbH. All rights reserved.
//

#import "SettingsScreen.h"
#import "Preferences.h"
#import "MFXSDKCore/MFXSDKCore.h"

@interface SettingsScreen ()

@property (strong, nonatomic) IBOutlet UIView* viewAll;
@property (strong, nonatomic) IBOutlet UIButton* btnBack;

@property (strong, nonatomic) IBOutlet UISegmentedControl* seg1;
@property (strong, nonatomic) IBOutlet UISegmentedControl* seg2;
@property (strong, nonatomic) IBOutlet UISegmentedControl* seg3;
@property (strong, nonatomic) IBOutlet UISegmentedControl* seg4;

@property (strong, nonatomic) IBOutlet UILabel* lblVersion;


@end

@implementation SettingsScreen

- (IBAction)seg1ValueChanged:(id)sender
{
    Preferences *appPrefs = [Preferences sharedInstance];
    [appPrefs setPrefIntBykey:kPref_HandleSubjectToGDPR newVal:self.seg1.selectedSegmentIndex];
    [appPrefs savePrefs];
}

- (IBAction)seg2ValueChanged:(id)sender
{
    Preferences *appPrefs = [Preferences sharedInstance];
    [appPrefs setPrefIntBykey:kPref_HandleGDPRString newVal:self.seg2.selectedSegmentIndex];
    [appPrefs savePrefs];
}

- (IBAction)seg3ValueChanged:(id)sender
{
    Preferences *appPrefs = [Preferences sharedInstance];
    [appPrefs setPrefIntBykey:kPref_HandleCOPPA newVal:self.seg3.selectedSegmentIndex];
    [appPrefs savePrefs];
}

- (IBAction)seg4ValueChanged:(id)sender
{
    Preferences *appPrefs = [Preferences sharedInstance];
    [appPrefs setPrefIntBykey:kPref_HandleCCPA newVal:self.seg4.selectedSegmentIndex];
    [appPrefs savePrefs];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Preferences *appPrefs = [Preferences sharedInstance];
    
    [self.seg1 setSelectedSegmentIndex:[appPrefs getPrefIntByKey:kPref_HandleSubjectToGDPR]];
    [self.seg2 setSelectedSegmentIndex:[appPrefs getPrefIntByKey:kPref_HandleGDPRString]];
    [self.seg3 setSelectedSegmentIndex:[appPrefs getPrefIntByKey:kPref_HandleCOPPA]];
    [self.seg4 setSelectedSegmentIndex:[appPrefs getPrefIntByKey:kPref_HandleCCPA]];
    
    self.lblVersion.text = [NSString stringWithFormat:@"v%@",[MobFoxSDK sdkVersion]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
