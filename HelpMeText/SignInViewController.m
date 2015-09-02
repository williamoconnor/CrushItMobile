//
//  ViewController.m
// CrushIt
//
//  Created by William O'Connor on 5/3/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import "SignInViewController.h"
#import "DataManager.h"
#import "MoreInfoViewController.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
// FACEBOOK
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Quickblox/Quickblox.h>

@interface SignInViewController ()

@property (strong, nonatomic) NSMutableDictionary* screenSize;
@property (strong, nonatomic) UITextField* emailField;
@property (strong, nonatomic) UITextField* passwordField;
@property (strong, nonatomic) FBSDKLoginButton *loginButton;
@property (strong, nonatomic) NSMutableDictionary* account;

@end

@implementation SignInViewController

-(AppDelegate*) app
{
    return (AppDelegate*) [[UIApplication sharedApplication] delegate];
}

-(NSMutableDictionary*)screenSize
{
    if (!_screenSize) {
        _screenSize = [[NSMutableDictionary alloc] init];
    }
    return _screenSize;
}

-(NSMutableDictionary*)account
{
    if (!_account) {
        _account = [[NSMutableDictionary alloc] init];
    }
    return _account;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"account"];
    
    //nslog(@"Account: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"account"]);
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSNumber *height = [[NSNumber alloc] initWithDouble:screenHeight];
    NSNumber *width = [[NSNumber alloc] initWithDouble:screenWidth];
    
    self.screenSize[@"height"] = height;
    self.screenSize[@"width"] = width;
    //nslog(@"%@", self.screenSize);
    
    [[NSUserDefaults standardUserDefaults] setObject:self.screenSize forKey:@"screen"];
    
    self.view.backgroundColor = [UIColor colorWithRed:37/255.0 green:168/255.0 blue:234/255.0 alpha:1.0];
    
    // FACEBOOK LOGIN
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    self.loginButton = [[FBSDKLoginButton alloc] init];
    self.loginButton.center = CGPointMake([self.screenSize[@"width"] floatValue]/2, 0.1*[self.screenSize[@"height"] floatValue]);
    self.loginButton.readPermissions = @[@"public_profile", @"email"];
    [self.loginButton addObserver:self forKeyPath:@"titleLabel.text" options:NSKeyValueObservingOptionNew context:NULL];
    [self.view addSubview:self.loginButton];
    
    // OR LABEL
    UILabel* orLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.2*[self.screenSize[@"width"] floatValue], 0.125*[self.screenSize[@"height"] floatValue], 0.6*[self.screenSize[@"width"] floatValue], 40.0)];
    orLabel.textAlignment = NSTextAlignmentCenter;
    [orLabel setText:@"or"];
    [self.view addSubview:orLabel];
    
    // GET EMAIL
    self.emailField = [[UITextField alloc] initWithFrame:CGRectMake(0.2*[self.screenSize[@"width"] floatValue], 0.2*[self.screenSize[@"height"] floatValue], 0.6*[self.screenSize[@"width"] floatValue], 40.0)];
    self.emailField.placeholder = @"Email";
    self.emailField.font = [UIFont fontWithName:@"Raleway" size:14.0];
    self.emailField.backgroundColor = [UIColor whiteColor];
    self.emailField.borderStyle = UITextBorderStyleRoundedRect;
    //    [self.emailField.layer setBorderColor:[UIColor colorWithRed:0x1F/255.0 green:0x32/255.0 blue:0x4D/255.0 alpha:1.0].CGColor];
    //    [self.emailField.layer setBorderWidth:1.0];
    self.emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview: self.emailField];
    
    // GET PASSWORD
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(0.20*[self.screenSize[@"width"] floatValue], 0.3*[self.screenSize[@"height"] floatValue], 0.6*[self.screenSize[@"width"] floatValue], 40.0)];
    self.passwordField.placeholder = @"Password";
    self.passwordField.font = [UIFont fontWithName:@"Raleway" size:14.0];
    self.passwordField.backgroundColor = [UIColor whiteColor];
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordField.secureTextEntry = YES;
    //    [self.emailField.layer setBorderColor:[UIColor colorWithRed:0x1F/255.0 green:0x32/255.0 blue:0x4D/255.0 alpha:1.0].CGColor];
    //    [self.emailField.layer setBorderWidth:1.0];
    self.passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview: self.passwordField];
    
    // SUBMIT
    UIButton* signInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    signInButton.frame = CGRectMake([self.screenSize[@"width"] floatValue]/2 - 125.0, 0.4*[self.screenSize[@"height"] floatValue], 100.0, 40.0);
    [signInButton addTarget:self
                     action:@selector(submit)
           forControlEvents:UIControlEventTouchUpInside];
    [signInButton setTitle:@"Sign In" forState:UIControlStateNormal];
    signInButton.titleLabel.font = [UIFont fontWithName:@"Raleway" size:18.0];
    [signInButton setTitleColor:[UIColor colorWithRed:0x48/255.0 green:0x98/255.0 blue:0xBD/255.0 alpha:1.0] forState:UIControlStateNormal];
    signInButton.backgroundColor = [UIColor whiteColor];
    [signInButton.layer setBorderColor:[UIColor colorWithRed:0x1F/255.0 green:0x32/255.0 blue:0x4D/255.0 alpha:1.0].CGColor];
    [signInButton.layer setBorderWidth:1.0];
    [self.view addSubview:signInButton];
    
    // create account
    UIButton* signupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    signupButton.frame = CGRectMake([self.screenSize[@"width"] floatValue]/2 + 25.0, 0.4*[self.screenSize[@"height"] floatValue], 100.0, 40.0);
    [signupButton addTarget:self
                     action:@selector(signup)
           forControlEvents:UIControlEventTouchUpInside];
    [signupButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    signupButton.titleLabel.font = [UIFont fontWithName:@"Raleway" size:18.0];
    [signupButton setTitleColor:[UIColor colorWithRed:0x48/255.0 green:0x98/255.0 blue:0xBD/255.0 alpha:1.0] forState:UIControlStateNormal];
    signupButton.backgroundColor = [UIColor whiteColor];
    [signupButton.layer setBorderColor:[UIColor colorWithRed:0x1F/255.0 green:0x32/255.0 blue:0x4D/255.0 alpha:1.0].CGColor];
    [signupButton.layer setBorderWidth:1.0];
    [self.view addSubview:signupButton];
    
    // FORGOT PASSWORD
    UIButton* forgotPasswordButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    forgotPasswordButton.frame = CGRectMake([self.screenSize[@"width"] floatValue]/2 - 70.0, 0.5*[self.screenSize[@"height"] floatValue], 140.0, 20.0);
    [forgotPasswordButton addTarget:self
                     action:@selector(forgotPassword)
           forControlEvents:UIControlEventTouchUpInside];
    [forgotPasswordButton setTitle:@"Forgot Password?" forState:UIControlStateNormal];
    forgotPasswordButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    [forgotPasswordButton setTintColor:[UIColor whiteColor]];
    [self.view addSubview:forgotPasswordButton];
    
    // Create QB session request
    // do this in chat page
    [QBRequest createSessionWithSuccessBlock:^(QBResponse *response, QBASession *session) {
        //Your Quickblox session was created successfully
    } errorBlock:^(QBResponse *response) {
        //Handle error here
        //nslog(@"Failed to create session");
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Failed to Create Session" message:[NSString stringWithFormat:@"Your shit is not going to work because...%@", response.error] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([FBSDKAccessToken currentAccessToken] && [[NSUserDefaults standardUserDefaults] objectForKey:@"account"]
        && [[[NSUserDefaults standardUserDefaults] objectForKey:@"account"] objectForKey:@"interest"]) {
//        //nslog(@"profile: %@", [FBSDKAccessToken currentAccessToken].userID);
        /* make the API call */
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
//                 //nslog(@"fetched user:%@", result);
//                 //nslog(@"Hoochie Coochie");
                 // sign this bitch in by setting the user default account with the user that is returned from the db
                 
                 if (![[NSUserDefaults standardUserDefaults] objectForKey:@"account"]) {
                    
                     NSDictionary* account = [DataManager getUser:result[@"email"]];
                     if (account[@"gender"] != [NSNull null] && account[@"password"] != [NSNull null] && account[@"username"] != [NSNull null]){ //that should do it on the checks
                         [[NSUserDefaults standardUserDefaults] setObject:[self userWithoutNullAvatar:account] forKey:@"account"];
                     }
                     
                 }
                 
                 NSDictionary* user = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
                 if ([user[@"expert_id"] integerValue] > 0) {
                     //nslog(@"expert: %@", user[@"expert_id"]);
                     [self performSegueWithIdentifier:@"expertHomeSegue" sender:self];
                 }
                 else {
                     [self performSegueWithIdentifier:@"homeSegue" sender:self];
                 }
             }
         }];
    }
    else if ([FBSDKAccessToken currentAccessToken] && (![[NSUserDefaults standardUserDefaults] objectForKey:@"account"] || ![[[NSUserDefaults standardUserDefaults] objectForKey:@"account"] objectForKey:@"interest"])){
        [FBSDKAccessToken setCurrentAccessToken:nil];
    }
    else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"account"]) {
        NSDictionary* user = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
        if ([user[@"expert_id"] integerValue] > 0) {
            [self performSegueWithIdentifier:@"expertHomeSegue" sender:self];
        }
        else {
            [self performSegueWithIdentifier:@"homeSegue" sender:self];
        }
    }
}

