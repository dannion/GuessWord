//
//  GWCatagoryViewController.m
//  GuessWord
//
//  Created by Dannion on 13-12-17.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import "GWAppDelegate.h"
#import "CDVol+Interface.h"
#import "GWCatagoryViewController.h"
#import "GWCatagoryCell.h"
#import "GWLevelViewController.h"
#define UNIQUE_NUMBER_FOR_CATEGORY_1 500001
#define UNIQUE_NUMBER_FOR_CATEGORY_2 500002
#define UNIQUE_NUMBER_FOR_CATEGORY_3 500003
#define UNIQUE_NUMBER_FOR_CATEGORY_4 500004

NSString *GWCatagoryViewCellIdentifier = @"GWCatagoryViewCellIdentifier";

NSInteger catagoryAmount = 4; //类别数


@interface GWCatagoryViewController ()<PSUICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet PSUICollectionView* catagoryView;

@end

@implementation GWCatagoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self createGridView];
    self.view.backgroundColor = [self colorForBackground];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createGridView
{
    PSUICollectionViewFlowLayout *layout = [[PSUICollectionViewFlowLayout alloc] init];
    _catagoryView.collectionViewLayout = layout;
    _catagoryView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _catagoryView.delegate = self;
    _catagoryView.dataSource = self;
    _catagoryView.backgroundColor = [self colorForBackground];
    [_catagoryView registerClass:[GWCatagoryCell class] forCellWithReuseIdentifier:GWCatagoryViewCellIdentifier];
    
    [self.view addSubview:_catagoryView];
}

#pragma mark -
#pragma mark Prepare For Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CatagoryToLevel"]) {
        GWLevelViewController *destination = segue.destinationViewController;
        if ([sender isKindOfClass:[CDVol class]]) {
            destination.vol = (CDVol*)sender;
        }
    }
}


#pragma mark -
#pragma mark PSUICollectionViewDelegateFlowLayout
- (CGFloat)collectionView:(PSTCollectionView *)collectionView layout:(PSTCollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}
- (CGFloat)collectionView:(PSTCollectionView *)collectionView layout:(PSTCollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

#pragma mark -
#pragma mark Collection View Data Source

- (NSString *)formatIndexPath:(NSIndexPath *)indexPath
{
    return [NSString stringWithFormat:@"{%ld,%ld}", (long)indexPath.row, (long)indexPath.section];
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GWCatagoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GWCatagoryViewCellIdentifier forIndexPath:indexPath];
    
    int index = indexPath.row+1;
    
    NSString* imageString = [NSString stringWithFormat:@"group_0%d.png",index];
    NSString* titleString;
    switch (index) {
        case 1:
            titleString = @"电影知识";
            break;
        case 2:
            titleString = @"诗词歌赋";
            break;
        case 3:
            titleString = @"流行歌曲";
            break;
        case 4:
        default:
            titleString = @"随机模式";
            break;
    }
    
    cell.imageView.image = [UIImage imageNamed:imageString];
    cell.titleLabel.text = titleString;
    
    return cell;
    
}


- (CGSize)collectionViewCellSize
{
    int width = 295;
    int height = 58;
    return CGSizeMake(width, height);
}

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self collectionViewCellSize];//CGSizeMake(gridCellWidth, gridCellHeight);
}


- (NSInteger)collectionView:(PSUICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return  catagoryAmount;
}

#pragma mark -
#pragma mark Collection View Delegate

//- (void)collectionView:(PSTCollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"Delegate cell %@ : HIGHLIGHTED", [self formatIndexPath:indexPath]);
//}
//
//- (void)collectionView:(PSTCollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"Delegate cell %@ : UNHIGHLIGHTED", [self formatIndexPath:indexPath]);
//}

- (void)collectionView:(PSTCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int index = indexPath.row + 1;
    NSNumber *_category_unique_number;
    switch (index) {
        case 1:{
            _category_unique_number = [NSNumber numberWithInt:UNIQUE_NUMBER_FOR_CATEGORY_1];
            break;
        }
        case 2:{
            _category_unique_number = [NSNumber numberWithInt:UNIQUE_NUMBER_FOR_CATEGORY_2];
            break;
        }
        case 3:{
            _category_unique_number = [NSNumber numberWithInt:UNIQUE_NUMBER_FOR_CATEGORY_3];
            break;
        }
        case 4:{
            _category_unique_number = [NSNumber numberWithInt:UNIQUE_NUMBER_FOR_CATEGORY_4];
            break;
        }
        
        default:
        break;
    }
    NSLog(@"Delegate cell %@ : SELECTED", [self formatIndexPath:indexPath]);
    
#warning not finished, 这里应该生成一个Vol传给关卡页面
    GWAppDelegate *appDelegate=(GWAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    CDVol* selectedVol = [CDVol cdVolWithUniqueVolNumber:_category_unique_number
                                  inManagedObjectContext:context];
    
    [self performSegueWithIdentifier:@"CatagoryToLevel" sender:selectedVol];
}

- (void)collectionView:(PSTCollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Delegate cell %@ : DESELECTED", [self formatIndexPath:indexPath]);
    
}

//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"Check delegate: should cell %@ highlight?", [self formatIndexPath:indexPath]);
//    return YES;
//}
//
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"Check delegate: should cell %@ be selected?", [self formatIndexPath:indexPath]);
//    return YES;
//}
//
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"Check delegate: should cell %@ be deselected?", [self formatIndexPath:indexPath]);
//    return YES;
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark -
#pragma mark Image & Color Method

- (UIColor*)colorForBackground
{
    return [UIColor colorWithRed:234.0/256 green:234.0/256 blue:234.0/256 alpha:1.0];
}


@end
