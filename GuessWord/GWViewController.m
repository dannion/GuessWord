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
#import "PMCustomKeyboard.h"
#import "BoardCell.h"



#define kGuessWordHeightChangeAmountWhenKeyBoardShowOrHide 100

NSString *CollectionViewCellIdentifier = @"collectionViewGridCellIdentifier";

@interface GWViewController ()<PSUICollectionViewDelegateFlowLayout, UITextFieldDelegate>
{
    NSInteger gridRowNum;//网格行数
    NSInteger gridColNum; //网格列数
    
    NSInteger gridCellHeight;//网格单元的高度
    NSInteger gridCellWidth; //网格单元的宽度
    
    GWGridCell* selectedGridCell;
    CGPoint selectedLocation;
    Word* selectedHorizontalWord;
    Word* selectedVerticalWord;
}

@property (nonatomic, weak) IBOutlet PSUICollectionView* gridView; //网格页面
@property (nonatomic, weak) IBOutlet UILabel* descriptionLabel;
@property (nonatomic, strong) UIImageView* gridViewBackgroundImageView; //网格背景页面

@end

@implementation GWViewController
@synthesize playBoard = _playBoard;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    #warning 测试用，后期应删掉
    [ModelTest testFunction];
    
    [self addViewBackgroundView];
    
    [self loadData];
    
    //now we have data already, draw the actual grid.
    [self createGridView];
    [self calculateCollectionViewCellSize];
    [self addGridViewBackgroundImage];
}

- (void)addViewBackgroundView
{
    UIView* backgroundAllView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:backgroundAllView];
    
    UIButton* backgroundButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    backgroundButton.isAccessibilityElement = NO;
    backgroundButton.backgroundColor = [UIColor clearColor];
    [backgroundButton addTarget:self action:@selector(tapRequest) forControlEvents:UIControlEventTouchUpInside];
    [backgroundAllView addSubview:backgroundButton];
}