- (void) submit
{
    //check login
    NSMutableDictionary* credentials = [[NSMutableDictionary alloc] init];
    credentials[@"password"] = self.passwordField.text;
    credentials[@"email"] = self.emailField.text;
    if ([self validateForm]) {
        NSDictionary* result = [DataManager signIn:credentials];
        if ([result[@"result"] isEqualToString:@"success"]) {
            [[NSUserDefaults standardUserDefaults] setObject:[self userWithoutNullAvatar: result[@"user"]] forKey:@"account"];
            if ([result[@"user"][@"expert_id"] intValue] > 0) { // expert
                [self performSegueWithIdentifier:@"expertHomeSegue" sender:self];
            }
            else { // peasant
                [self performSegueWithIdentifier:@"homeSegue" sender:self];
            }
        }
        else {
            UIAlertView* failedLogin = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"No account found with matching email/password pair" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [failedLogin show];
        }
    }
    else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Form Incomplete" message:@"Please enter a value for all fields" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void) signup
{
    [self performSegueWithIdentifier:@"signupSegue" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Facebook

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"titleLabel.text"]) {
        // Value changed
        if ([FBSDKAccessToken currentAccessToken]) {
            /* make the API call */
            //start a loader
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 if (!error) {
                     BOOL complete = YES;
                     
                     //signIn
                     NSMutableDictionary* cred = [[NSMutableDictionary alloc] init];
                     cred[@"email"] = result[@"email"];
                     cred[@"password"] = @"fbUserNone";
                     NSDictionary* signInDictionary = [DataManager signIn:cred];
                     if ([signInDictionary[@"result"] isEqualToString: @"success"]) {
                         self.account = signInDictionary[@"user"];
                         complete = YES;
                         [[NSUserDefaults standardUserDefaults] setObject:[self userWithoutNullAvatar: self.account] forKey:@"account"];
                     }
                     // new user
                     else {
                         if ([result objectForKey: @"email"]) {
                             self.account[@"email"] = result[@"email"];
                             NSArray *arrayWithTwoStrings = [result[@"email"] componentsSeparatedByString:@"@"];
                             self.account[@"username"] = arrayWithTwoStrings[0]; // portion of email before @
                         }
                         else {
                             complete = NO;
                         }
                         if ([result objectForKey: @"gender"]) {
                             self.account[@"gender"] = result[@"gender"];
                         }
                         else {
                             complete = NO;
                         }
                         if ([result objectForKey: @"age_range"]) {
                             self.account[@"age"] = result[@"age_range"];
                         }
                         else {
                             complete = NO;
                         }
                         if ([result objectForKey: @"interested_in"]) {
                             self.account[@"interest"] = result[@"interested_in"];
                         }
                         else {
                             complete = NO;
                         }
                         
                         self.account[@"password"] = @"fbUserNone";
                         self.account[@"qb_code"] = @"fbUserNone";
                     }

                     if (complete) {
                         // Log in in the chat page
//                         [QBRequest logInWithUserLogin:self.account[@"email"] password:@"helpMeText2015"
//                                          successBlock:[self successBlock] errorBlock:[self errorBlock]];
                         if ([self.account[@"expert_id"] integerValue] > 0) {
                             [self signupQBUserExpert];
                         }
                         else{
                             [self performSegueWithIdentifier:@"homeSegue" sender:self];
                         }
                     }
                     else {
//                         [QBRequest logInWithUserLogin:self.account[@"email"] password:@"helpMeText2015"
//                                          successBlock:[self successBlock] errorBlock:[self errorBlock]];
                         [self performSegueWithIdentifier:@"moreInfoSegue" sender:self];
                     }
                 }
             }];
        }
    }
}

