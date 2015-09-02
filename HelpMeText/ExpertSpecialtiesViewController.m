//
//  ExpertSpecialtiesViewController.m
// CrushIt
//
//  Created by William O'Connor on 6/14/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import "ExpertSpecialtiesViewController.h"
#import "ExpertSpecialtyTile.h"
#import "ExpertsViewController.h"
#import "ActiveChatsViewController.h"

@interface ExpertSpecialtiesViewController ()

@property (strong, nonatomic) NSArray* specialties;
@property (strong, nonatomic) NSArray* images;
@property (strong, nonatomic) UIScrollView* scrollView;
@property (strong, nonatomic) NSString* selectedSpecialty;

@end

@implementation ExpertSpecialtiesViewController

-(NSArray*)specialties
{
    if (!_specialties){
        _specialties = [[NSArray alloc] initWithObjects:@"Females", @"Males", @"Gay - Males", @"Gay - Females", @"Black", @"Hispanic", @"Recently Single", nil];
    }
    return _specialties;
}

-(NSArray*)images
{
    if (!_images){
        _images = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"camel.jpg"], [UIImage imageNamed:@"camel.jpg"], [UIImage imageNamed:@"camel.jpg"], [UIImage imageNamed:@"camel.jpg"], [UIImage imageNamed:@"camel.jpg"], [UIImage imageNamed:@"camel.jpg"], [UIImage imageNamed:@"camel.jpg"], nil];
    }
    return _images;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:37/255.0 green:168/255.0 blue:234/255.0 alpha:1.0];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSNumber *height = [[NSNumber alloc] initWithDouble:screenHeight];
    NSNumber *width = [[NSNumber alloc] initWithDouble:screenWidth];
    
    // Scroll View
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, [width floatValue], [height floatValue] + 20.0)];
    self.scrollView.contentSize = CGSizeMake([width floatValue], 20);
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:self.scrollView];
    
    // active chats button
    UIButton* activeChatsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    activeChatsButton.frame = CGRectMake([width floatValue]/2 - 70.0, 20.0, 140.0, 40.0);
    [activeChatsButton setTitle:@"Active Chats" forState:UIControlStateNormal];
    [activeChatsButton setBackgroundColor:[UIColor whiteColor]];
    [activeChatsButton addTarget:self action:@selector(activeChatsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:activeChatsButton];
    
    // Create the buttons
    float tileHeight = ([width floatValue]/2) - 40;
    float tileWidth = ([width floatValue]/2) - 40;
    float y = 80.0;
    float x = 20.0;
    x += tileWidth+40; // get it set up
    y -= tileHeight+40;
    
    
    for (int i = 0; i < self.specialties.count; i++) {
        //create a tile
        
        if (i%2 == 0) {//even - left
            y += tileHeight+40;
            x -= (tileWidth+40);
            self.scrollView.contentSize = CGSizeMake([width floatValue], self.scrollView.contentSize.height+tileHeight+40);
        }
        else if (i%2 == 1){//odd - right
            x += tileWidth+40;
        }
        
        ExpertSpecialtyTile* tile = [[ExpertSpecialtyTile alloc] initWithFrame:CGRectMake(x, y, tileWidth, tileHeight) andName:self.specialties[i]/* andImage:self.images[i]*/];
        [tile addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        // background color
        [self.scrollView addSubview:tile];
        
    }
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
    
    if ([segue.destinationViewController isKindOfClass:[ExpertsViewController class]]) {
        ExpertsViewController* dest = segue.destinationViewController;
        dest.specialty = self.selectedSpecialty;
    }
    else if ([segue.destinationViewController isKindOfClass:[ActiveChatsViewController class]]) {
        ActiveChatsViewController* dest = segue.destinationViewController;
        dest.account = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    }
}


-(void)buttonPressed:(id) sender
{
    ExpertSpecialtyTile *buttonClicked = (ExpertSpecialtyTile *)sender;
    self.selectedSpecialty = buttonClicked.name;
    //nslog(@"butotn: %@", buttonClicked);
    buttonClicked.backgroundColor = [UIColor whiteColor];
    [self performSegueWithIdentifier:@"expertsSegue" sender:self];
}

-(void)buttonDepressed:(id) sender
{
    ExpertSpecialtyTile *buttonClicked = (ExpertSpecialtyTile *)sender;
    buttonClicked.backgroundColor = [UIColor blueColor];
}

-(void)activeChatsButtonPressed
{
    [self performSegueWithIdentifier:@"activeChatsSegue" sender:self];
}

@end
