//
//  ExpertsViewController2.m
// CrushIt
//
//  Created by William O'Connor on 7/24/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import "ExpertsViewController2.h"
#import "ExpertTileView.h"
#import "DataManager.h"
#import "ActiveChatsViewController.h"
#import "ExpertProfileViewController.h"

@interface ExpertsViewController2 ()

@property (strong, nonatomic) UIScrollView* scrollView;
@property (strong, nonatomic) NSDictionary* selectedExpert;
@property (strong, nonatomic) NSMutableArray* experts;
@property (strong, nonatomic) NSMutableArray* onlineExperts;
@property (strong, nonatomic) NSMutableArray* offlineExperts;
@property (strong, nonatomic) NSDictionary* account;
@property (strong, nonatomic) NSIndexPath* selectedIndex;
@property (strong, nonatomic) NSDictionary* qualifiedExpert;

@end

@implementation ExpertsViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Live Experts";
    [self.self.navigationController.navigationBar pushNavigationItem:self.navigationItem animated:NO];
    
    self.view.backgroundColor = [UIColor colorWithRed:37/255.0 green:168/255.0 blue:234/255.0 alpha:1.0];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSNumber *height = [[NSNumber alloc] initWithDouble:screenHeight];
    NSNumber *width = [[NSNumber alloc] initWithDouble:screenWidth];
    
    // Scroll View
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, [height floatValue] /5, [width floatValue], [height floatValue]*0.6)];
    self.scrollView.contentSize = CGSizeMake([width floatValue], 20);
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:self.scrollView];
    
    // active chats button
    UIButton* activeChatsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    activeChatsButton.frame = CGRectMake([width floatValue]/2 + 10.0, [height floatValue] - 60.0, [width floatValue]/2 - 20.0, 40.0);
    [activeChatsButton setTitle:@"Active Chats" forState:UIControlStateNormal];
    [activeChatsButton setBackgroundColor:[UIColor whiteColor]];
    [activeChatsButton addTarget:self action:@selector(activeChatsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:activeChatsButton];
    
    // get correspondences button
    UIButton* getCorrespondencesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    getCorrespondencesButton.frame = CGRectMake(10.0, [height floatValue] - 60.0, [width floatValue]/2 - 20.0, 40.0);
    [getCorrespondencesButton setTitle:@"Get Correspondences" forState:UIControlStateNormal];
    [getCorrespondencesButton setBackgroundColor:[UIColor whiteColor]];
    [getCorrespondencesButton addTarget:self action:@selector(getCorrespondenceButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    getCorrespondencesButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:getCorrespondencesButton];
    
    //EXPERTS
//    NSDictionary* result = [DataManager getAllFeaturedExperts];
//    NSLog(@"res: %@", result);
//    //ONLINE
//    self.onlineExperts = result[@"online"];
//    self.offlineExperts = result[@"offline"];
    self.onlineExperts = [@[] mutableCopy];
    self.offlineExperts = [@[] mutableCopy];
    self.experts = [[self.onlineExperts arrayByAddingObjectsFromArray:self.offlineExperts] mutableCopy];
    
    // Create the buttons
    float tileHeight = ([width floatValue]/2) - 40;
    float tileWidth = ([width floatValue]/2) - 40;
    float y = 0.0;
    float x = 20.0;
    x += tileWidth+40; // get it set up
    
//    for (int i = 0; i < self.experts.count; i++) {
//        //create a tile
//
//        if (i%2 == 0) {//even - left
//            if (i/2 >= 1) {
//                y += tileHeight+40;
//            }
//            x -= (tileWidth+40);
//            self.scrollView.contentSize = CGSizeMake([width floatValue], self.scrollView.contentSize.height+tileHeight+40);
//        }
//        else if (i%2 == 1){//odd - right
//            x += tileWidth+40;
//        }
//
//        //nslog(@"exp: %@", self.experts);
//        ExpertTileView* tile = [[ExpertTileView alloc] initWithFrame:CGRectMake(x, y, tileWidth, tileHeight) andExpert:self.experts[i]];
//        [tile addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        // background color
//        [self.scrollView addSubview:tile];
//        
//    }
//    
//    if (self.experts.count == 0) {
//        UILabel* expertTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0, [width floatValue], 20.0)];
//        expertTitle.textAlignment = NSTextAlignmentCenter;
//        expertTitle.text = @"What Makes a Qualified Expert";
//        expertTitle.textColor = [UIColor whiteColor];
//        [self.scrollView addSubview:expertTitle];
//        
//        
//        UILabel* expertDetails = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 20.0, [width floatValue] - 10, 280.0)];
//        expertDetails.textAlignment = NSTextAlignmentCenter;
//        expertDetails.text = @"They passed our super duper commplex test and have proven they are uber good at giving advice for x, y, and, of course, z. \n\n1. The have crushed it before\n2.They are currently crushing it\n3.All signs point to future crushing\n\nSo please leave us a review and we hope you Crush.it!";
//        expertDetails.textColor = [UIColor blackColor];
//        expertDetails.numberOfLines = 0;
//        [self.scrollView addSubview:expertDetails];
//    }
    
    
    UILabel* youSpecificLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 120.0, [width floatValue], 20.0)];
    youSpecificLabel.textAlignment = NSTextAlignmentCenter;
    youSpecificLabel.text = @"Get You-Specific Advice!";
    youSpecificLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:youSpecificLabel];
    
    // qualified expert
    UIButton* qualifiedExpertButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    qualifiedExpertButton.frame = CGRectMake(40.0, 180.0, [width floatValue] - 80.0, 140.0);
    [qualifiedExpertButton setTitle:@"Crush.it" forState:UIControlStateNormal];
    [qualifiedExpertButton setBackgroundColor:[UIColor whiteColor]];
    [qualifiedExpertButton addTarget:self action:@selector(qualifiedExpertButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    qualifiedExpertButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:qualifiedExpertButton];
    
    UILabel* descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 340.0, [width floatValue]-80, 80.0)];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.text = @"Talk with a live expert and get real time advice. Like that trustworthy friend you rely on for any flirting or romantic guidance, only certified. Tell us your story, and we'll help you Crush.it";
    descriptionLabel.textColor = [UIColor whiteColor];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:descriptionLabel];
    
    // menu nav bar button
    UIImage* icon = [UIImage imageNamed:@"menu.png"];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:icon]];
    [self.navigationItem setRightBarButtonItem:item];
    
