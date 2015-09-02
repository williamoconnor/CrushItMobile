//
//  SettingsViewController.m
// CrushIt
//
//  Created by William O'Connor on 5/5/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import "SettingsViewController.h"
#import "SignInViewController.h"
#import "DataManager.h"
// FACEBOOK
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface SettingsViewController ()

@property (strong, nonatomic) FBSDKLoginButton *loginButton;
@property (strong, nonatomic) NSMutableDictionary* screenSize;
@property (strong, nonatomic) UIButton* logoutButton;
@property (strong, nonatomic) UILabel* comingSoon;
@property (strong, nonatomic) NSMutableDictionary* purchase;
@property (strong, nonatomic) UILabel* userCorrespondencesLabel;

@end

@implementation SettingsViewController

-(NSMutableDictionary*)screenSize
{
    if (!_screenSize) {
        _screenSize = [[NSMutableDictionary alloc] init];
    }
    return _screenSize;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSNumber *height = [[NSNumber alloc] initWithDouble:screenHeight];
    NSNumber *width = [[NSNumber alloc] initWithDouble:screenWidth];
    
    self.screenSize[@"height"] = height;
    self.screenSize[@"width"] = width;
    
    self.view.backgroundColor = [UIColor colorWithRed:37/255.0 green:168/255.0 blue:234/255.0 alpha:1.0];
    
    NSDictionary* user = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    
    // FACEBOOK LOGIN
    if ([FBSDKAccessToken currentAccessToken]) { // IF THE USER LOGGED IN WITH FB
        [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
        self.loginButton = [[FBSDKLoginButton alloc] init];
        self.loginButton.center = CGPointMake([self.screenSize[@"width"] floatValue]/2, 0.1*[self.screenSize[@"height"] floatValue]);
        self.loginButton.readPermissions = @[@"public_profile", @"email"];
        [self.loginButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        [self.loginButton addObserver:self forKeyPath:@"titleLabel.text" options:NSKeyValueObservingOptionNew context:NULL];
        [self.view addSubview:self.loginButton];
    }
    else { // IF THE USER USED OUR CUSTOM ACCOUNT CREATION
        self.logoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.logoutButton.frame = CGRectMake([self.screenSize[@"width"] floatValue]/2 - 60.0, 0.1*[self.screenSize[@"height"] floatValue], 120.0, 40.0);
        [self.logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
        [self.logoutButton addObserver:self forKeyPath:@"titleLabel.text" options:NSKeyValueObservingOptionNew context:NULL];
        [self.logoutButton addTarget:self action:@selector(loggedOut) forControlEvents:UIControlEventTouchUpInside];
        [self.logoutButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.logoutButton.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.logoutButton];
    }
    
    //Get CORRESPONDENCES
    UIButton* oneCorrButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    oneCorrButton.frame = CGRectMake([width floatValue]/2 - 120, 140.0, 240.0, 40.0);
    [oneCorrButton setTitle:@"Get 1 Correspondence - $2.00" forState:UIControlStateNormal];
    oneCorrButton.backgroundColor = [UIColor whiteColor];
    [oneCorrButton addTarget:self action:@selector(buyCorrespondence:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: oneCorrButton];
    
    UIButton* threeCorrButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    threeCorrButton.frame = CGRectMake([width floatValue]/2 - 120, 220.0, 240.0, 40.0);
    [threeCorrButton setTitle:@"Get 2 Correspondences - $4.00" forState:UIControlStateNormal];
    threeCorrButton.backgroundColor = [UIColor whiteColor];
    [threeCorrButton addTarget:self action:@selector(buyCorrespondence:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: threeCorrButton];
    
    UIButton* fiveCorrButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    fiveCorrButton.frame = CGRectMake([width floatValue]/2 - 120, 300.0, 240.0, 40.0);
    [fiveCorrButton setTitle:@"Get 5 Correspondences - $12.00" forState:UIControlStateNormal];
    fiveCorrButton.backgroundColor = [UIColor whiteColor];
    [fiveCorrButton addTarget:self action:@selector(buyCorrespondence:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: fiveCorrButton];
    
    UIButton* tenCorrButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    tenCorrButton.frame = CGRectMake([width floatValue]/2 - 120, 380.0, 240.0, 40.0);
    [tenCorrButton setTitle:@"Get 10 Correspondences - $22.00" forState:UIControlStateNormal];
    tenCorrButton.backgroundColor = [UIColor whiteColor];
    [tenCorrButton addTarget:self action:@selector(buyCorrespondence:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: tenCorrButton];
    
    //DISPLAY CORRESPONDENCES
    self.userCorrespondencesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 440.0, [width floatValue], 20.0)];
    self.userCorrespondencesLabel.textAlignment = NSTextAlignmentCenter;
    self.userCorrespondencesLabel.textColor = [UIColor whiteColor];
    self.userCorrespondencesLabel.text = [NSString stringWithFormat: @"Correspondences: %@", user[@"correspondences"]];
    [self.view addSubview:self.userCorrespondencesLabel];
    
    //BACK BUTTON
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.frame = CGRectMake(2.0, 20.0, 60.0, 30.0);
    backButton.tintColor = [UIColor whiteColor];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //if ([FBSDKAccessToken currentAccessToken]) {
        if ([keyPath isEqualToString:@"titleLabel.text"]) {
            // Value changed
            if (![FBSDKAccessToken currentAccessToken]) {
                UIStoryboard *storyboard = self.storyboard;
                SignInViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"signInViewController"];
                [self presentViewController:vc animated:YES completion:nil];
            }
        }
        [self.loginButton removeObserver:self forKeyPath:@"titleLabel.text"];
    //}
}

-(void) buyCorrespondence:(id)sender
{
    NSNumber* amount = @0;
    NSNumber* cost = @0;
    UIButton* button = sender;
    if (button.frame.origin.y == 140.0) {
        amount = @1;
        cost = @2.00;
    }
    else if (button.frame.origin.y == 220.0) {
        amount = @2;
        cost = @4.00;
    }
    else if (button.frame.origin.y == 300.0) {
        amount = @5;
        cost = @12.00;
    }
    else if (button.frame.origin.y == 380.0) {
        amount = @10;
        cost = @22.00;
    }
    self.purchase = [[NSMutableDictionary alloc] init];
    self.purchase[@"correspondences"] = amount;
    self.purchase[@"email"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"][@"email"];
    
    UIAlertView* confirmPurchase = [[UIAlertView alloc] initWithTitle:@"Confirm Purchase" message:[NSString stringWithFormat:@"The %@ correspondence(s) will cost $%@", amount, cost] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
    [confirmPurchase show];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) loggedOut
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"account"];
    [self.logoutButton setTitle:@"Logged Out" forState:UIControlStateNormal];
}

- (void) logout
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"account"];
}

- (void) back
{
    if ([FBSDKAccessToken currentAccessToken]) {
        [self.loginButton removeObserver:self forKeyPath:@"titleLabel.text"];
    }
    else {
        [self.logoutButton removeObserver:self forKeyPath:@"titleLabel.text"];
    }
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - alert view delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSDictionary* result = [DataManager purchaseCorrespondence:self.purchase];
        //nslog(@"%@", result);
        [self.userCorrespondencesLabel setText:[NSString stringWithFormat: @"Correspondences: %i", [result[@"correspondences"] intValue]]];
        [[NSUserDefaults standardUserDefaults] setObject:result[@"user"] forKey:@"account"];
    }
}

@end
