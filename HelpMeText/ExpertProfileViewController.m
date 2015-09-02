//
//  ExpertProfileViewController.m
// CrushIt
//
//  Created by William O'Connor on 7/5/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import "ExpertProfileViewController.h"
#import "liveChatViewController.h"
#import "DataManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface ExpertProfileViewController ()

@property (strong, nonatomic) UILabel* nameLabel;
@property (strong, nonatomic) UILabel* expertiseLabel;
@property (strong, nonatomic) UILabel* bioLabel;
@property (strong, nonatomic) UILabel* ratingLabel;
@property (strong, nonatomic) UIImageView* profilePicView;
@property (strong, nonatomic) UIImageView* fbProfPicView;
@property (strong, nonatomic) UIButton* chatButton;
@property (strong, nonatomic) NSDictionary* account;
@property (strong, nonatomic) NSDictionary* chat;

@property (strong, nonatomic) NSString* qb_dialog_id;
@end

@implementation ExpertProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.account = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSNumber *height = [[NSNumber alloc] initWithDouble:screenHeight];
    NSNumber *width = [[NSNumber alloc] initWithDouble:screenWidth];
    
    self.view.backgroundColor = [UIColor colorWithRed:37/255.0 green:168/255.0 blue:234/255.0 alpha:1.0];
    
    self.profilePicView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 84.0, 150.0, 150.0)];
    self.profilePicView.image = self.expertImage;
    //nslog(@"%@", self.expert[@"expert"][@"fb_pic_link"]);
    [self.view addSubview:self.profilePicView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(170.0, 100.0, [width floatValue] - 190, 50.0)];
    self.nameLabel.text = self.expert[@"user"][@"username"];
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.nameLabel];
    
//    self.expertiseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 500.0, [width floatValue], 30.0)];
//    self.expertiseLabel.text = [NSString stringWithFormat:@"Specialty: %@", self.expert[@"expert"][@"specialty"]];
//    self.expertiseLabel.textAlignment = NSTextAlignmentCenter;
//    self.expertiseLabel.textColor = [UIColor whiteColor];
//    [self.view addSubview:self.expertiseLabel];
    
    NSString* ratingKey = @"Stars";
    if ([self.expert[@"expert"][@"rating"] integerValue] == 0) {
        ratingKey = @"Ratings";
    }
    self.ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(170.0, 150.0, [width floatValue] - 190, 30.0)];
    self.ratingLabel.text = [NSString stringWithFormat:@"Rating: %@ %@", self.expert[@"expert"][@"rating"], ratingKey];
    self.ratingLabel.textAlignment = NSTextAlignmentCenter;
    self.ratingLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    self.ratingLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.ratingLabel];
    
    self.chatButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.chatButton.frame = CGRectMake(170.0, 200.0, [width floatValue] - 190, 40.0);
    [self.chatButton setTitle:@"Chat Now" forState:UIControlStateNormal];
    self.chatButton.backgroundColor = [UIColor whiteColor];
    [self.chatButton addTarget:self action:@selector(chatNow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.chatButton];
    
    if (!self.expert[@"expert"][@"availability"]) {
        self.chatButton.enabled = NO;
    }
    
    self.bioLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 300.0, [width floatValue]-20, 150.0)];
    self.bioLabel.text = self.expert[@"expert"][@"bio"];
    self.bioLabel.numberOfLines = 0;
    self.bioLabel.textAlignment = NSTextAlignmentCenter;
    self.bioLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.bioLabel];

    
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
    liveChatViewController* dest = segue.destinationViewController;
    dest.recipientID = (NSInteger)self.expert[@"user"][@"user_id"];
    dest.dialog_id = self.qb_dialog_id;
    dest.chat = self.chat;
}


-(void) chatNow
{
    [self checkCorrespondences];
    
}

- (void) checkCorrespondences
{
    if (self.account[@"correspondences"] > 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Reminder!" message:[NSString stringWithFormat:@"This correspondence will cost you %@ correspondences. Would you like to continue?", self.expert[@"expert"][@"cost"]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
        [alert show];
    }
    
    else {
        // alert view
        UIAlertView* failed = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"You do not have enough correspondences to complete this transaction. You can attain more correspondences by navigating to the Settings view from the home screen." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [failed show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1){
        NSMutableDictionary* startCorrDict = [[NSMutableDictionary alloc] init];
        NSMutableDictionary* corrInfo = [[NSMutableDictionary alloc] init];
        corrInfo[@"user_id"] = self.account[@"id"];
        corrInfo[@"expert_id"] = self.expert[@"expert"][@"id"];
        startCorrDict[@"correspondence"] = corrInfo;
        
        self.chat = [DataManager startCorrespondence:startCorrDict];
        // create dialog
        //nslog(@"the chat: %@", self.chat);
        if ((BOOL)self.chat[@"new"] == true) {
            QBChatDialog *chatDialog = [QBChatDialog new];
            chatDialog.type = QBChatDialogTypePrivate;
            chatDialog.occupantIDs = @[@([self.expert[@"user"][@"qb_id"] integerValue])];
            //nslog(@"ids: %@", chatDialog.occupantIDs);
            [QBRequest createDialog:chatDialog successBlock:^(QBResponse *response, QBChatDialog *createdDialog) {
                NSMutableDictionary* addDialog = [[NSMutableDictionary alloc] init];
                addDialog[@"chat_id"] = self.chat[@"chat"][@"id"];
                addDialog[@"dialog_id"] = createdDialog.ID;
                self.qb_dialog_id = createdDialog.ID;
                //nslog(@"add: %@", addDialog);
                self.chat = [DataManager addDialogIdToChat:addDialog][@"chat"];
                //nslog(@"%@", self.chat);
                [self performSegueWithIdentifier:@"liveChatSegue" sender:self];
            } errorBlock:^(QBResponse *response) {
                //nslog(@"ERROR! : %@", response.error);
            }];
        }
        else {
            self.chat = self.chat[@"chat"];
            self.qb_dialog_id = self.chat[@"chat"][@"dialog_id"];
            [self performSegueWithIdentifier:@"liveChatSegue" sender:self];
        }
    }
}

@end
