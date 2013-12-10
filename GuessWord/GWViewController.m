//
//  GWViewController.m
//  GuessWord
//
//  Created by Dannion on 13-12-9.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import "GWViewController.h"
#import "GWGridCell.h"
#import "ModelTest.h"

NSString *CollectionViewCellIdentifier = @"collectionViewGridCellIdentifier";
NSInteger gridHeightNum = 10;
NSInteger gridWidthNum = 10;

@interface GWViewController ()<PSUICollectionViewDelegateFlowLayout, UITextFieldDelegate>
{
    NSInteger gridHeight;//
    NSInteger gridWidth;//
}

@property (nonatomic, weak) IBOutlet PSUICollectionView* gridView;
@property (nonatomic, strong) UIImageView* gridBackgroundImageView;

@end

@implementation GWViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    #warning 测试用，后期应删掉
    [ModelTest testFunction];
    [self createGridView];
    
    [self loadData];
    
    //now we have data already, draw the actual grid.
    [self calculateCollectionViewCellSize];
    [self addBackgroundImage];
}

- (void)createGridView{
    PSUICollectionViewFlowLayout *layout = [[PSUICollectionViewFlowLayout alloc] init];
    _gridView.collectionViewLayout = layout;
    _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _gridView.delegate = self;
    _gridView.dataSource = self;
    _gridView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.000 alpha:1.000];
    [_gridView registerClass:[GWGridCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    
    [self.view addSubview:_gridView];
}

- (void)loadData{
    //从本地取
    [self refetchDataFromLocalCache];
    //从网络取
    [self refetchDataFromNetWork];
}

- (void)refetchDataFromLocalCache{
    
}

- (void)refetchDataFromNetWork{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Getters & Setters

-(UIImageView *)gridBackgroundImageView
{
    if (!_gridBackgroundImageView) {
        _gridBackgroundImageView = [[UIImageView alloc] init];
    }
    return _gridBackgroundImageView;
}


#pragma mark -
#pragma mark PSUICollectionViewDelegateFlowLayout
- (CGFloat)collectionView:(PSTCollectionView *)collectionView layout:(PSTCollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}
- (CGFloat)collectionView:(PSTCollectionView *)collectionView layout:(PSTCollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

#pragma mark -
#pragma mark Collection View Data Source

- (NSString *)formatIndexPath:(NSIndexPath *)indexPath {
    return [NSString stringWithFormat:@"{%ld,%ld}", (long)indexPath.row, (long)indexPath.section];
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GWGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    
    // set cell.text
    cell.label.text = @"";

    UIImage* aImage = [self createImageWithColor:[UIColor whiteColor]];
    cell.image.image = aImage;

    return cell;
}

#warning 后期换成直接用图片
- (UIImage*)createImageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)calculateCollectionViewCellSize
{
    NSLog(@"%f %f", _gridView.bounds.size.width, _gridView.bounds.size.height);
    
    int temp = (int)_gridView.bounds.size.width % (int)gridWidthNum;
    int newWidthAndHeight = _gridView.bounds.size.width-temp-1;
    CGRect gridViewFrame = CGRectMake(_gridView.frame.origin.x, _gridView.frame.origin.y, newWidthAndHeight, newWidthAndHeight);
    _gridView.frame = gridViewFrame;
    
    
    int width = (_gridView.bounds.size.width - gridWidthNum + 1) / gridWidthNum;
    int height = width;
    gridWidth = width;
    gridHeight = height;
}

- (void)addBackgroundImage
{
#warning 后期应该替换为 1像素点大小的黑色图片，伸展成合适大小。 而不是用色值来画图。
    UIImage* backgroundImage = [self createImageWithColor:[UIColor blackColor]];
    
    self.gridBackgroundImageView.frame = CGRectMake(_gridView.frame.origin.x-1, _gridView.frame.origin.y-1, _gridView.frame.size.width+2, _gridView.frame.size.height+2);
    
    self.gridBackgroundImageView.image = backgroundImage;
    
    [self.view addSubview:self.gridBackgroundImageView];
    [self.view bringSubviewToFront:_gridView];
    
}

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(gridWidth, gridHeight);
}


- (NSInteger)collectionView:(PSUICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return gridHeightNum * gridWidthNum;
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

    GWGridCell* selectedCell = (GWGridCell*)[_gridView cellForItemAtIndexPath:indexPath];
    [selectedCell.label becomeFirstResponder];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark -
#pragma mark keyboardNotification

- (void)keyboardWillShowNotification:(NSNotification *)notification
{
//    CGRect gridViewFrame = CGRectMake(_gridView.frame.origin.x, _gridView.frame.origin.y, gridWidth, gridHeight-100);
//    _gridView.frame = gridViewFrame;
}

- (void)keyboardWillHideNotification:(NSNotification *)notification
{
    //UI确定不要键盘动画
    /*
     NSDictionary * userInfo = notification.userInfo;
     CGRect endFrame = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
     
     if (endFrame.origin.y > 200)
     {
     
     if ([[UIDevice currentDevice] is4InchRetinaDisplay]) {
     //海外登陆显示
     [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
     //[self setAbroadLoginViewHidden:1];
     sinaWeiboBackgroudImageView.top = 56;
     textFieldBackgroudImageView.top += 19;
     loginNameTextField.top += 19;
     passwordTextField.top += 19;
     loginBtn.top += 26;
     if (accountMatchingView)
     {
     accountMatchingView.top = loginNameTextField.bottom;
     }
     } completion:^(BOOL finished){
     }];
     }
     else
     {
     [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
     sinaWeiboBackgroudImageView.top = 56;
     textFieldBackgroudImageView.top += 32;
     loginNameTextField.top += 32;
     passwordTextField.top += 32;
     loginBtn.top += 45;
     if (accountMatchingView)
     {
     accountMatchingView.top = loginNameTextField.bottom;
     }
     } completion:^(BOOL finished){
     }];
     }
     }
     */
}

@end
