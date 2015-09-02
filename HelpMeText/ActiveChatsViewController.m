//
//  ActiveChatsViewController.m
// CrushIt
//
//  Created by William O'Connor on 7/15/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import "ActiveChatsViewController.h"
#import "DataManager.h"
#import "ExpertTableViewCell.h"

@interface ActiveChatsViewController ()

@property (strong, nonatomic) NSMutableArray* chats;
@property (strong, nonatomic) NSMutableArray* expertsForChats;

@property (strong, nonatomic) UITableView* tableView;

@end

@implementation ActiveChatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSNumber *height = [[NSNumber alloc] initWithDouble:screenHeight];
    NSNumber *width = [[NSNumber alloc] initWithDouble:screenWidth];
    
    NSDictionary* activeChats = [DataManager getActiveUserChats:[NSString stringWithFormat:@"%@", self.account[@"id"]]];
    //nslog(@"%@", activeChats);
    self.chats = activeChats[@"chats"];
    self.expertsForChats = activeChats[@"experts"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, [width floatValue], [height floatValue])];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor= [UIColor colorWithRed:37/255.0 green:168/255.0 blue:234/255.0 alpha:1.0];
    [self.tableView registerClass:[ExpertTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    
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

#pragma mark - tableview

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // sends in the chat info, including the dialog_id, because it is there now
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpertTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary* expert = self.expertsForChats[indexPath.row];
    //nslog(@"here: %@", expert);
    NSString* ratingKey = @"Stars";
    if ([expert[@"expert"][@"rating"] integerValue] == 0) {
        ratingKey = @"Ratings";
    }
    cell.nameLabel.text = expert[@"user"][@"username"];
    cell.ratingLabel.text = [NSString stringWithFormat:@"Rating: %@ %@", expert[@"expert"][@"rating"], ratingKey];
    cell.costLabel.text = [NSString stringWithFormat:@"Cost: $%@", expert[@"expert"][@"cost"]];
    cell.expert = expert;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //nslog(@"%lu", [self.chats count]);
    return [self.chats count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

@end
