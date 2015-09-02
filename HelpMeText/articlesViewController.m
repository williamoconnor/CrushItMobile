//
//  articlesViewController.m
// CrushIt
//
//  Created by William O'Connor on 5/5/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import "articlesViewController.h"
#import "DataManager.h"
#import "articleViewController.h"

@interface articlesViewController ()

@property (strong, nonatomic) NSMutableArray* articles;
@property (strong, nonatomic) UITableView* tableview;
@property (strong, nonatomic) NSDictionary* selectedArticle;

@end

@implementation articlesViewController

-(NSMutableArray*)articles
{
    if (!_articles) {
        _articles = [[NSMutableArray alloc] init];
    }
    return _articles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Crush.blog";
    [self.self.navigationController.navigationBar pushNavigationItem:self.navigationItem animated:NO];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSNumber *height = [[NSNumber alloc] initWithDouble:screenHeight];
    NSNumber *width = [[NSNumber alloc] initWithDouble:screenWidth];
    
    NSDictionary* articles = [DataManager getArticles];
    for (NSDictionary* article in articles) {
        [self.articles addObject:article];
    }
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, [width floatValue], [height floatValue])];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:self.tableview];
    
    self.view.backgroundColor = [UIColor colorWithRed:37/255.0 green:168/255.0 blue:234/255.0 alpha:1.0];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    //nslog(@"self.articles: %@", self.articles);
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = self.articles[indexPath.row][@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat: @"By: %@", self.articles[indexPath.row][@"author"]];
    
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.articles count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedArticle = self.articles[indexPath.row];
    [self performSegueWithIdentifier:@"viewArticleSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    articleViewController* dest = segue.destinationViewController;
    dest.article = self.selectedArticle;
}

@end
