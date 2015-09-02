//
//  UserInfoViewController.m
// CrushItAdmin
//
//  Created by William O'Connor on 6/1/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController ()

@property (strong, nonatomic) UILabel* genderLabel;
@property (strong, nonatomic) UILabel* ageLabel;
@property (strong, nonatomic) UILabel* interestLabel;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:37/255.0 green:168/255.0 blue:234/255.0 alpha:1.0];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSNumber *height = [[NSNumber alloc] initWithDouble:screenHeight];
    NSNumber *width = [[NSNumber alloc] initWithDouble:screenWidth];
    
    self.genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 150.0, [width floatValue], 50.0)];
    self.genderLabel.textAlignment = NSTextAlignmentCenter;
    self.genderLabel.text = [@"Gender: " stringByAppendingString: self.user[@"gender"] ];
    self.genderLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.genderLabel];
    
    self.ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 250.0, [width floatValue], 50.0)];
    self.ageLabel.textAlignment = NSTextAlignmentCenter;
    self.ageLabel.text = [NSString stringWithFormat:@"Age: %@", self.user[@"age"] ];
    [self.view addSubview: self.ageLabel];
    
    self.interestLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 350.0, [width floatValue], 50.0)];
    self.interestLabel.textAlignment = NSTextAlignmentCenter;
    self.interestLabel.text = [@"Interest: " stringByAppendingString: self.user[@"interest"] ];
    [self.view addSubview: self.interestLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