-(void) forgotPassword
{
    [self performSegueWithIdentifier:@"forgotPasswordSegue" sender:nil];
}

#pragma mark - navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[MoreInfoViewController class]]) {
        MoreInfoViewController* destination = segue.destinationViewController;
        destination.account = self.account;
    }
    else {
        UINavigationController* dest = segue.destinationViewController;
        dest.navigationBar.topItem.title = @"Crush.it";
        [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                                NSForegroundColorAttributeName: [UIColor colorWithRed:25/255.0 green:25/255.0 blue:25/255.0 alpha:1.0],
                                                                NSFontAttributeName: [UIFont fontWithName:@"Raleway-Medium" size:20.0f]
                                                                }];
    }
}

#pragma mark - Quickblox

- (void (^)(QBResponse *response, QBUUser *user))successBlock
{
    return ^(QBResponse *response, QBUUser *user) {
        // Login succeeded
        //nslog(@"signed in QBUser: %@", user);
    };
}

- (QBRequestErrorBlock)errorBlock
{
    return ^(QBResponse *response) {
        // QUICKBLOX
        QBUUser *user = [QBUUser user];
        user.password = self.account[@"qb_code"];
        user.login = self.account[@"email"];
        
        // Registration/sign up of User
        [QBRequest signUp:user successBlock:^(QBResponse *response, QBUUser *user) {
            // Sign up was successful
            // submit this shit - Data Manager
            self.account[@"qb_id"] = [NSString stringWithFormat:@"%lu", (unsigned long)user.ID];
            self.account[@"expert_id"] = @"0";
            NSMutableDictionary* submitAccount = [NSMutableDictionary dictionaryWithObject:self.account forKey:@"user"];
            NSDictionary* dmAccount = [DataManager signUp:submitAccount];
            if (dmAccount) {
                [[NSUserDefaults standardUserDefaults] setObject:[self userWithoutNullAvatar: self.account] forKey:@"account"];
                //nslog(@"%@", dmAccount);
                [self performSegueWithIdentifier:@"accountCreatedSegue" sender:self];
            }
            else {
                [self deleteUser:user andPassword:self.account[@"qb_code"]];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Account Creation Failed" message:@"Please try again later" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                [alert show];
                if ([FBSDKAccessToken currentAccessToken]) {
                    [FBSDKAccessToken setCurrentAccessToken:nil];
                }
            }
            
            //nslog(@"signed up QBUser: %@", user);
            
//            [self performSegueWithIdentifier:@"accountCreatedSegue" sender:self];
        } errorBlock:^(QBResponse *response) {
            // Handle error here
            //nslog(@"error creating user: %@", response);
        }];
    };
}