- (void)createGridView
{
    PSUICollectionViewFlowLayout *layout = [[PSUICollectionViewFlowLayout alloc] init];
    _gridView.collectionViewLayout = layout;
    _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _gridView.delegate = self;
    _gridView.dataSource = self;
    _gridView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.000 alpha:1.000];
    [_gridView registerClass:[GWGridCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    
    [self.view addSubview:_gridView];
}

- (void)calculateCollectionViewCellSize
{
    NSLog(@"%f %f", _gridView.bounds.size.width, _gridView.bounds.size.height);
    
    int temp = (int)_gridView.bounds.size.width % (int)gridColNum;
    int newWidthAndHeight = _gridView.bounds.size.width-temp-1;
    CGRect gridViewFrame = CGRectMake(_gridView.frame.origin.x, _gridView.frame.origin.y, newWidthAndHeight, newWidthAndHeight);
    _gridView.frame = gridViewFrame;
    
    
    int width = (_gridView.bounds.size.width - gridColNum + 1) / gridColNum;
    int height = width;
    gridCellWidth = width;
    gridCellHeight = height;
}

- (void)addGridViewBackgroundImage
{
#warning 后期应该替换为 1像素点大小的黑色图片，伸展成合适大小。 而不是用色值来画图。
    UIImage* backgroundImage = [self createImageWithColor:[UIColor blackColor]];
    
    self.gridViewBackgroundImageView.frame = CGRectMake(_gridView.frame.origin.x-1, _gridView.frame.origin.y-1, _gridView.frame.size.width+2, _gridView.frame.size.height+2);
    
    self.gridViewBackgroundImageView.image = backgroundImage;
    
    [self.view addSubview:self.gridViewBackgroundImageView];
    [self.view bringSubviewToFront:_gridView];
}

#pragma mark -
#pragma mark LoadData
- (void)loadData
{
    
    
    
    //从本地数据库取
    [self refetchDataFromLocalCache];
    //从网络取
    [self refetchDataFromNetWork];
    
    //however, now we get data.
    [self playBoard];
    NSLog(@"%@", self.playBoard);
    
    gridRowNum = self.playBoard.height;
    gridColNum = self.playBoard.width;
    
}

- (void)refetchDataFromLocalCache
{
    
}

- (void)refetchDataFromNetWork
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Getters & Setters

- (UIImageView *)gridViewBackgroundImageView
{
    if (!_gridViewBackgroundImageView) {
        _gridViewBackgroundImageView = [[UIImageView alloc] init];
    }
    return _gridViewBackgroundImageView;
}

- (void)setPlayBoard:(PlayBoard *)playBoard
{
    _playBoard = playBoard;
}

- (PlayBoard *)playBoard
{
    if (!_playBoard) {
        _playBoard = [PlayBoard playBoardFromFile:@"td"];
    }
    return _playBoard;
}


#pragma mark -
#pragma mark PSUICollectionViewDelegateFlowLayout
- (CGFloat)collectionView:(PSTCollectionView *)collectionView layout:(PSTCollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
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
    GWGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    
    GWGridCellCurrentState cellCurrentState = [self gridCellCurrentStateFromIndexPath:indexPath];
    cell.label.delegate = self;
    
    
    switch (cellCurrentState) {
        case GWGridCellCurrentStateBlock:
            cell.label.text = @"";
            cell.imageView.image = [self createImageWithColor:[UIColor blackColor]];
            break;
        case GWGridCellCurrentStateBlank:
            cell.label.text = @"";
            cell.imageView.image = [self createImageWithColor:[UIColor whiteColor]];
            break;
        case GWGridCellCurrentStateGuessing:
            cell.label.text = [self gridCellCurrentStringFromIndexPath:indexPath];
            cell.imageView.image = [self createImageWithColor:[UIColor whiteColor]];
            break;
        case GWGridCellCurrentStateDone:
            cell.label.text = [self gridCellCurrentStringFromIndexPath:indexPath];
            cell.imageView.image = [self createImageWithColor:[UIColor whiteColor]];
            break;
        case GWGridCellCurrentStateUnKnown:
            cell.label.text = @"";
            cell.imageView.image = [self createImageWithColor:[UIColor redColor]];
            break;
        default:
            cell.label.text = @"";
            cell.imageView.image = [self createImageWithColor:[UIColor redColor]];
            break;
    }
    
    
    if ([self cellWithIndexPath:indexPath belongsToSelectedHorizontalWord:selectedHorizontalWord orSelectedVerticalWord:selectedVerticalWord]){//添加判断
        cell.imageView.image = [self createImageWithColor:[UIColor grayColor]];
    }
    return cell;
}

- (BOOL)cellWithIndexPath:(NSIndexPath*)indexPath belongsToSelectedHorizontalWord:(Word*)aSelectedHorizontalWord orSelectedVerticalWord:(Word*)aSelectedVerticalWord
{
    CGPoint location = [self locationFromIndexPath:indexPath];
    if (aSelectedHorizontalWord) {
        if (aSelectedHorizontalWord.start_y == (int)location.y) {
            if ((int)location.x - aSelectedHorizontalWord.start_x >= 0 && (int)location.x - aSelectedHorizontalWord.start_x < aSelectedHorizontalWord.length) {
                return YES;
            }
        }
    }
    if(aSelectedVerticalWord){
        if (aSelectedVerticalWord.start_x == (int)location.x) {
            if ((int)location.y - aSelectedVerticalWord.start_y >=0 && (int)location.y - aSelectedVerticalWord.start_y < aSelectedVerticalWord.length) {
                return YES;
            }
        }
    }
    return NO;
}

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(gridCellWidth, gridCellHeight);
}


