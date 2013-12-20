//
//  GWVolViewController.m
//  GuessWord
//
//  Created by Dannion on 13-12-17.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import "GWVolViewController.h"
#import "GWVolCell.h"
#import "GWLevelViewController.h"
#import "GWNetWorkingWrapper.h"
#import "CDVol+Interface.h"
#import "GWAppDelegate.h"


NSString *GWVolViewCellIdentifier = @"GWVolViewCellIdentifier";

//NSInteger volRowNum = 3;//网格行数
NSInteger volColNum = 3; //网格列数

@interface GWVolViewController ()<PSUICollectionViewDelegateFlowLayout>
{
    CDVol* selectedVol;
}

@property (nonatomic, weak) IBOutlet PSUICollectionView* volView;

@property (nonatomic, strong) NSArray* volArray;

@end



@implementation GWVolViewController

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
    
    [self loadData];
}

#pragma mark -
#pragma mark LoadData
- (void)loadData
{
    //逻辑：先查找本地数据库是否有，有则展现，同时访问网络获取新数据，如果有新数据，展现新数据并写入数据库。
    
    //从本地数据库取
    [self refetchDataFromLocalCache];
    //从网络取
    [self refetchDataFromNetWork];
    
}

- (void)refreshWithNewData
{
    [self.volView reloadData];
}

- (void)refetchDataFromLocalCache
{
//    GWAppDelegate *appDelegate=(GWAppDelegate *)[[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *context = appDelegate.managedObjectContext;
//    _volArray = [CDVol cdVolsFromFile:@"allVols" inManagedObjectContext:context];
//    NSLog(@"通过网络获取的全部期信息，共有%d期数据",[self.volArray count]);
//
//    [self refreshWithNewData];
}

- (void)refetchDataFromNetWork
{
    NSMutableDictionary* parameterDictionary = [NSMutableDictionary dictionary];

    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.volView animated:YES];
    hud.color = [UIColor whiteColor];
    hud.labelTextColor = [UIColor blueColor];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"加载中，请稍候！";
    
    [GWNetWorkingWrapper getPath:@"overview.php" parameters:parameterDictionary successBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"NewData!");
        [MBProgressHUD hideAllHUDsForView:self.volView animated:YES];
        
        GWAppDelegate *appDelegate=(GWAppDelegate *)[[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context = appDelegate.managedObjectContext;

        _volArray = [CDVol cdVolsWithJsonData:operation.responseData
                            inManagedObjectContext:context];
        NSLog(@"通过网络获取的全部期信息，共有%d期数据",[_volArray count]);
        
        if (_volArray) {
            [self refreshWithNewData];
        }
        
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.volView animated:YES];
        
        MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.color = [UIColor whiteColor];
        hud.labelTextColor = [UIColor blueColor];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"无法连接服务器！";
        [hud hide:YES afterDelay:1.0];
    }];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createGridView
{
    PSUICollectionViewFlowLayout *layout = [[PSUICollectionViewFlowLayout alloc] init];
    _volView.collectionViewLayout = layout;
    _volView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _volView.delegate = self;
    _volView.dataSource = self;
    _volView.backgroundColor = [self colorForBackground];
    [_volView registerClass:[GWVolCell class] forCellWithReuseIdentifier:GWVolViewCellIdentifier];
    
    [self.view addSubview:_volView];
}

#pragma mark -
#pragma mark Prepare For Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"VolToLevel"]) {
        GWLevelViewController *destination = segue.destinationViewController;
        if ([sender isKindOfClass:[CDVol class]]) {
            destination.vol = (CDVol*)sender;
            NSLog(@"%@", destination.vol);
        }
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
    GWVolCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GWVolViewCellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == _volArray.count-1) {
        cell.volNumberLabel.text = @"下一期";
        cell.backgroundImageView.image = [UIImage imageNamed:@"vol_next.png"];
        cell.detailLabel.text = @"12月27日";
    }else{
        CDVol* vol = (CDVol*)[_volArray objectAtIndex:indexPath.row];
        cell.volNumberLabel.text = vol.name;
        cell.backgroundImageView.image = [UIImage imageNamed:@"vol_active.png"];
        cell.detailLabel.text = @"12月27日";
    }
    
    return cell;

}


- (CGSize)collectionViewCellSize
{
    int width = 85;
    int height = 85;
    return CGSizeMake(width, height);
}

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self collectionViewCellSize];//CGSizeMake(gridCellWidth, gridCellHeight);
}


- (NSInteger)collectionView:(PSUICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    if (_volArray) {
        return _volArray.count;
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
    if (_volArray) {
        selectedVol = _volArray[indexPath.row];
    }
    
    UIView* selectedCell = [self.volView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft  forView:selectedCell cache:YES];
        
    } completion:^(BOOL finished) {
        
        [self performSegueWithIdentifier:@"VolToLevel" sender:selectedVol];

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
