//
//  ForgotPasswordViewController.m
// CrushIt
//
//  Created by William O'Connor on 7/29/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "DataManager.h"

@interface ForgotPasswordViewController ()

@property (strong, nonatomic) UITextField* emailField;
@property (strong, nonatomic) UITextField* passwordField;
@property (strong, nonatomic) UITextField* confirmPasswordField;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSNumber *height = [[NSNumber alloc] initWithDouble:screenHeight];
    NSNumber *width = [[NSNumber alloc] initWithDouble:screenWidth];
    
    self.view.backgroundColor = [UIColor colorWithRed:37/255.0 green:168/255.0 blue:234/255.0 alpha:1.0];
    
    // email field
    self.emailField = [[UITextField alloc] initWithFrame:CGRectMake([width floatValue]/2 - 80, 40.0, 160.0, 30.0)];
    self.emailField.placeholder = @"Email";
    self.emailField.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    self.emailField.backgroundColor = [UIColor whiteColor];
    self.emailField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview: self.emailField];
    
    // password field
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake([width floatValue]/2 - 80, 80.0, 160.0, 30.0)];
    self.passwordField.placeholder = @"New Password";
    self.passwordField.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    self.passwordField.backgroundColor = [UIColor whiteColor];
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordField.secureTextEntry = YES;
    [self.view addSubview: self.passwordField];
    
    // confirm field
    self.confirmPasswordField = [[UITextField alloc] initWithFrame:CGRectMake([width floatValue]/2 - 80, 120.0, 160.0, 30.0)];
    self.confirmPasswordField.placeholder = @"Confirm Password";
    self.confirmPasswordField.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    self.confirmPasswordField.backgroundColor = [UIColor whiteColor];
    self.confirmPasswordField.borderStyle = UITextBorderStyleRoundedRect;
    self.confirmPasswordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.confirmPasswordField.secureTextEntry = YES;
    [self.view addSubview: self.confirmPasswordField];
    
    // submit button
    UIButton* submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitButton.frame = CGRectMake([width floatValue]/2 - 50.0, 160.0, 100.0, 40.0);
    [submitButton addTarget:self
                     action:@selector(submit)
           forControlEvents:UIControlEventTouchUpInside];
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    [submitButton setTitleColor:[UIColor colorWithRed:0x48/255.0 green:0x98/255.0 blue:0xBD/255.0 alpha:1.0] forState:UIControlStateNormal];
    submitButton.backgroundColor = [UIColor whiteColor];
    [submitButton.layer setBorderColor:[UIColor colorWithRed:0x1F/255.0 green:0x32/255.0 blue:0x4D/255.0 alpha:1.0].CGColor];
    [submitButton.layer setBorderWidth:1.0];
    [self.view addSubview:submitButton];
    
    // back button
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.frame = CGRectMake([width floatValue]/2 - 50.0, 200.0, 100.0, 20.0);
    [backButton addTarget:self
                             action:@selector(back)
                   forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    [backButton setTintColor:[UIColor whiteColor]];
    [self.view addSubview:backButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) submit
{
    // check passwords
    if ([self.passwordField.text isEqualToString:self.confirmPasswordField.text]) {
        UIAlertView* success = [[UIAlertView alloc] initWithTitle:@"Successfully changed password" message:@"You can now log in with your new password." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        UIAlertView* failure = [[UIAlertView alloc] initWithTitle:@"Failed to change password" message:@"Please try again later." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        
        // call change password method
        NSMutableDictionary* requestData = [[NSMutableDictionary alloc] init];
        requestData[@"email"] = self.emailField.text;
        requestData[@"password"] = self.passwordField.text;
        
        if ([self validateForm]) {
            NSDictionary* result = [DataManager changePassword:requestData];
            if ([result[@"result"] isEqualToString:@"success"]) {
                [success show];
            }
            else {
                failure.message = result[@"reason"];
                [failure show];
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Form Incomplete" message:@"Please enter a value for all fields" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else {
        UIAlertView* noMatch = [[UIAlertView alloc] initWithTitle:@"Passwords don't match" message:@"Make sure both passwords are the same" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [noMatch show];
    }
}

- (void) back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL) validateForm {
    if (![self.emailField.text isKindOfClass:[NSString class]] || self.emailField.text.length == 0) {
        return false;
    }
    if (![self.passwordField.text isKindOfClass:[NSString class]] || self.passwordField.text.length == 0) {
        return false;
    }
    if (![self.confirmPasswordField.text isKindOfClass:[NSString class]] || self.confirmPasswordField.text.length == 0) {
        return false;
    }
    return true;
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
