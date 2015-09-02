//
//  ExpertsViewController.m
// CrushIt
//
//  Created by William O'Connor on 6/14/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import "ExpertsViewController.h"
#import "ExpertTableViewCell.h"
#import "DataManager.h"
#import "liveChatViewController.h"
#import "ExpertProfileViewController.h"

@interface ExpertsViewController ()

@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray* experts;
@property (strong, nonatomic) NSMutableArray* onlineExperts;
@property (strong, nonatomic) NSMutableArray* offlineExperts;
@property (strong, nonatomic) NSDictionary* account;
@property (strong, nonatomic) NSIndexPath* selectedIndex;


@end

@implementation ExpertsViewController

-(NSMutableArray*) onlineExperts {
    if (!_onlineExperts) {
        _onlineExperts = [[NSMutableArray alloc]init];
    }
    return _onlineExperts;
}

-(NSMutableArray*) offlineExperts {
    if (!_offlineExperts) {
        _offlineExperts = [[NSMutableArray alloc]init];
    }
    return _offlineExperts;
}

-(NSMutableArray*) experts {
    if (!_experts) {
        _experts = [[NSMutableArray alloc]init];
    }
    return _experts;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSNumber *height = [[NSNumber alloc] initWithDouble:screenHeight];
    NSNumber *width = [[NSNumber alloc] initWithDouble:screenWidth];
    
    self.navigationItem.title = @"Experts";
    self.account = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    
    //EXPERTS
    NSDictionary* result = [DataManager getExperts:self.specialty];
    //nslog(@"result: %@", result);
    //nslog(@"exp: %@", self.specialty);
    
    //ONLINE
    for (NSDictionary* expert in result[@"experts"]) {
        if ([expert[@"availability"] isEqual: @YES]) {
            [self.onlineExperts addObject:expert];
        }
        else {
            [self.offlineExperts addObject:expert];
        }
    }
    self.experts[0] = self.onlineExperts;
    self.experts[1] = self.offlineExperts;
    //nslog(@"Here they are: %@", self.experts);
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, [width floatValue], [height floatValue])];
    self.view.backgroundColor = [UIColor colorWithRed:37/255.0 green:168/255.0 blue:234/255.0 alpha:1.0];
    self.tableView.backgroundColor = [UIColor colorWithRed:37/255.0 green:168/255.0 blue:234/255.0 alpha:1.0];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ExpertTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    
    // QBLogin
    // Create session with user
    NSString *userLogin = self.account[@"username"];
    NSString *userPassword = self.account[@"qb_code"];
    
    QBSessionParameters *parameters = [QBSessionParameters new];
    parameters.userLogin = userLogin;
    parameters.userPassword = userPassword;
    
    [QBRequest createSessionWithExtendedParameters:parameters successBlock:^(QBResponse *response, QBASession *session) {
        // Sign In to QuickBlox Chat
        QBUUser *currentUser = [QBUUser user];
        currentUser.ID = session.userID; // your current user's ID
        currentUser.password = userPassword; // your current user's password
        
        // set Chat delegate
        [[QBChat instance] addDelegate:self];
        
        // login to Chat
        [[QBChat instance] loginWithUser:currentUser];
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        //nslog(@"error: %@", response.error);
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self performSegueWithIdentifier:@"liveChatSegue" sender:self];
}

#pragma mark - TableView

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpertTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary* expert = self.experts[indexPath.section][indexPath.row];
    NSString* ratingKey = @"Stars";
    if ([expert[@"expert"][@"rating"] integerValue] == 0) {
        ratingKey = @"Ratings";
    }
    //nslog(@"here: %@", expert);
    cell.nameLabel.text = expert[@"user"][@"username"];
    cell.ratingLabel.text = [NSString stringWithFormat:@"Rating: %@ %@", expert[@"expert"][@"rating"], ratingKey/*/(NSInteger)expert[@"totalRatings"]*/];
    cell.costLabel.text = [NSString stringWithFormat:@"Cost: $%@", expert[@"expert"][@"cost"]];
    cell.expert = expert;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2; // cannot check if a user is online without the dialog id, which we don't have yet
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //nslog(@"lalala: %@, %lu, %lu", self.experts, (unsigned long)self.onlineExperts.count, (unsigned long)self.offlineExperts.count);
    return [self.experts[section] count];
//    return self.experts.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath;
    // check if dialog is already open between the two users. If it is, go for it. If not, charge them
//    NSInteger qbID = [self.experts[self.selectedIndex.section][self.selectedIndex.row][@"user"][@"qb_id"] integerValue];
    
    [self performSegueWithIdentifier:@"viewProfileSegue" sender:self];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (UITableViewHeaderFooterView *)headerViewForSection:(NSInteger)section
{
    UITableViewHeaderFooterView* header = [[UITableViewHeaderFooterView alloc] init];
    
    if (section == 0) {
        [header.textLabel setText:@"Online Experts"];
    }
    else if (section == 1) {
        [header.textLabel setText:@"Offline Experts"];
    }
    return header;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //nslog(@"HEY: %@", self.experts[self.selectedIndex.section][self.selectedIndex.row][@"user"][@"qb_id"]);
    
    ExpertProfileViewController* dest = segue.destinationViewController;
    dest.expert = self.experts[self.selectedIndex.section][self.selectedIndex.row];
    //nslog(@"%@", dest.expert);
    
}


@end
