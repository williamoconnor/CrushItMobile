//
//  HomeViewController.m
// CrushIt
//
//  Created by William O'Connor on 5/4/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import "liveChatViewController.h"
#import "HomeViewController.h"
#import "MoreInfoViewController.h"
#import "SignInViewController.h"
#import "DataManager.h"
#import "RatingView.h"
#import "AppDelegate.h"
#import "WelcomeView.h"

@interface HomeViewController ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *settingsBarButtonItem;
@property (strong, nonatomic) UIActivityIndicatorView* loading;

@end

@implementation HomeViewController

-(AppDelegate*) app
{
    return (AppDelegate*) [[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSNumber *height = [[NSNumber alloc] initWithDouble:screenHeight];
    NSNumber *width = [[NSNumber alloc] initWithDouble:screenWidth];
    
    self.view.backgroundColor = [UIColor colorWithRed:37/255.0 green:168/255.0 blue:234/255.0 alpha:1.0];
    
    // social consultant label
    UILabel* headingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.13*[height floatValue], [width floatValue], 100.0)];
    headingLabel.numberOfLines = 0;
    headingLabel.text = @"Your Personal Social Consultant";
    headingLabel.textColor = [UIColor whiteColor];
    headingLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview: headingLabel];
    
    
    
    // textpert button
    UIButton* textpertButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    textpertButton.frame = CGRectMake([width floatValue]/2 - 100, 0.33*[height floatValue], 200.0, 40);
    [textpertButton setTitle:@"Crush.wise" forState:UIControlStateNormal];
    textpertButton.titleLabel.textColor = [UIColor colorWithRed:37/255.0 green:168/255.0 blue:234/255.0 alpha:1.0];
    textpertButton.backgroundColor = [UIColor whiteColor];
    [textpertButton addTarget:self action:@selector(textpertButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:textpertButton];
    
    // live chat button
    UIButton* liveChatButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    liveChatButton.frame = CGRectMake([width floatValue]/2 - 100, 0.5*[height floatValue], 200.0, 40);
    [liveChatButton setTitle:@"Live Experts" forState:UIControlStateNormal];
    liveChatButton.titleLabel.textColor = [UIColor colorWithRed:37/255.0 green:168/255.0 blue:234/255.0 alpha:1.0];
    liveChatButton.backgroundColor = [UIColor whiteColor];
    [liveChatButton addTarget:self action:@selector(liveChatButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:liveChatButton];
    
    // articles button
    UIButton* articlesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    articlesButton.frame = CGRectMake([width floatValue]/2 - 100, 0.66*[height floatValue], 200.0, 40);
    [articlesButton setTitle:@"Crush.blog" forState:UIControlStateNormal];
    articlesButton.titleLabel.textColor = [UIColor colorWithRed:37/255.0 green:168/255.0 blue:234/255.0 alpha:1.0];
    articlesButton.backgroundColor = [UIColor whiteColor];
    [articlesButton addTarget:self action:@selector(articlesButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:articlesButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    MoreInfoViewController* moreInfo = [[MoreInfoViewController alloc] init];
    SignInViewController* signIn = [[SignInViewController alloc] init];
    
    NSDictionary* account = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    //nslog(@"Account: %@", account);
//    if (!account) {
//        [self presentViewController:signIn animated:YES completion:nil];
//    }
    if (![account objectForKey:@"gender"] || ![account objectForKey:@"interest"] || ![account objectForKey:@"age"]) {
        [self presentViewController:moreInfo animated:YES completion:^{
            moreInfo.account = [account mutableCopy];
        }];
    }
    
    else if ([self.isNew isEqualToString: @"yes"]) {
        // Welcome View
        CustomIOSAlertView* alertView = [[CustomIOSAlertView alloc] init];
        [alertView setDelegate:self];
        alertView.buttonTitles = @[@"Get Started"];
        WelcomeView* customView = [[WelcomeView alloc] initWithFrame:CGRectMake(0.0, 5.0, 200.0, 200.0)];
        [alertView setContainerView:customView];
        [alertView show];
        self.isNew = @"no";
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) textpertButtonPressed
{
    [self performSegueWithIdentifier:@"textpertSegue" sender:self];
}

- (void) articlesButtonPressed
{
    [self performSegueWithIdentifier:@"articlesSegue" sender:self];
}

- (IBAction)settingsBarButtonPressed:(UIBarButtonItem *)sender {
    
    [self performSegueWithIdentifier:@"settingsSegue" sender:self];
}

#pragma mark - chat stuff

- (void) liveChatButtonPressed
{
    [self performSegueWithIdentifier:@"expertsSegue" sender:self];
}

#pragma mark - check for need to rate

- (void) checkForRating
{
    NSDictionary* currentUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    NSDictionary* unratedChats = [DataManager getUnratedChats:currentUser[@"id"]];
    
    if (unratedChats[@"empty"] == false) {
        for (NSDictionary* chat in unratedChats) {
            // alertview requesting rating
            NSDictionary* expert = [DataManager getExpert:chat[@"expert_id"]];
            CustomIOSAlertView* alertView = [[CustomIOSAlertView alloc] init];
            [alertView setDelegate:self];
            alertView.buttonTitles = @[@"Submit"];
            RatingView* customView = [[RatingView alloc] initWithFrame:CGRectMake(0.0, 5.0, 200.0, 200.0) andExpert:expert andChat:chat];
            [customView.ratingSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
            [alertView setContainerView:customView];
            [alertView show];
        }
    }
}

#pragma mark - alert view

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if ([alertView.containerView isKindOfClass:[WelcomeView class]]) {
        [alertView close];
    }
    else if ([alertView.containerView isKindOfClass:[RatingView class]]){
        NSMutableDictionary* ratingDict = [[NSMutableDictionary alloc]init];
        ratingDict[@"chat_id"] = ((RatingView*)(alertView.containerView)).chat[@"id"];
        ratingDict[@"rating"] = @(((RatingView*)(alertView.containerView)).ratingSlider.value);
        NSDictionary* chat = [DataManager submitRating:ratingDict];
        if (chat[@"rating"] > 0) {
            [alertView close];
        }
        else {
            // figure something out
        }
    }
}

-(void)sliderAction:(id)sender
{
    UISlider* slider = (UISlider*)sender;
    int rounded = slider.value;
    //nslog(@"sender: %i", rounded);
    [slider setValue:rounded];
    [((RatingView*)(slider.superview)).ratingSliderLabel setText:[NSString stringWithFormat:@"%i Stars", rounded]];
}

@end
