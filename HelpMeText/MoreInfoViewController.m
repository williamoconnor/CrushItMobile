//
//  MoreInfoViewController.m
// CrushIt
//
//  Created by William O'Connor on 5/5/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import "MoreInfoViewController.h"
#import "DataManager.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import <Quickblox/Quickblox.h>
#import "CustomIOSAlertView.h"
// FACEBOOK
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface MoreInfoViewController ()

@property (strong, nonatomic) NSMutableDictionary* screen;
@property (strong, nonatomic) UITextField* ageField;
@property (strong, nonatomic) UIPickerView* genderField;
@property (strong, nonatomic) UIButton* submitButton;


// Picker stuff
@property (strong, nonatomic) UIView* genderView;
@property (strong, nonatomic) NSArray* genders;
@property (strong, nonatomic) NSArray* interests;

@end

@implementation MoreInfoViewController

-(AppDelegate*) app
{
    return (AppDelegate*) [[UIApplication sharedApplication] delegate];
}

-(NSMutableDictionary*)screen
{
    if (!_screen) {
        _screen = [[NSMutableDictionary alloc] init];
    }
    return _screen;
}

-(NSArray*)genders
{
    if (!_genders) {
        _genders = [[NSArray alloc] initWithObjects:@"Select", @"Male", @"Female", nil];
    }
    return _genders;
}

-(NSArray*)interests
{
    if (!_interests) {
        _interests = [[NSArray alloc] initWithObjects:@"Select", @"Guys", @"Girls", @"Both", nil];
    }
    return _interests;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:37/255.0 green:168/255.0 blue:234/255.0 alpha:1.0];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSNumber *height = [[NSNumber alloc] initWithDouble:screenHeight];
    NSNumber *width = [[NSNumber alloc] initWithDouble:screenWidth];
    
    self.screen[@"height"] = height;
    self.screen[@"width"] = width;
    
    float ageY = 0;
    float genderY = 0.1;

    if (![self.account objectForKey:@"age"]) {
        //field for age
        ageY = 0.05;
        genderY = 0.15;
        self.ageField = [[UITextField alloc] initWithFrame:CGRectMake(0.4*[self.screen[@"width"] floatValue], ageY*[self.screen[@"height"] floatValue], 0.2*[self.screen[@"width"] floatValue], 40.0)];
        self.ageField.placeholder = @"Age";
        self.ageField.font = [UIFont fontWithName:@"Arial" size:14.0];
        self.ageField.backgroundColor = [UIColor whiteColor];
        self.ageField.borderStyle = UITextBorderStyleRoundedRect;
        self.ageField.keyboardType = UIKeyboardTypeNumberPad;
        [self.view addSubview: self.ageField];
    }
    
    if (![self.account objectForKey:@"interested_in"] || ![self.account objectForKey:@"gender"]) {
        //field for interest    // GENDER VIEW
        
        // GENDER FIELD
        self.genderField = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, [self.screen[@"width"] floatValue], 50)];
        self.genderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, genderY*[self.screen[@"height"] floatValue], [self.screen[@"width"] floatValue], self.genderField.frame.size.height + 40.0)];
        self.genderView.backgroundColor = [UIColor whiteColor];
        self.genderField.delegate = self;
        self.genderField.dataSource = self;
        
        [self.view addSubview: self.genderView];
        [self.genderView addSubview:self.genderField];
        
        [self setGenderLabels];
    }
    
    // SUBMIT
    self.submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.submitButton.frame = CGRectMake([self.screen[@"width"] floatValue]/2 - 50.0, (genderY+0.4)*[self.screen[@"height"] floatValue], 100.0, 40.0);
    [self.submitButton addTarget:self
                          action:@selector(submit)
                forControlEvents:UIControlEventTouchUpInside];
    [self.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    self.submitButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:18.0];
    [self.submitButton setTitleColor:[UIColor colorWithRed:0x48/255.0 green:0x98/255.0 blue:0xBD/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.submitButton.backgroundColor = [UIColor whiteColor];
    [self.submitButton.layer setBorderColor:[UIColor colorWithRed:0x1F/255.0 green:0x32/255.0 blue:0x4D/255.0 alpha:1.0].CGColor];
    [self.submitButton.layer setBorderWidth:1.0];
    [self.view addSubview:self.submitButton];
    
    //BACK BUTTON
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.frame = CGRectMake(10.0, 30.0, 100.0, 40.0);
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    
    
    // DISMISS KEYBOARD
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer: tap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) submit
{
    // TODO CREATE QUICKBLOX ACCOUNT
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    BOOL good = YES;
    
    // implement standards for checking later
    if (![self.account objectForKey:@"age"]) {
        self.account[@"age"] = [f numberFromString:self.ageField.text];
    }
    
    if (![self.account objectForKey:@"gender"]) {
        self.account[@"gender"] = self.genders[[self.genderField selectedRowInComponent:0]];
    }
    
    if (![self.account objectForKey:@"interest"]) {
        self.account[@"interest"] = self.interests[[self.genderField selectedRowInComponent:1]];
    }
    
    if (![self.account objectForKey: @"age"]) {
        good = NO;
    }
    else if (![self.account objectForKey: @"gender"]) {
        good = NO;
    }
    else if (![self.account objectForKey: @"interest"]) {
        good = NO;
    }
    
    // make sure the account is good before creating
    if (good) {
////////////////
        // QUICKBLOX
        QBUUser *user = [QBUUser user];
        user.password = self.account[@"qb_code"];
        user.login = self.account[@"username"];
        user.email = self.account[@"email"];
        
        // Registration/sign up of User
        [QBRequest signUp:user successBlock:^(QBResponse *response, QBUUser *user) {
            // Sign up was successful
            // submit this shit - Data Manager
            self.account[@"qb_id"] = [NSString stringWithFormat:@"%lu", (unsigned long)user.ID];
            self.account[@"expert_id"] = @"0";
            NSMutableDictionary* submitAccount = [NSMutableDictionary dictionaryWithObject:self.account forKey:@"user"];
            if ([self validateForm]) {
                NSDictionary* dmAccount = [DataManager signUp:submitAccount];
                if (dmAccount) {
                    [[NSUserDefaults standardUserDefaults] setObject:[self userWithoutNullAvatar:dmAccount] forKey:@"account"];
                    //nslog(@"%@", dmAccount);
                    [self performSegueWithIdentifier:@"gotInfoSegue" sender:self];
                }
                else {
                    [self deleteUser:user andPassword:self.account[@"qb_code"]];
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Account Creation Failed" message:@"Please try again later" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                    [alert show];
                    if ([FBSDKAccessToken currentAccessToken]) {
                        [FBSDKAccessToken setCurrentAccessToken:nil];
                    }
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }
            else {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Form Incomplete" message:@"Please enter a value for all fields" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                [alert show];
            }
        } errorBlock:^(QBResponse *response) {
            // Handle error here
            //nslog(@"error creating user: %@", response.error.description);
            NSDictionary* errors = response.error.reasons[@"errors"];
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Sign Up Failed" message:[NSString stringWithFormat: @"Account not created for the following reasons: %@", [self errorStringFromDictionary:errors]] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }
    else {
        //nslog(@"Failed to create account");
        //nslog(@"%@", self.account);
    }
    
    
}

-(void) deleteUser:(QBUUser*)user andPassword:(NSString*)password{
    //nslog(@"user: %@", user);
    QBSessionParameters *parameters = [QBSessionParameters new];
    parameters.userLogin = user.login;
    parameters.userPassword = password;
    
    [QBRequest createSessionWithExtendedParameters:parameters successBlock:^(QBResponse *response, QBASession *session) {
        //nslog(@"created the session: %@", session);
        [QBRequest deleteUserWithID:session.userID successBlock:^(QBResponse *response) {
            //nslog(@"Deleted");
        } errorBlock:^(QBResponse *response) {
            //nslog(@"Failed to delete: %@", response.error);
        }];
    } errorBlock:^(QBResponse *response) {
        //nslog(@"did not create the session: %@", response.error);
    }];
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController* dest = segue.destinationViewController;
    HomeViewController* home = dest.viewControllers[0];
    home.isNew = @"yes";
    dest.navigationBar.topItem.title = @"Crush.it";
}

#pragma mark - picker delegate

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return [self.genders count];
    }
    else {
        return [self.interests count];
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return self.genders[row];
    }
    else {
        return self.interests[row];
    }
}

#pragma mark - picker
- (void) setGenderLabels
{
    CGSize size = self.genderView.bounds.size;
    NSInteger width = size.width;
    NSInteger height = size.height;
    
    UILabel* genderViewGenderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.2*width, 5.0, 100.0, 40.0)];
    [genderViewGenderLabel setText:@"Gender"];
    [self.genderView addSubview:genderViewGenderLabel];
    
    UILabel* genderViewInterestLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.65*width, 5.0, 100.0, 40.0)];
    [genderViewInterestLabel setText:@"Interested In"];
    [self.genderView addSubview:genderViewInterestLabel];
}

