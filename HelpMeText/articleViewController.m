//
//  articleViewController.m
// CrushIt
//
//  Created by William O'Connor on 6/2/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import "articleViewController.h"
#import "Strings.h"

@interface articleViewController ()

@property (strong, nonatomic) UILabel* titleLabel;
@property (strong, nonatomic) UILabel* bodyLabel;
@property (strong, nonatomic) UIScrollView* bodyScrollView;
@property (strong, nonatomic) UIWebView* webView;

@end

@implementation articleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.view.backgroundColor = [UIColor colorWithRed:37/255.0 green:168/255.0 blue:234/255.0 alpha:1.0];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSNumber *height = [[NSNumber alloc] initWithDouble:screenHeight];
    NSNumber *width = [[NSNumber alloc] initWithDouble:screenWidth];
    
    //TITLE LABEL
//    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 50.0, [width floatValue], 50.0)];
//    self.titleLabel.text = self.article[@"name"];
//    self.titleLabel.textColor = [UIColor whiteColor];
//    [self.view addSubview:self.titleLabel];
    
    //nslog(@"article: %@", self.article);
    // WEB
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, [width floatValue], [height floatValue])];
    self.webView.delegate = self;
    NSString* urlString = [[kRootURL stringByAppendingString:kGetArticle] stringByAppendingString:[NSString stringWithFormat:@"%@", self.article[@"id"]]];
    //nslog(@"url: %@", urlString);
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString: urlString]];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
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