- (NSInteger)collectionView:(PSUICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return gridRowNum * gridColNum;
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

    selectedGridCell = (GWGridCell*)[_gridView cellForItemAtIndexPath:indexPath];
    selectedLocation = [self locationFromIndexPath:indexPath];
    
    GWGridCellCurrentState cellCurrentState = [self gridCellCurrentStateFromIndexPath:indexPath];
    
    NSString* horizontalDescription = nil;
    NSString* verticalDescription = nil;
    
    //判断选中的cell是否在单词中，在的话为单词的所有cell染色。
    if (cellCurrentState != GWGridCellCurrentStateBlock) {
        
        CGPoint currentLocation = [self locationFromIndexPath:indexPath];
        selectedHorizontalWord = [self.playBoard wordOfPoint:currentLocation inHorizontalDirection:YES];
        if (selectedHorizontalWord) {
            horizontalDescription = selectedHorizontalWord.description;
            
            int length = selectedHorizontalWord.length;
            
            for (int i=0; i<length; i++) {
                CGPoint cellLocation = CGPointMake(selectedHorizontalWord.start_x+i, selectedHorizontalWord.start_y);
                NSIndexPath* indexPath = [self indexPathFromLocation:cellLocation];
                GWGridCell* gridCellWhichShouldShowAnswer = (GWGridCell*)[_gridView cellForItemAtIndexPath:indexPath];
                gridCellWhichShouldShowAnswer.imageView.image = [self createImageWithColor:[UIColor grayColor]];
            }
        }
        
        selectedVerticalWord = [self.playBoard wordOfPoint:currentLocation inHorizontalDirection:NO];
        if (selectedVerticalWord) {
            verticalDescription = selectedVerticalWord.description;
            
            int length = selectedVerticalWord.length;
            
            for (int i=0; i<length; i++) {
                CGPoint cellLocation = CGPointMake(selectedVerticalWord.start_x, selectedVerticalWord.start_y+i);
                NSIndexPath* indexPath = [self indexPathFromLocation:cellLocation];
                GWGridCell* gridCellWhichShouldShowAnswer = (GWGridCell*)[_gridView cellForItemAtIndexPath:indexPath];
                gridCellWhichShouldShowAnswer.imageView.image = [self createImageWithColor:[UIColor grayColor]];
            }
        }
  
    }
    
    //设置descriptionLabel文案
    self.descriptionLabel.text = [self descriptionStringMergeWithHorizontalDescription:horizontalDescription andVerticalDescription:verticalDescription];

    
    
    switch (cellCurrentState) {
        case GWGridCellCurrentStateBlock:
            selectedGridCell.label.userInteractionEnabled = NO;
            
            break;
        case GWGridCellCurrentStateBlank:
            // change color
            selectedGridCell.imageView.image = [self createImageWithColor:[UIColor brownColor]];
            
            selectedGridCell.label.userInteractionEnabled = YES;
            // 弹起键盘
            [[PMCustomKeyboard shareInstance] setTextView:selectedGridCell.label];
            [selectedGridCell.label becomeFirstResponder];
            break;
        case GWGridCellCurrentStateGuessing:
            // change color
            selectedGridCell.imageView.image = [self createImageWithColor:[UIColor brownColor]];

            selectedGridCell.label.userInteractionEnabled = YES;
            // 弹起键盘
            [[PMCustomKeyboard shareInstance] setTextView:selectedGridCell.label];
            [selectedGridCell.label becomeFirstResponder];
            break;
        case GWGridCellCurrentStateDone:
            // change color
            selectedGridCell.imageView.image = [self createImageWithColor:[UIColor brownColor]];

            selectedGridCell.label.userInteractionEnabled = YES;
            // 弹起键盘
            [[PMCustomKeyboard shareInstance] setTextView:selectedGridCell.label];
            [selectedGridCell.label becomeFirstResponder];
            break;
        case GWGridCellCurrentStateUnKnown:
            selectedGridCell.label.userInteractionEnabled = NO;

            break;
        default:
            
            break;
    }

}

