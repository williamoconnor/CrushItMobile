//
//  ExpertSettingsViewController.m
//  CrushIt
//
//  Created by William O'Connor on 8/5/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import "ExpertSettingsViewController.h"
#import "DataManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface ExpertSettingsViewController ()

@property (strong, nonatomic) UILabel* maxConvosLabel;
@property (strong, nonatomic) UISlider* maxConvosSlider;
@property (strong, nonatomic) UISwitch* onlineSwitch;

@end

@implementation ExpertSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSNumber *height = [[NSNumber alloc] initWithDouble:screenHeight];
    NSNumber *width = [[NSNumber alloc] initWithDouble:screenWidth];
    
    self.view.backgroundColor = [UIColor colorWithRed:37/255.0 green:168/255.0 blue:234/255.0 alpha:1.0];
    
    // ONLINE TOGGLE
    self.onlineSwitch = [[UISwitch alloc] init];
    self.onlineSwitch.center = CGPointMake([width floatValue]/2, 100.0);
    [self.view addSubview: self.onlineSwitch];
    
    // ONLINE LABEL
    UILabel* onlineLabel = [[UILabel alloc] initWithFrame:CGRectMake([width floatValue]/2 + 30, 90, 60, 15)];
    onlineLabel.textColor = [UIColor whiteColor];
    onlineLabel.text = @"online";
    onlineLabel.textAlignment = NSTextAlignmentRight;
    onlineLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:onlineLabel];
    
    // OFFLINE LABEL
    UILabel* offlineLabel = [[UILabel alloc] initWithFrame:CGRectMake([width floatValue]/2 - 90, 90, 60, 15)];
    offlineLabel.textColor = [UIColor whiteColor];
    offlineLabel.text = @"offline";
    offlineLabel.textAlignment = NSTextAlignmentLeft;
    offlineLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:offlineLabel];
    
    // MAX LOAD LABEL
    self.maxConvosLabel = [[UILabel alloc] initWithFrame:CGRectMake([width floatValue]/2 - 75.0, 140.0, 150.0, 20.0)];
    [self.maxConvosLabel setText:@"Max Convos at Once:"];
    self.maxConvosLabel.textColor = [UIColor whiteColor];
    self.maxConvosLabel.textAlignment = NSTextAlignmentCenter;
    self.maxConvosLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:self.maxConvosLabel];
    
    // MAX LOAD SLIDER
    self.maxConvosSlider = [[UISlider alloc] initWithFrame:CGRectMake(30.0, 180.0, [width floatValue] - 60.0, 10.0)];
    [self.maxConvosSlider setBackgroundColor:[UIColor clearColor]];
    self.maxConvosSlider.minimumValue = 1.0;
    self.maxConvosSlider.maximumValue = 6.0;
    self.maxConvosSlider.value = 4.0;
    [self.maxConvosSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview: self.maxConvosSlider];
    
    // SAVE BUTTON
    UIButton* saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveButton.frame = CGRectMake([width floatValue]/2 - 125.0, [height floatValue] - 60, 100.0, 40.0);
    [saveButton addTarget:self
                     action:@selector(save)
           forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont fontWithName:@"Raleway-Medium" size:18.0];
    [saveButton setTitleColor:[UIColor colorWithRed:0x48/255.0 green:0x98/255.0 blue:0xBD/255.0 alpha:1.0] forState:UIControlStateNormal];
    saveButton.backgroundColor = [UIColor whiteColor];
    [saveButton.layer setBorderColor:[UIColor colorWithRed:0x1F/255.0 green:0x32/255.0 blue:0x4D/255.0 alpha:1.0].CGColor];
    [saveButton.layer setBorderWidth:1.0];
    [self.view addSubview:saveButton];
    
    // CANCEL BUTTON
    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame = CGRectMake([width floatValue]/2 + 25.0, [height floatValue] - 60.0, 100.0, 40.0);
    [cancelButton addTarget:self
                     action:@selector(cancel)
           forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"Raleway-Medium" size:18.0];
    [cancelButton setTitleColor:[UIColor colorWithRed:0x48/255.0 green:0x98/255.0 blue:0xBD/255.0 alpha:1.0] forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor whiteColor];
    [cancelButton.layer setBorderColor:[UIColor colorWithRed:0x1F/255.0 green:0x32/255.0 blue:0x4D/255.0 alpha:1.0].CGColor];
    [cancelButton.layer setBorderWidth:1.0];
    [self.view addSubview:cancelButton];
    
    // LOGOUT BUTTON
    UIButton* logoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    logoutButton.frame = CGRectMake([width floatValue] - 50.0, [height floatValue] - 110.0, [width floatValue] - 100.0, 40.0);
    [logoutButton addTarget:self
                     action:@selector(logout)
           forControlEvents:UIControlEventTouchUpInside];
    [logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    logoutButton.titleLabel.font = [UIFont fontWithName:@"Raleway-Medium" size:18.0];
    [logoutButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    logoutButton.backgroundColor = [UIColor whiteColor];
    [logoutButton.layer setBorderColor:[UIColor colorWithRed:0x1F/255.0 green:0x32/255.0 blue:0x4D/255.0 alpha:1.0].CGColor];
    [logoutButton.layer setBorderWidth:1.0];
    [self.view addSubview:logoutButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) sliderValueChanged:(id)sender
{
    UISlider* slider = (UISlider*)sender;
    int rounded = slider.value;
    //nslog(@"sender: %i", rounded);
    [slider setValue:rounded];
    [self.maxConvosLabel setText:[NSString stringWithFormat:@"%i Convos", rounded]];
}

-(void) save
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSMutableDictionary* updatedExpert = [NSMutableDictionary dictionaryWithDictionary:self.expert];
        updatedExpert[@"max_load"] = [NSNumber numberWithFloat: self.maxConvosSlider.value];
        updatedExpert[@"availability"] = [NSNumber numberWithBool:self.onlineSwitch.isOn];
        NSDictionary* update = [DataManager updateExpert:updatedExpert];
        if ([update[@"result"] isEqualToString: @"failure"]) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Settings failed to save" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

-(void) cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)logout
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"account"];
    if ([FBSDKAccessToken currentAccessToken]) {
        [FBSDKAccessToken setCurrentAccessToken:nil];
        [FBSDKProfile setCurrentProfile:nil];
    }
    
}

@end