//    // Online Experts
//    //Label//
//    UILabel* onlineLabel = [[UILabel alloc] initWithFrame:CGRectMake([width floatValue]/2 - 80, y, 160.0, 20.0)];
//    [onlineLabel setText:@"Online Experts"];
//    onlineLabel.textColor = [UIColor whiteColor];
//    onlineLabel.textAlignment = NSTextAlignmentCenter;
//    y += 50.0;
//    self.scrollView.contentSize = CGSizeMake([width floatValue], self.scrollView.contentSize.height+50.0);
//    [self.scrollView addSubview:onlineLabel];
//    /////////
//    for (int i = 0; i < self.onlineExperts.count; i++) {
//        //create a tile
//        
//        if (i%2 == 0) {//even - left
//            if (i/2 >= 1) {
//                y += tileHeight+40;
//            }
//            x -= (tileWidth+40);
//            self.scrollView.contentSize = CGSizeMake([width floatValue], self.scrollView.contentSize.height+tileHeight+40);
//        }
//        else if (i%2 == 1){//odd - right
//            x += tileWidth+40;
//        }
//        
//        //nslog(@"exp: %@", self.experts);
//        ExpertTileView* tile = [[ExpertTileView alloc] initWithFrame:CGRectMake(x, y, tileWidth, tileHeight) andExpert:self.onlineExperts[i]];
//        [tile addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        // background color
//        [self.scrollView addSubview:tile];
//        
//    }
//    if (self.onlineExperts.count == 0) {
//        UILabel* noOnlineLabel = [[UILabel alloc] initWithFrame:CGRectMake([width floatValue]/2 - 80, y, 160.0, 20.0)];
//        [noOnlineLabel setText:@"None"];
//        noOnlineLabel.textColor = [UIColor grayColor];
//        noOnlineLabel.textAlignment = NSTextAlignmentCenter;
//        y += 50.0;
//        self.scrollView.contentSize = CGSizeMake([width floatValue], self.scrollView.contentSize.height+50.0);
//        [self.scrollView addSubview:noOnlineLabel];
//    }
//    
//    // Offline Experts
//    //Label//
//    UILabel* offlineLabel = [[UILabel alloc] initWithFrame:CGRectMake([width floatValue]/2 - 80, y, 160.0, 20.0)];
//    [offlineLabel setText:@"Offline Experts"];
//    offlineLabel.textColor = [UIColor whiteColor];
//    offlineLabel.textAlignment = NSTextAlignmentCenter;
//    y += 50;
//    self.scrollView.contentSize = CGSizeMake([width floatValue], self.scrollView.contentSize.height+50.0);
//    [self.scrollView addSubview:offlineLabel];
//    /////////
//    for (int i = 0; i < self.offlineExperts.count; i++) {
//        //create a tile
//        
//        if (i%2 == 0) {//even - left
//            if (i/2 >= 1) {
//                y += tileHeight+40;
//            }
//            x -= (tileWidth+40);
//            self.scrollView.contentSize = CGSizeMake([width floatValue], self.scrollView.contentSize.height+tileHeight+40);
//        }
//        else if (i%2 == 1){//odd - right
//            x += tileWidth+40;
//        }
//        
//        //nslog(@"exp: %@", self.experts);
//        ExpertTileView* tile = [[ExpertTileView alloc] initWithFrame:CGRectMake(x, y, tileWidth, tileHeight) andExpert:self.offlineExperts[i]];
//        [tile addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        // background color
//        [self.scrollView addSubview:tile];
//        
//    }
//    if (self.offlineExperts.count == 0) {
//        UILabel* noOfflineLabel = [[UILabel alloc] initWithFrame:CGRectMake([width floatValue]/2 - 80, y, 160.0, 20.0)];
//        [noOfflineLabel setText:@"None"];
//        noOfflineLabel.textColor = [UIColor grayColor];
//        noOfflineLabel.textAlignment = NSTextAlignmentCenter;
//        y += 50.0;
//        self.scrollView.contentSize = CGSizeMake([width floatValue], self.scrollView.contentSize.height+50.0);
//        [self.scrollView addSubview:noOfflineLabel];
//    }
    
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
    if ([segue.destinationViewController isKindOfClass:[ActiveChatsViewController class]]) {
        ActiveChatsViewController* dest = segue.destinationViewController;
        dest.account = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    }
    else if ([segue.destinationViewController isKindOfClass:[ExpertProfileViewController class]]) {
        ExpertProfileViewController* dest = segue.destinationViewController;
        dest.expert = self.selectedExpert;
        ExpertTileView* selectedTile = (ExpertTileView*)sender;
        dest.expertImage = selectedTile.tileImage;
        
        //nslog(@"%@", dest.expert);
    }
}