- (void)collectionView:(PSTCollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Delegate cell %@ : DESELECTED", [self formatIndexPath:indexPath]);
    GWGridCell* deselectedGridCell = (GWGridCell*)[_gridView cellForItemAtIndexPath:indexPath];

    if (deselectedGridCell.label.userInteractionEnabled) {
        // change color
        selectedGridCell.imageView.image = [self createImageWithColor:[UIColor whiteColor]];
     
        deselectedGridCell.label.userInteractionEnabled = NO;
    }
    
    //判断选中的cell是否在单词中，在的话为单词的所有cell染色。
    CGPoint deselectLocation = [self locationFromIndexPath:indexPath];
    Word* deselectWord = [self.playBoard wordOfPoint:deselectLocation inHorizontalDirection:YES];
   
    if (deselectWord) {
        int length = deselectWord.length;
        
        for (int i=0; i<length; i++) {
            CGPoint cellLocation = CGPointMake(deselectWord.start_x+i, deselectWord.start_y);
            NSIndexPath* indexPath = [self indexPathFromLocation:cellLocation];
            GWGridCell* gridCellWhichShouldShowAnswer = (GWGridCell*)[_gridView cellForItemAtIndexPath:indexPath];
            gridCellWhichShouldShowAnswer.imageView.image = [self createImageWithColor:[UIColor whiteColor]];
        }
    }
    deselectWord = [self.playBoard wordOfPoint:deselectLocation inHorizontalDirection:NO];
    if (deselectWord) {
        int length = deselectWord.length;
        
        for (int i=0; i<length; i++) {
            CGPoint cellLocation = CGPointMake(deselectWord.start_x, deselectWord.start_y+i);
            NSIndexPath* indexPath = [self indexPathFromLocation:cellLocation];
            GWGridCell* gridCellWhichShouldShowAnswer = (GWGridCell*)[_gridView cellForItemAtIndexPath:indexPath];
            gridCellWhichShouldShowAnswer.imageView.image = [self createImageWithColor:[UIColor whiteColor]];
        }
    }

    
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
#pragma mark - Button Action
- (void)tapRequest
{
    if (selectedGridCell) {
        [selectedGridCell.label resignFirstResponder];
        selectedGridCell.label.userInteractionEnabled = NO;
    }
}


#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
 
    return YES;
}

#pragma mark -
#pragma mark UITextFieldTextDidChangeNotification
- (void)textFieldTextDidChangeNotification:(NSNotification *)notification
{
    UITextField* theTextField = (UITextField*)notification.object;
    if (theTextField.text.length >1) {
        //若长度大于1，值取string最后一位
        theTextField.text = [theTextField.text substringFromIndex:(theTextField.text.length-1)];
    }
    
    //用户已输入，调用playboard相应接口
    [self.playBoard updateBoardWithInputValue:theTextField.text atPoint:selectedLocation];
    
    
    //检查用户是否答对了
    
    //先判断垂直，再判断水平，最后判断是否整个网格都答对了
    if ([self.playBoard isBingoOfWordAtPoint:selectedLocation inHorizontalDirection:NO]){
        //答对了，将对应单词转换为汉字结果。
        Word* correctWord = [self.playBoard wordOfPoint:selectedLocation inHorizontalDirection:NO];
        
        int length = correctWord.length;
        
        for (int i=0; i<length; i++) {
            CGPoint cellLocation = CGPointMake(correctWord.start_x, correctWord.start_y+i);
            NSIndexPath* indexPath = [self indexPathFromLocation:cellLocation];
            GWGridCell* gridCellWhichShouldShowAnswer = (GWGridCell*)[_gridView cellForItemAtIndexPath:indexPath];
            gridCellWhichShouldShowAnswer.label.text = [self gridCellCurrentStringFromIndexPath:indexPath];
            //可以做动画
//            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//                
//            } completion:^(BOOL finished){
//                
//            }];

        }
    };
    if ([self.playBoard isBingoOfWordAtPoint:selectedLocation inHorizontalDirection:YES]){
        Word* correctWord = [self.playBoard wordOfPoint:selectedLocation inHorizontalDirection:YES];
        
        int length = correctWord.length;
        
        for (int i=0; i<length; i++) {
            //可以做动画
            CGPoint cellLocation = CGPointMake(correctWord.start_x+i, correctWord.start_y);
            NSIndexPath* indexPath = [self indexPathFromLocation:cellLocation];
            GWGridCell* gridCellWhichShouldShowAnswer = (GWGridCell*)[_gridView cellForItemAtIndexPath:indexPath];
            gridCellWhichShouldShowAnswer.label.text = [self gridCellCurrentStringFromIndexPath:indexPath];
        }
    };
    
    if ([self.playBoard isGameBoardCompleted]) {
        NSLog(@"闯关成功！！！！你真厉害！！");
    }
    
}

#pragma mark -
#pragma mark keyboardNotification

