//
//  GWLevelViewController.m
//  GuessWord
//
//  Created by Dannion on 13-12-17.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import "GWLevelViewController.h"
#import "GWLevelCell.h"
#import "GWGridViewController.h"
#import "PlayBoard.h"
#import "GWAppDelegate.h"


NSString *GWLevelViewCellIdentifier = @"GWLevelViewCellIdentifier";

//NSInteger levelRowNum = 3;//网格行数
NSInteger levelColNum = 3; //网格列数

@interface GWLevelViewController ()<PSUICollectionViewDelegateFlowLayout>
{
    NSNumber* selectedLevel;
}

@property (nonatomic, weak) IBOutlet PSUICollectionView* levelView;

@end

@implementation GWLevelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.levelView reloadData];
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
    _levelView.collectionViewLayout = layout;
    _levelView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _levelView.delegate = self;
    _levelView.dataSource = self;
    _levelView.backgroundColor = [self colorForBackground];
    [_levelView registerClass:[GWLevelCell class] forCellWithReuseIdentifier:GWLevelViewCellIdentifier];
    
    [self.view addSubview:_levelView];
}

#pragma mark -
#pragma mark Prepare For Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"LevelToGrid"]) {
        GWGridViewController *destination = segue.destinationViewController;
        
        [destination setVolNumber:self.vol.uniqueVolNumber];
        [destination setLevel: selectedLevel];
    }
}

#pragma mark -
#pragma mark PSUICollectionViewDelegateFlowLayout
- (CGFloat)collectionView:(PSTCollectionView *)collectionView layout:(PSTCollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
- (CGFloat)collectionView:(PSTCollectionView *)collectionView layout:(PSTCollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

#pragma mark -
#pragma mark Collection View Data Source

- (NSString *)formatIndexPath:(NSIndexPath *)indexPath
{
    return [NSString stringWithFormat:@"{%ld,%ld}", (long)indexPath.row, (long)indexPath.section];
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GWLevelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GWLevelViewCellIdentifier forIndexPath:indexPath];
    
    int index = indexPath.row + 1;
    cell.label.text = [NSString stringWithFormat:@"%d", index];
    
    
    GWAppDelegate *appDelegate=(GWAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    NSArray *localCDPlayBoards = [CDPlayBoard cdPlayBoardsByVolNumber:self.vol.uniqueVolNumber
                                               inManagedObjectContext:context];
    CDPlayBoard *playboard= [localCDPlayBoards objectAtIndex:indexPath.row];
    
    
    switch ([playboard.star intValue]) {
        case 0:
            if ([playboard.islocked boolValue]) {
                cell.imageView.image = [UIImage imageNamed:@"nostar_bg.png"];
                cell.lockImageView.image = [UIImage imageNamed:@"locked_icon.png"];
                cell.lockImageView.hidden = NO;
            }else{
                cell.imageView.image = [UIImage imageNamed:@"nostar_bg.png"];
                cell.lockImageView.image = [UIImage imageNamed:@"unlocked_icon.png"];
                cell.lockImageView.hidden = NO;
            }
            break;
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"1star_bg.png"];
            cell.lockImageView.hidden = YES;
            break;
        case 2:
            cell.imageView.image = [UIImage imageNamed:@"2stars_bg.png"];
            cell.lockImageView.hidden = YES;
            break;
        case 3:
            cell.imageView.image = [UIImage imageNamed:@"3stars_bg.png"];
            cell.lockImageView.hidden = YES;
            break;
        default:
            break;
    }
    
//    cell.imageView.image = aImage;
    
    return cell;
    
}


- (CGSize)collectionViewCellSize
{
    int width = 84;//_levelView.bounds.size.width / (levelColNum+1);
    int height = 85;
    return CGSizeMake(width, height);
}

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self collectionViewCellSize];//CGSizeMake(gridCellWidth, gridCellHeight);
}


- (NSInteger)collectionView:(PSUICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    if (self.vol) {
        return [self.vol.amountOfLevels intValue];
    }else{
        return 0;
    }
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
    NSLog(@"Delegate cell %@ : SELECTED", [self formatIndexPath:indexPath]);
    int selectedLevelIntValue = indexPath.row + 1;

    GWAppDelegate *appDelegate=(GWAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSArray *localCDPlayBoards = [CDPlayBoard cdPlayBoardsByVolNumber:self.vol.uniqueVolNumber
                                               inManagedObjectContext:context];
    CDPlayBoard *playboard= [localCDPlayBoards objectAtIndex:indexPath.row];
    if ([playboard.islocked boolValue]) {
        return;
    }
    
    //翻转动画，然后页面跳转
    UIView* selectedCell = [self.levelView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft  forView:selectedCell cache:YES];
        
    } completion:^(BOOL finished) {
        
        selectedLevel = [NSNumber numberWithInt:selectedLevelIntValue];
        [self performSegueWithIdentifier:@"LevelToGrid" sender:nil];
    }];
    
    
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