-(void)buttonPressed:(id) sender
{
    ExpertTileView *buttonClicked = (ExpertTileView *)sender;
    //nslog(@"butotn: %@", buttonClicked);
    buttonClicked.backgroundColor = [UIColor whiteColor];
    self.selectedExpert = buttonClicked.expert;
    [self performSegueWithIdentifier:@"expertProfileSegue" sender:sender];
}

-(void)buttonDepressed:(id) sender
{
    ExpertTileView *buttonClicked = (ExpertTileView *)sender;
    buttonClicked.backgroundColor = [UIColor blueColor];
}

-(void)activeChatsButtonPressed
{
    [self performSegueWithIdentifier:@"activeChatsSegue" sender:self];
}

-(void) getCorrespondenceButtonPressed
{
    // custom view
    CustomIOSAlertView* alertView = [[CustomIOSAlertView alloc] init];
    [alertView setDelegate:self];
    alertView.buttonTitles = @[@"Cancel"];
    GetCorrespondencesView* customView = [[GetCorrespondencesView alloc] initWithFrame:CGRectMake(0.0, 5.0, 300.0, 350.0)];
    customView.delegate = self;
    [alertView setContainerView:customView];
    
    [alertView show];
}

-(void) qualifiedExpertButtonPressed
{
    // custom view
    CustomIOSAlertView* alertView = [[CustomIOSAlertView alloc] init];
    [alertView setDelegate:self];
    alertView.buttonTitles = @[@"Cancel"];
    QualifiedExpertLoadingView* customView = [[QualifiedExpertLoadingView alloc] initWithFrame:CGRectMake(0.0, 5.0, 200.0, 200.0)];
    customView.delegate = self;
    [alertView setContainerView:customView];
    
    [alertView show];
}

#pragma mark - custom alert view delegate

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if ([alertView.containerView isKindOfClass:[QualifiedExpertLoadingView class]]) {
        [alertView.containerView removeObserver:alertView.containerView forKeyPath:@"viewLoaded"];
        [alertView close];
    }
    else if ([alertView.containerView isKindOfClass:[GetCorrespondencesView class]]) {
        [alertView close];
    }
}

#pragma mark - qualified expert delegate

- (void) continueToQualifiedChat
{
    [self performSegueWithIdentifier:@"qualifiedExpertSegue" sender:nil];
}

- (NSDictionary*) findExpert
{
    return [DataManager getQualifiedExpert];
}

#pragma mark - Get correspondence delegate

-(BOOL)buyCorrespondences:(NSNumber *)amount andCost:(NSNumber *)cost
{
    NSMutableDictionary* purchase = [[NSMutableDictionary alloc] init];
    purchase[@"correspondences"] = amount;
    purchase[@"email"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"][@"email"];
    NSDictionary* result = [DataManager purchaseCorrespondence:purchase];
    [[NSUserDefaults standardUserDefaults] setObject:result[@"user"] forKey:@"account"];
    
    return result[@"success"];
}

@end
