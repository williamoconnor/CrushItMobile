//
//  SignUpViewController.m
// CrushIt
//
//  Created by William O'Connor on 5/3/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import "SignUpViewController.h"
#import "DataManager.h"
#import "HomeViewController.h"
#import <Quickblox/Quickblox.h>

@interface SignUpViewController ()

@property (strong, nonatomic) NSMutableDictionary* screen;
@property (strong, nonatomic) UIScrollView* signupForm;

@property (strong, nonatomic) UITextField* emailField;
@property (strong, nonatomic) UITextField* passwordField;
@property (strong, nonatomic) UITextField* usernameField;
@property (strong, nonatomic) UIPickerView* genderField;
@property (strong, nonatomic) UITextField* ageField;
@property (strong, nonatomic) UIButton* signInButton;
@property (strong, nonatomic) UIButton* cancelButton;

// Picker stuff
@property (strong, nonatomic) UIView* genderView;
@property (strong, nonatomic) UIButton* genderButton;
@property (strong, nonatomic) NSArray* genders;
@property (strong, nonatomic) NSArray* interests;

@end


@implementation SignUpViewController

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
    
    self.screen = [[NSUserDefaults standardUserDefaults] objectForKey:@"screen"];
    self.view.backgroundColor = [UIColor colorWithRed:37/255.0 green:168/255.0 blue:234/255.0 alpha:1.0];
    [self registerForKeyboardNotifications];
    
    // Scroll View
    self.signupForm = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, [self.screen[@"width"] floatValue], [self.screen[@"height"] floatValue])];
    self.signupForm.contentSize = CGSizeMake([self.screen[@"width"] floatValue], [self.screen[@"height"] floatValue]);
    self.signupForm.backgroundColor = [UIColor clearColor];
    self.signupForm.showsVerticalScrollIndicator = YES;
    [self.view addSubview:self.signupForm];
    
    // GET EMAIL
    self.emailField = [[UITextField alloc] initWithFrame:CGRectMake(0.2*[self.screen[@"width"] floatValue], 0.2*[self.screen[@"height"] floatValue], 0.6*[self.screen[@"width"] floatValue], 40.0)];
    self.emailField.placeholder = @"Email";
    self.emailField.font = [UIFont fontWithName:@"Arial" size:14.0];
    self.emailField.backgroundColor = [UIColor whiteColor];
    self.emailField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.signupForm addSubview: self.emailField];
    
    // GET PASSWORD
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(0.2*[self.screen[@"width"] floatValue], 0.3*[self.screen[@"height"] floatValue], 0.6*[self.screen[@"width"] floatValue], 40.0)];
    self.passwordField.placeholder = @"Password";
    self.passwordField.font = [UIFont fontWithName:@"Arial" size:14.0];
    self.passwordField.backgroundColor = [UIColor whiteColor];
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordField.secureTextEntry = YES;
    self.passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.signupForm addSubview: self.passwordField];
    
    // GET USERNAME
    self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake(0.2*[self.screen[@"width"] floatValue], 0.4*[self.screen[@"height"] floatValue], 0.6*[self.screen[@"width"] floatValue], 40.0)];
    self.usernameField.placeholder = @"Username";
    self.usernameField.font = [UIFont fontWithName:@"Arial" size:14.0];
    self.usernameField.backgroundColor = [UIColor whiteColor];
    self.usernameField.borderStyle = UITextBorderStyleRoundedRect;
    self.usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.signupForm addSubview: self.usernameField];
    
    
    // GET AGE
    self.ageField = [[UITextField alloc] initWithFrame:CGRectMake(0.4*[self.screen[@"width"] floatValue], 0.5*[self.screen[@"height"] floatValue], 0.2*[self.screen[@"width"] floatValue], 40.0)];
    self.ageField.placeholder = @"Age";
    self.ageField.font = [UIFont fontWithName:@"Arial" size:14.0];
    self.ageField.backgroundColor = [UIColor whiteColor];
    self.ageField.borderStyle = UITextBorderStyleRoundedRect;
    self.ageField.keyboardType = UIKeyboardTypeNumberPad;
    [self.signupForm addSubview: self.ageField];
    
    // GENDER VIEW
    self.genderView = [[UIView alloc] initWithFrame:CGRectMake(0.2*[self.screen[@"width"] floatValue], 0.6*[self.screen[@"height"] floatValue], 0.6*[self.screen[@"width"] floatValue], 40)];
    self.genderView.backgroundColor = [UIColor whiteColor];
    self.genderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.genderButton.frame = CGRectMake(0.0*[self.screen[@"width"] floatValue], 0.0, 0.6*[self.screen[@"width"] floatValue], 40.0);
    [self.genderButton setTitle:@"Gender" forState:UIControlStateNormal];
    self.genderButton.tintColor = [UIColor lightGrayColor];
    [self.genderButton addTarget:self action:@selector(expandPicker) forControlEvents:UIControlEventTouchUpInside];
    [self.genderView addSubview:self.genderButton];
    [self.signupForm addSubview: self.genderView];
    
    // GENDER FIELD
    self.genderField = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, [self.screen[@"width"] floatValue], 50)];
    self.genderField.delegate = self;
    self.genderField.dataSource = self;
    
    // SUBMIT
    self.signInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.signInButton.frame = CGRectMake([self.screen[@"width"] floatValue]/2 - 50.0, 0.8*[self.screen[@"height"] floatValue], 100.0, 40.0);
    [self.signInButton addTarget:self
                     action:@selector(submit)
           forControlEvents:UIControlEventTouchUpInside];
    [self.signInButton setTitle:@"Submit" forState:UIControlStateNormal];
    self.signInButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:18.0];
    [self.signInButton setTitleColor:[UIColor colorWithRed:0x48/255.0 green:0x98/255.0 blue:0xBD/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.signInButton.backgroundColor = [UIColor whiteColor];
    [self.signInButton.layer setBorderColor:[UIColor colorWithRed:0x1F/255.0 green:0x32/255.0 blue:0x4D/255.0 alpha:1.0].CGColor];
    [self.signInButton.layer setBorderWidth:1.0];
    [self.signupForm addSubview:self.signInButton];
    
    // Cancel Button
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.cancelButton.frame = CGRectMake([self.screen[@"width"] floatValue]/2 - 50.0, 0.9*[self.screen[@"height"] floatValue], 100.0, 40.0);
    [self.cancelButton addTarget:self
                     action:@selector(cancel)
           forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.cancelButton.backgroundColor = [UIColor clearColor];
    self.cancelButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:14.0];
    [self.signupForm addSubview: self.cancelButton];
    
    // DISMISS KEYBOARD
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer: tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) submit
{
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSString* username = self.usernameField.text;
    NSString* password = self.passwordField.text;
    NSString* email = self.emailField.text;
    NSNumber* age = [f numberFromString:self.ageField.text];
    NSString* gender = self.genders[[self.genderField selectedRowInComponent:0]];
    NSString* interest = self.interests[[self.genderField selectedRowInComponent:1]];
    
    NSMutableDictionary* account = [[NSMutableDictionary alloc] init];
    BOOL good = YES;
    
    // implement standards for checking later
    if (username) {
        account[@"username"] = username;
    }
    else {
        good = NO;
        //alertView
    }
    
    if (password) {
        account[@"password"] = password;
        account[@"qb_code"] = password;
    }
    else {
        good = NO;
        //alertView
    }
    
    if (email) {
        account[@"email"] = email;
    }
    else {
        good = NO;
        //alertView
    }
    
    if (age) {
        account[@"age"] = age;
    }
    else {
        good = NO;
        //alertView
    }
    
    if (gender) {
        account[@"gender"] = gender;
    }
    else {
        good = NO;
        //alertView
    }
    
    if (interest) {
        account[@"interest"] = interest;
    }
    else {
        good = NO;
        //alertView
    }
    
    account[@"expert_id"] = @"0";
    
    // make sure the account is good before creating
    if (good == YES) {
        
        // QUICKBLOX
        QBUUser *user = [QBUUser user];
        user.password = password;
        user.login = username;
        user.email = email;
        
        // Registration/sign up of User
        [QBRequest signUp:user successBlock:^(QBResponse *response, QBUUser *user) {
            // Sign up was successful
            // submit this shit - Data Manager
            account[@"qb_id"] = [NSString stringWithFormat:@"%lu", (unsigned long)user.ID];
            NSMutableDictionary* submitAccount = [NSMutableDictionary dictionaryWithObject:account forKey:@"user"];
            if ([self validateForm:submitAccount]) {
                NSDictionary* dmAccount = [DataManager signUp:submitAccount];
                if (dmAccount) {
                    [[NSUserDefaults standardUserDefaults] setObject:[self userWithoutNullAvatar:dmAccount] forKey:@"account"];
                    //nslog(@"data manager: %@", dmAccount);
                    [self performSegueWithIdentifier:@"accountCreatedSegue" sender:self];
                }
                else {
                    // sign in to admin, delete user, and sign out
                    [self deleteUser:user andPassword:password];
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Account Creation Failed" message:@"Please try again later" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                    [alert show];
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
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Sign Up Failed" message: @"Please make sure that all fields are completed properly" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
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

#pragma mark - UIPickerView Delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
//    if (pickerView == self.genderField) {
//        return [self.genders count];
//    }
//    else {
//        return [self.interests count];
//    }
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (component == 0) {
        return [self.genders count];
    }
    else {
        return [self.interests count];
    }
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

#pragma mark - Picker Animation

- (void) expandPicker
{
    [self resignFirstResponder];
    CGRect genderFrame = self.genderView.frame;
    CGRect submitFrame = self.signInButton.frame;
    CGRect cancelFrame = self.cancelButton.frame;
    CGSize scrollSize = self.signupForm.contentSize;
    
    
    self.genderView.frame = CGRectMake(0.0, genderFrame.origin.y, [self.screen[@"width"] floatValue], self.genderField.frame.size.height + 40.0);
    [self.genderView addSubview:self.genderField];
    
    self.signupForm.contentSize = CGSizeMake(scrollSize.width, scrollSize.height+100);
    self.signInButton.frame = CGRectMake(submitFrame.origin.x, submitFrame.origin.y + 100.0, submitFrame.size.width, submitFrame.size.height);
    self.cancelButton.frame = CGRectMake(cancelFrame.origin.x, cancelFrame.origin.y + 100.0, cancelFrame.size.width, cancelFrame.size.height);
    
    // set labels
    [self setGenderLabels];
}

- (void) setGenderLabels
{
    CGSize size = self.genderView.bounds.size;
    NSInteger width = size.width;
    NSInteger height = size.height;
    
    self.genderButton.hidden = YES;
    UILabel* genderViewGenderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.2*width, 5.0, 100.0, 40.0)];
    [genderViewGenderLabel setText:@"Gender"];
    [self.genderView addSubview:genderViewGenderLabel];
    
    UILabel* genderViewInterestLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.65*width, 5.0, 100.0, 40.0)];
    [genderViewInterestLabel setText:@"Interested In"];
    [self.genderView addSubview:genderViewInterestLabel];
}

# pragma mark - keyboard

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.signupForm.contentInset = contentInsets;
    self.signupForm.scrollIndicatorInsets = contentInsets;
    
    // get the active field
    UIView* activeField;
    if (self.emailField.isFirstResponder) {
        //nslog(@"email");
        activeField = self.emailField;
    }
    else if (self.passwordField.isFirstResponder) {
        //nslog(@"password");
        activeField = self.passwordField;
    }
    else if (self.usernameField.isFirstResponder) {
        //nslog(@"username");
        activeField = self.usernameField;
    }
    else if (self.ageField.isFirstResponder) {
        //nslog(@"age");
        activeField = self.ageField;
    }
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
        [self.signupForm setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.signupForm.contentInset = contentInsets;
    self.signupForm.scrollIndicatorInsets = contentInsets;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController* dest = segue.destinationViewController;
    HomeViewController* home = dest.viewControllers[0];
    home.isNew = @"yes";
    dest.navigationBar.topItem.title = @"Crush.it";
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

- (BOOL)validateForm:(NSMutableDictionary*)form
{
    if (![form[@"gender"] isKindOfClass:[NSString class]] || ((NSString*)(form[@"gender"])).length == 0 || [form[@"gender"] isEqualToString:@"Selected"]) {
        return false;
    }
    if (!(((NSNumber*)(form[@"age"])) > 0)) {
        return false;
    }
    if (![form[@"interest"] isKindOfClass:[NSString class]] || ((NSString*)(form[@"interest"])).length == 0 || [form[@"interest"] isEqualToString:@"Selected"]) {
        return false;
    }
    if (![self.emailField.text isKindOfClass:[NSString class]] || self.emailField.text.length == 0) {
        return false;
    }
    if (![self.passwordField.text isKindOfClass:[NSString class]] || self.passwordField.text.length == 0) {
        return false;
    }
    if (![self.emailField.text isKindOfClass:[NSString class]] || self.emailField.text.length == 0) {
        return false;
    }
    if (![self.usernameField.text isKindOfClass:[NSString class]] || self.usernameField.text.length == 0) {
        return false;
    }
    return true;
}

@end
