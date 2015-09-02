//
//  ViewController.m
// CrushItAdmin
//
//  Created by William O'Connor on 5/27/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import "ExpertHomeViewController.h"
#import "UserInfoTableViewCell.h"
#import "DataManager.h"
#import "liveChatViewController.h"
#import "RenewalView.h"
#import "ExpertSettingsViewController.h"
// FACEBOOK
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface ExpertHomeViewController ()

@property (strong, nonatomic) UITableView* convosTableView;
@property (strong, nonatomic) NSMutableArray* qBConversations;
@property (strong, nonatomic) NSMutableArray* users;
@property (strong, nonatomic) NSMutableDictionary* account;
@property (strong, nonatomic) NSDictionary* selectedCellUser;
@property (strong, nonatomic) NSString* selectedDialog;
@property (strong, nonatomic) NSDictionary* selectedChat;
@property NSInteger selectedRowIndex;

@end

@implementation ExpertHomeViewController

-(NSMutableArray*) qBConversations {
    if (!_qBConversations) {
        _qBConversations = [[NSMutableArray alloc] init];
    }
    return _qBConversations;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:37/255.0 green:168/255.0 blue:234/255.0 alpha:1.0];
    self.account = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];

    // Do any additional setup after loading the view, typically from a nib.
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSNumber *height = [[NSNumber alloc] initWithDouble:screenHeight];
    NSNumber *width = [[NSNumber alloc] initWithDouble:screenWidth];
    
    //TABLE
    self.convosTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, [width doubleValue], [height doubleValue])];
    self.convosTableView.dataSource = self;
    self.convosTableView.delegate = self;
    [self.convosTableView registerClass:[UserInfoTableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.convosTableView.backgroundColor = [UIColor colorWithRed:37/255.0 green:168/255.0 blue:234/255.0 alpha:1.0];
    [self.view addSubview:self.convosTableView];
    
    //LOGOUT BUTTON
    UIBarButtonItem* logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(logout)];
    [self.navigationItem setLeftBarButtonItem:logoutButton animated:NO];
    
    // SETTINGS BUTTON
    UIBarButtonItem* settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(settings)];
    [self.navigationItem setLeftBarButtonItem:settingsButton animated:NO];
    
    
    NSDictionary* account = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    
    // Create session with user
    NSString *userLogin = account[@"email"];
    NSString *userPassword = account[@"qb_code"];
    
    QBSessionParameters *parameters = [QBSessionParameters new];
    parameters.userEmail = userLogin;
    parameters.userPassword = userPassword;
    
    //nslog(@"params: %@, %@", parameters.userEmail, parameters.userPassword);
    [QBRequest createSessionWithExtendedParameters:parameters successBlock:^(QBResponse *response, QBASession *session) {
        // Sign In to QuickBlox Chat
        QBUUser *currentUser = [QBUUser user];
        currentUser.ID = session.userID; // your current user's ID
        currentUser.password = userPassword; // your current user's password
        
        //nslog(@"Session creation response: %@", response);
        
        // set Chat delegate
        [[QBChat instance] addDelegate:self];
        
        // login to Chat
        [[QBChat instance] loginWithUser:currentUser];
        
        NSDictionary* queryResult = [DataManager getActiveExpertChats:self.account[@"expert_id"]];
        self.qBConversations = [self dictionaryToArray:queryResult[@"chats"]];
        self.users = [self dictionaryToArray:queryResult[@"users"]];
        
        //nslog(@"convos though: %@", self.qBConversations);
        //nslog(@"users though: %@", self.users);
        [self.convosTableView reloadData];
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        //nslog(@" big error: %@", response.error);
    }];

    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview Delegate and DataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary* otherUser = self.users[indexPath.row];
    
    //nslog(@"users though: %@", self.users[indexPath.row]);
    //nslog(@"user though: %@", otherUser);
    cell.profileInfo = otherUser;
    [cell setTextValues];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRowIndex = indexPath.row;
    self.selectedCellUser = ((UserInfoTableViewCell*)([tableView cellForRowAtIndexPath:indexPath])).profileInfo;
    self.selectedDialog = self.qBConversations[indexPath.row][@"dialog_id"];
    self.selectedChat = self.qBConversations[indexPath.row];
    [self performSegueWithIdentifier:@"chatSegue" sender:self];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.qBConversations count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[ExpertSettingsViewController class]]) {
        ExpertSettingsViewController* settingsVC = segue.destinationViewController;
        settingsVC.expert = self.account;
    }
    else if ([segue.destinationViewController isKindOfClass:[liveChatViewController class]]){
        liveChatViewController* destination = segue.destinationViewController;
        destination.recipientID = (NSUInteger)self.selectedCellUser[@"qb_id"];
        destination.user = self.selectedCellUser;
        destination.expert = [DataManager getExpert:self.account[@"expert_id"]];
        destination.dialog_id = self.selectedDialog;
        destination.chat = self.selectedChat;
    }
}

-(void)logout
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"account"];
    if ([FBSDKAccessToken currentAccessToken]) {
        [FBSDKAccessToken setCurrentAccessToken:nil];
        [FBSDKProfile setCurrentProfile:nil];
    }
    [self dismissViewControllerAnimated:YES completion:nil]; //may need to handle facebook
}

-(void) settings
{
    [self performSegueWithIdentifier:@"expertSettingsSegue" sender:nil];
}

#pragma mark - helper

-(NSMutableArray*) dictionaryToArray:(NSDictionary*) dict
{
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    for (NSDictionary* obj in dict) {
        [arr addObject:obj];
    }
    
    return arr;
}

@end