#pragma mark - keyboard
-(void) dismissKeyboard
{
    [self.ageField resignFirstResponder];
}

#pragma mark - errors

-(NSString*) errorStringFromDictionary:(NSDictionary*)errorDictionary
{
    NSString* errorString = @"";
    for (id errorType in errorDictionary) {
        //nslog(@"error index class: %@", [errorType class]);
        
        NSString* rawDescription = [errorDictionary[errorType] componentsJoinedByString:@""];
        NSString* errorDescription = [[[rawDescription stringByReplacingOccurrencesOfString:@"(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        errorString = [errorString stringByAppendingString: [NSString stringWithFormat:@"\n%@: %@", errorType, errorDescription]];
    }
    
    return errorString;
}

- (BOOL)validateForm
{
    if (![self.account[@"gender"] isKindOfClass:[NSString class]] || ((NSString*)(self.account[@"gender"])).length == 0 || [self.account[@"gender"] isEqualToString:@"Selected"]) {
        return false;
    }
    if (!(((NSNumber*)(self.account[@"age"])) > 0)) {
        return false;
    }
    if (![self.account[@"interest"] isKindOfClass:[NSString class]] || ((NSString*)(self.account[@"interest"])).length == 0 || [self.account[@"interest"] isEqualToString:@"Selected"]) {
        return false;
    }
    return true;
}

#pragma mark - backbutton
-(void) backButtonPressed
{
    //log out of facebook
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"account"];
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [FBSDKProfile setCurrentProfile:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - helper

- (NSDictionary*) userWithoutNullAvatar:(NSDictionary*)user
{
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithDictionary:user];
    
    for (NSString* key in [userDict allKeys]) {
        if ([userDict[key] isKindOfClass:[NSNull class]]){
            userDict[key] = @"";
        }
    }
    
    return userDict;
}

@end
