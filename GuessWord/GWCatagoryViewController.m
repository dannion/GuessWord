//
//  GWCatagoryViewController.m
//  GuessWord
//
//  Created by Dannion on 13-12-17.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import "GWCatagoryViewController.h"
#import "GWCatagoryCell.h"
#import "GWLevelViewController.h"

NSString *GWCatagoryViewCellIdentifier = @"GWCatagoryViewCellIdentifier";

NSInteger catagoryRowNum = 3;//网格行数
NSInteger catagoryColNum = 3; //网格列数

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
    if ([segue.identifier isEqualToString:@"VolToLevel"]) {
        GWLevelViewController *destination = segue.destinationViewController;
        if ([destination respondsToSelector:@selector(setData:)])
        {
            //[destination setValue:@"这是要传递的数据" forKey:@"data"];
        }
    }
}


#pragma mark -
#pragma mark PSUICollectionViewDelegateFlowLayout
- (CGFloat)collectionView:(PSTCollectionView *)collectionView layout:(PSTCollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 30;
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
    GWCatagoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GWCatagoryViewCellIdentifier forIndexPath:indexPath];
    
    cell.label.text = @"123";
    
    // load the image for this cell
    NSString *imageToLoad = [NSString stringWithFormat:@"1.jpeg"];
    UIImage *aImage = [UIImage imageNamed:imageToLoad];
    
    cell.imageView.image = aImage;
    
    return cell;
    
}


- (CGSize)collectionViewCellSize
{
    int width = _catagoryView.bounds.size.width / 2;
    int height = width;
    return CGSizeMake(width, height);
}

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self collectionViewCellSize];//CGSizeMake(gridCellWidth, gridCellHeight);
}


- (NSInteger)collectionView:(PSUICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return catagoryRowNum * catagoryColNum;
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
    
    [self performSegueWithIdentifier:@"CatagoryToLevel" sender:nil];
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
