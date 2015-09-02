//
//  ExpertChatOptionsViewController.m
// CrushIt
//
//  Created by William O'Connor on 7/14/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import "ExpertChatOptionsViewController.h"
#import "PhotosCollectionViewController.h"
#import "DataManager.h"

@interface ExpertChatOptionsViewController ()

@end

@implementation ExpertChatOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSNumber *height = [[NSNumber alloc] initWithDouble:screenHeight];
    NSNumber *width = [[NSNumber alloc] initWithDouble:screenWidth];
    
    self.view.backgroundColor = [UIColor colorWithRed:37/255.0 green:168/255.0 blue:234/255.0 alpha:1.0];
    
    // user info
    UILabel* userInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 80.0, [width floatValue], 30.0)];
    userInfoLabel.text = @"User Info:";
    userInfoLabel.font = [UIFont systemFontOfSize:18.0];
    userInfoLabel.textColor = [UIColor whiteColor];
    userInfoLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:userInfoLabel];
    
    UILabel* usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 110.0, [width floatValue], 30.0)];
    usernameLabel.text = self.user[@"username"];
    usernameLabel.textColor = [UIColor whiteColor];
    usernameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:usernameLabel];
    
    UILabel* userGenderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 140.0, [width floatValue], 30.0)];
    userGenderLabel.text = self.user[@"gender"];
    userGenderLabel.textColor = [UIColor whiteColor];
    userGenderLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:userGenderLabel];
    
    UILabel* userAgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 170.0, [width floatValue], 30.0)];
    userAgeLabel.text = self.user[@"age"];
    userAgeLabel.textColor = [UIColor whiteColor];
    userAgeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:userAgeLabel];
    
    UILabel* userPreferenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 200.0, [width floatValue], 30.0)];
    userPreferenceLabel.text = self.user[@"interest"];
    userPreferenceLabel.textColor = [UIColor whiteColor];
    userPreferenceLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:userPreferenceLabel];
    
    // chat controls: renew chat, cancel chat
    UIButton* endChatButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    endChatButton.frame = CGRectMake([width floatValue]/2 - 70, 240.0, 140, 50.0);
    [endChatButton setTitle:@"End Chat" forState:UIControlStateNormal];
    [endChatButton setBackgroundColor:[UIColor whiteColor]];
    [endChatButton addTarget:self action:@selector(endChat) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:endChatButton];
    
    UIButton* renewChatButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    renewChatButton.frame = CGRectMake([width floatValue]/2 - 70, 300.0, 140, 50.0);
    [renewChatButton setTitle:@"Renew Chat" forState:UIControlStateNormal];
    [renewChatButton setBackgroundColor:[UIColor whiteColor]];
    [renewChatButton addTarget:self action:@selector(renewChat) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:renewChatButton];
    
    //BACK BUTTON
//    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    backButton.frame = CGRectMake(10.0, 30.0, 100.0, 40.0);
//    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setTitle:@"Back" forState:UIControlStateNormal];
//    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.view addSubview:backButton];
    
    // view photos
    UIButton* photosButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    photosButton.frame = CGRectMake([width floatValue]/2 - 70, 360.0, 140, 50.0);
    [photosButton setTitle:@"Chat Photos" forState:UIControlStateNormal];
    [photosButton setBackgroundColor:[UIColor whiteColor]];
    [photosButton addTarget:self action:@selector(photosButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photosButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[PhotosCollectionViewController class]]) {
        PhotosCollectionViewController* dest = segue.destinationViewController;
        dest.displayName = self.expert[@"user"][@"username"];
    }
}


#pragma mark - Button actions

-(void) endChat {
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[@"chat_id"] = self.chat[@"id"];
    [DataManager endChat:params];
}

-(void) renewChat {
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[@"chat_id"] = self.chat[@"id"];
    params[@"setting"] = @true;
    [DataManager renewChatRequest:params];
}

-(void) backButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) photosButtonPressed {
    [self performSegueWithIdentifier:@"optionsToPhotosSegue" sender:self];
}

@end