-(void)signupQBUserExpert
{
    QBUUser *user = [QBUUser user];
    user.password = self.account[@"qb_code"];
    user.login = self.account[@"email"];
    
    // Registration/sign up of User
    [QBRequest signUp:user successBlock:^(QBResponse *response, QBUUser *user) {
        // Sign up was successful
        
        self.account[@"qb_id"] = [NSString stringWithFormat:@"%lu", (unsigned long)user.ID];
        // NEEDS AN EXPERTID
        NSMutableDictionary* submitAccount = [NSMutableDictionary dictionaryWithObject:self.account forKey:@"user"];
        NSDictionary* dmAccount = [DataManager signUp:submitAccount];
        if (dmAccount) {
            [[NSUserDefaults standardUserDefaults] setObject:[self userWithoutNullAvatar: dmAccount] forKey:@"account"];
            [self performSegueWithIdentifier:@"expertHomeSegue" sender:self];
        }
        else {
            [self deleteUser:user andPassword:self.account[@"qb_code"]];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Account Creation Failed" message:@"Please try again later" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [alert show];
            if ([FBSDKAccessToken currentAccessToken]) {
                [FBSDKAccessToken setCurrentAccessToken:nil];
            }
        }
        
        //            [self performSegueWithIdentifier:@"accountCreatedSegue" sender:self];
    } errorBlock:^(QBResponse *response) {
        // Handle error here
        //nslog(@"error creating user: %@", response);
    }];
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

#pragma mark - helpers

- (BOOL) validateForm
{
    if (![self.emailField.text isKindOfClass:[NSString class]] || self.emailField.text.length == 0) {
        return false;
    }
    if (![self.passwordField.text isKindOfClass:[NSString class]] || self.passwordField.text.length == 0) {
        return false;
    }
    return true;
    
}

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
