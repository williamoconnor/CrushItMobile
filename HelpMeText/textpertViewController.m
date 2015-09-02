//
//  textpertViewController.m
// CrushIt
//
//  Created by William O'Connor on 5/5/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import "textpertViewController.h"

@interface textpertViewController ()

@property (strong, nonatomic) UITextView* messageTextView;
@property (strong, nonatomic) UIButton* submitButton;
@property (strong, nonatomic) UILabel* responseLabel;

@end

@implementation textpertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Crush.wise";
    [self.self.navigationController.navigationBar pushNavigationItem:self.navigationItem animated:NO];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSNumber *height = [[NSNumber alloc] initWithDouble:screenHeight];
    NSNumber *width = [[NSNumber alloc] initWithDouble:screenWidth];
    
    NSMutableDictionary* screenSize = [[NSMutableDictionary alloc] init];
    
    screenSize[@"height"] = height;
    screenSize[@"width"] = width;
    
    self.view.backgroundColor = [UIColor colorWithRed:37/255.0 green:168/255.0 blue:234/255.0 alpha:1.0];
    
    // MESSAGE TEXT VIEW
    self.messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(10.0, 74.0, [screenSize[@"width"] floatValue]-20.0, [screenSize[@"width"] floatValue]/2)];
    [self.view addSubview:self.messageTextView];
    
    // SUBMIT
    self.submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.submitButton.frame = CGRectMake([screenSize[@"width"] floatValue]/2 - 50.0, 0.5*[screenSize[@"width"] floatValue] + 84, 100.0, 40.0);
    [self.submitButton addTarget:self
                     action:@selector(submit)
           forControlEvents:UIControlEventTouchUpInside];
    [self.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    self.submitButton.titleLabel.font = [UIFont fontWithName:@"Poiret One" size:18.0];
    [self.submitButton setTitleColor:[UIColor colorWithRed:0x48/255.0 green:0x98/255.0 blue:0xBD/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.submitButton.backgroundColor = [UIColor whiteColor];
    [self.submitButton.layer setBorderColor:[UIColor colorWithRed:0x1F/255.0 green:0x32/255.0 blue:0x4D/255.0 alpha:1.0].CGColor];
    [self.submitButton.layer setBorderWidth:1.0];
    [self.view addSubview:self.submitButton];
    
    // RESPONSE LABEL
    self.responseLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.5*[screenSize[@"width"] floatValue] + 124, [screenSize[@"width"] floatValue]-20.0, [screenSize[@"width"] floatValue]/2)];
    self.responseLabel.numberOfLines = 0;
    self.responseLabel.adjustsFontSizeToFitWidth = YES;
    self.responseLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.responseLabel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) submit
{
    [self.messageTextView resignFirstResponder];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.botlibre.com/rest/botlibre/form-chat?instance=879462&message=%@&application=5547154272718411871", [self stringToGetParams:self.messageTextView.text]]];
    NSData *responseData =  [NSData dataWithContentsOfURL:url];
    NSString* responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    responseString = [self parseXMLResponse:responseString];
    //nslog(@"response: %@", responseString);
    self.responseLabel.text = responseString;
}

- (NSString*) parseXMLResponse: (NSString*)xmlString
{
    NSArray *components = [xmlString componentsSeparatedByString:@"<message>"];
    NSString *afterOpenBracket = [components objectAtIndex:1];
    components = [afterOpenBracket componentsSeparatedByString:@"</message>"];
    NSString *message = [components objectAtIndex:0];
    return message;
}

- (NSString*) stringToGetParams: (NSString*)theString
{
    NSString* returnVal = [[NSString alloc] init];
    returnVal = [theString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    //nslog(@"returnVal: %@", returnVal);
    
    return returnVal;
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