//弹出键盘时的动画
- (void)keyboardWillShowNotification:(NSNotification *)notification
{
//    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        CGRect newFrame = self.gridViewBackgroundImageView.frame;
//        newFrame.size.height -= kGuessWordHeightChangeAmountWhenKeyBoardShowOrHide;
//        self.gridViewBackgroundImageView.frame = newFrame;
//       
//    } completion:^(BOOL finished){
//        CGRect newFrame = self.gridView.frame;
//        newFrame.size.height -= kGuessWordHeightChangeAmountWhenKeyBoardShowOrHide;
//        self.gridView.frame = newFrame;
//    }];
    CGRect newFrame = self.gridViewBackgroundImageView.frame;
    newFrame.size.height -= kGuessWordHeightChangeAmountWhenKeyBoardShowOrHide;
    self.gridViewBackgroundImageView.frame = newFrame;
    newFrame = self.gridView.frame;
    newFrame.size.height -= kGuessWordHeightChangeAmountWhenKeyBoardShowOrHide;
    self.gridView.frame = newFrame;

}

//收起键盘时的动画
- (void)keyboardWillHideNotification:(NSNotification *)notification
{
//    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        CGRect newFrame = self.gridView.frame;
//        newFrame.size.height += kGuessWordHeightChangeAmountWhenKeyBoardShowOrHide;
//        self.gridView.frame = newFrame;
//    } completion:^(BOOL finished){
//        CGRect newFrame = self.gridViewBackgroundImageView.frame;
//        newFrame.size.height += kGuessWordHeightChangeAmountWhenKeyBoardShowOrHide;
//        self.gridViewBackgroundImageView.frame = newFrame;
//    }];
    CGRect newFrame = self.gridViewBackgroundImageView.frame;
    newFrame.size.height += kGuessWordHeightChangeAmountWhenKeyBoardShowOrHide;
    self.gridViewBackgroundImageView.frame = newFrame;
    newFrame = self.gridView.frame;
    newFrame.size.height += kGuessWordHeightChangeAmountWhenKeyBoardShowOrHide;
    self.gridView.frame = newFrame;
}

#pragma mark -
#pragma mark Temp Method
#warning 后期删去该方法。换成直接用图片
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

#pragma mark -
#pragma mark Internal Method
- (CGPoint)locationFromIndexPath:(NSIndexPath *)indexPath
{
    CGPoint location = CGPointMake(0, 0);
    location.x = indexPath.row % gridColNum;
    location.y = indexPath.row / gridColNum;
    
    return location;
}

- (NSIndexPath *)indexPathFromLocation:(CGPoint)location
{
    NSInteger index = (NSInteger)location.y * gridColNum + location.x;
    return [NSIndexPath indexPathForItem:index inSection:0];
}

- (BoardCell*)gridCellCurrentStringWithPlayBoard:(PlayBoard*)aPlayboard andLocation:(CGPoint)aLocation
{
    BoardCell* currentStateDescription;
    if (aPlayboard.current_state) {
        currentStateDescription = (BoardCell*)aPlayboard.current_state[(int)aLocation.y][(int)aLocation.x];
    }
    return currentStateDescription;
}

- (GWGridCellCurrentState)gridCellCurrentStateWithPlayBoard:(PlayBoard*)aPlayboard andLocation:(CGPoint)aLocation
{
    BoardCell* boardCell = [self gridCellCurrentStringWithPlayBoard:aPlayboard andLocation:aLocation];
    
    return boardCell.currentState;
}

- (NSString*)gridCellCurrentStringFromIndexPath:(NSIndexPath *)indexPath
{
    return [self gridCellCurrentStringWithPlayBoard:self.playBoard andLocation:[self locationFromIndexPath:indexPath]].display;
}

- (GWGridCellCurrentState)gridCellCurrentStateFromIndexPath:(NSIndexPath *)indexPath
{
    return [self gridCellCurrentStateWithPlayBoard:self.playBoard andLocation:[self locationFromIndexPath:indexPath]];
}


- (NSString*)descriptionStringMergeWithHorizontalDescription:(NSString*)horizontalDescription andVerticalDescription:(NSString*)verticalDescription
{
    NSString* finalString;
    if (horizontalDescription && verticalDescription) {
        finalString = [NSString stringWithFormat:@" 横:%@\n 竖:%@",horizontalDescription,verticalDescription];
    }else if(horizontalDescription){
        finalString = [NSString stringWithFormat:@" 横:%@",horizontalDescription];
    }else if(verticalDescription){
        finalString = [NSString stringWithFormat:@" 竖:%@",verticalDescription];
    }
    
    
    return finalString;
}

@end
