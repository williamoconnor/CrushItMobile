//
//  PhotosCollectionViewController.m
// CrushIt
//
//  Created by William O'Connor on 6/22/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import "PhotosCollectionViewController.h"
#import "ShowPhotoViewController.h"
#import "AppDelegate.h"

@interface PhotosCollectionViewController ()

@property (strong, nonatomic) NSMutableArray* photos;
@property (strong, nonatomic) NSMutableDictionary* screen;
@property (strong, nonatomic) UIImage* selectedImage;


@end

@implementation PhotosCollectionViewController

-(AppDelegate*) app
{
    return (AppDelegate*) [[UIApplication sharedApplication] delegate];
}

-(NSMutableArray*)photos
{
    if (!_photos) {
        _photos = [[NSMutableArray alloc] init];
    }
    return _photos;
}

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSNumber *height = [[NSNumber alloc] initWithDouble:screenHeight];
    NSNumber *width = [[NSNumber alloc] initWithDouble:screenWidth];
    
    self.screen = [[NSMutableDictionary alloc] init];
    self.screen[@"height"] = height;
    self.screen[@"width"] = width;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self performSelector:@selector(loadImages) withObject:nil afterDelay:0.1];
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadImages
{
    QBGeneralResponsePage *page = [QBGeneralResponsePage responsePageWithCurrentPage:1 perPage:20];
    
    [QBRequest blobsForPage:page successBlock:^(QBResponse *response, QBGeneralResponsePage *page, NSArray *blobs) {
        for (QBCBlob* blob in blobs) {
            [QBRequest downloadFileWithUID:blob.UID successBlock:^(QBResponse *response, NSData *fileData) {
                UIImage* blobImage = [UIImage imageWithData:fileData];
                [self.photos addObject:blobImage];
                //nslog(@"blob images: %@", self.photos);
                [self.collectionView reloadData];
            } statusBlock:^(QBRequest *request, QBRequestStatus *status) {
                // status
                //nslog(@"status: %f", status.percentOfCompletion);
                if (status.percentOfCompletion == 1.0000) {
                }
            } errorBlock:^(QBResponse *response) {
                // error
            }];
        }
    } errorBlock:^(QBResponse *response) {
        // handle errors
        //nslog(@"errors=%@", response.error);
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ShowPhotoViewController* dest = segue.destinationViewController;
    dest.image = self.selectedImage;
    dest.displayName = self.displayName;
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = self.photos[indexPath.row];
    [cell.contentView addSubview:imageView];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([self.screen[@"width"] floatValue]/4, [self.screen[@"width"] floatValue]/4);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedImage = self.photos[indexPath.row];
    [self performSegueWithIdentifier:@"showPhotoSegue" sender:self];
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
