//
//  GWViewController.m
//  GuessWord
//
//  Created by Dannion on 13-12-9.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import "GWGridViewController.h"
#import "GWGridCell.h"
#import "ModelTest.h"
#import "PMCustomKeyboard.h"
#import "BoardCell.h"
#import "GWNetWorkingWrapper.h"
#import "GWInsetsLabel.h"
#import "GWScoreCounter.h"
#import "GWAccountStore.h"


NSString *GWGridViewCellIdentifier = @"GWGridViewCellIdentifier";

@interface GWGridViewController ()<PSUICollectionViewDelegateFlowLayout>
{
    NSInteger gridRowNum;//网格行数
    NSInteger gridColNum; //网格列数
    
    NSInteger gridCellHeight;//网格单元的高度
    NSInteger gridCellWidth; //网格单元的宽度
    
    GWGridCell* selectedGridCell;
    CGPoint selectedLocation;
    Word* selectedHorizontalWord;
    Word* selectedVerticalWord;
    
    GWScoreCounter* scoreCounter;
}

@property (nonatomic, weak) IBOutlet PSUICollectionView* gridView; //网格页面
@property (nonatomic, weak) IBOutlet GWInsetsLabel* descriptionLabel;
@property (nonatomic, strong) UIImageView* gridViewBackgroundImageView; //网格背景页面

@end

@implementation GWGridViewController
@synthesize playBoard = _playBoard;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:kCustomKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:kCustomKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:kCustomKeyboardDidEnterCharacterNotification object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    #warning 测试用，后期应删掉
    [ModelTest testFunction];
    
    
    // init GUI elements
    [self createGridView];
    [self addViewBackgroundView];
    [self setupLabel];
    
    //load Data
    [self loadData];
}



- (void)setupLabel
{
    self.descriptionLabel.textColor = [self colorForDescriptionLabelText];
    self.descriptionLabel.backgroundColor = [self colorForDescriptionLabelBackground];
    self.descriptionLabel.insets = UIEdgeInsetsMake(0, 14, 0, 0);
    self.descriptionLabel.text = @"点击网格中白色单元开始游戏\n输入所猜汉字的拼音首字母即可";
}


- (void)refreshWithNewData
{
    
    gridRowNum = self.playBoard.height;
    gridColNum = self.playBoard.width;
    
    selectedGridCell = nil;
    selectedHorizontalWord = nil;
    selectedVerticalWord = nil;
    
    [self calculateCollectionViewCellSize];
    [self addGridViewBackgroundImage];
    [self.gridView reloadData];
    if ([PMCustomKeyboard shareInstance].isShowing) {
        [[PMCustomKeyboard shareInstance] removeFromSuperview:YES];
    }
    
}


- (void)addViewBackgroundView
{
    UIView* backgroundAllView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    backgroundAllView.backgroundColor = [self colorForBackgroundView];
    [self.view addSubview:backgroundAllView];
    [self.view sendSubviewToBack:backgroundAllView];
    
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
    _gridView.backgroundColor = [self colorForBackgroundView];
    [_gridView registerClass:[GWGridCell class] forCellWithReuseIdentifier:GWGridViewCellIdentifier];
    
    [self.view addSubview:_gridView];
}

- (void)calculateCollectionViewCellSize
{
    NSLog(@"%f %f", _gridView.bounds.size.width, _gridView.bounds.size.height);
    
    int newWidthAndHeight;
    int temp = (int)_gridView.bounds.size.width % (int)gridColNum;
    if (temp != gridColNum - 1) {
        newWidthAndHeight = _gridView.bounds.size.width - temp - 1;
    }else{
        newWidthAndHeight = _gridView.bounds.size.width;

    }
    
         CGRect gridViewFrame = CGRectMake(_gridView.frame.origin.x, _gridView.frame.origin.y, newWidthAndHeight, newWidthAndHeight);
    _gridView.frame = gridViewFrame;
    
    
    int width = (_gridView.bounds.size.width - gridColNum + 1) / gridColNum;
    int height = width;
    gridCellWidth = width;
    gridCellHeight = height;
}

- (void)addGridViewBackgroundImage
{
#warning 后期应该替换为 1像素点大小的图片，伸展成合适大小。 而不是用色值来画图。
  
    self.gridViewBackgroundImageView.frame = CGRectMake(_gridView.frame.origin.x-1, _gridView.frame.origin.y-1, _gridView.frame.size.width+2, _gridView.frame.size.height+2);
    
    self.gridViewBackgroundImageView.backgroundColor = [self colorForBackgroundView];

    [self.view addSubview:self.gridViewBackgroundImageView];
    [self.view bringSubviewToFront:_gridView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popViewControllerAnimated:(BOOL)animated
{
    if (self.playBoard.uniqueid) {
        if (scoreCounter) {
            [self.playBoard saveToDataBaseWithFinalScore:scoreCounter.currentScore];
        }else{
            [self.playBoard saveToDataBaseWithFinalScore:0];
        }
    }
    
    
    [super popViewControllerAnimated:animated];
}

#pragma mark -
#pragma mark LoadData
- (void)loadData
{
    //逻辑： 根据PlayBoard的UniqueID来获取数据。 先查找本地数据库是否有，没有则访问网络获取。
    
    //从本地数据库取
    [self refetchDataFromLocalCache];
    //从网络取
    [self refetchDataFromNetWork];
    
}

- (void)refetchDataFromLocalCache
{
    //从数据库里获取网格
//    if (self.uniqueID) {
//        _playBoard = [PlayBoard playBoardFromLocalDatabaseByUniqueID:self.uniqueID];
//        
//        if (_playBoard) {
//            //now we have data already, draw the actual grid.
//            [self refreshWithNewData];
//        }
//        
//    }else
    if (self.volNumber && self.level) {
        _playBoard = [PlayBoard playBoardFromLocalDataBaseByVolNumber:self.volNumber andLevel:self.level];
        
        if (_playBoard) {
            //now we have data already, draw the actual grid.
            [self refreshWithNewData];
        }
        
    }

}

- (void)refetchDataFromNetWork
{
    //本地有数据，则不发送网络请求
    if (_playBoard.uniqueid) {
        return;
    }
    NSMutableDictionary* parameterDictionary = [NSMutableDictionary dictionary];
//    if (self.uniqueID) {
//        [parameterDictionary setValue:self.uniqueID forKey:@"uid"];
//    }
    if (self.volNumber && self.level) {
//        [parameterDictionary setValue:@101001 forKey:@"vol"];
        [parameterDictionary setValue:self.volNumber forKey:@"vol"];
        [parameterDictionary setValue:self.level forKey:@"lv"];
    }
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.gridView animated:YES];
    hud.color = [UIColor whiteColor];
    hud.labelTextColor = [UIColor blueColor];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"加载中，请稍候！";
    
    [GWNetWorkingWrapper getPath:@"playboard.php" parameters:parameterDictionary successBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"NewData!");
        [MBProgressHUD hideAllHUDsForView:self.gridView animated:YES];
        
        PlayBoard* playBoard = [PlayBoard playBoardFromData:operation.responseData];
        _playBoard = playBoard;
        
        if (!_playBoard.uniqueid) {
            NSLog(@"服务器数据错误！");
            
            MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.gridView animated:YES];
            hud.color = [UIColor whiteColor];
            hud.labelTextColor = [UIColor blueColor];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"服务器数据错误！";
            [hud hide:YES afterDelay:2.0];
            
            return;
        }
        
        //now we have data already, draw the actual grid.
        [self refreshWithNewData];
        [self.playBoard saveToDataBaseWithFinalScore:0];
        
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.gridView animated:NO];
        
        MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.color = [UIColor whiteColor];
        hud.labelTextColor = [UIColor blueColor];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"无法连接服务器，请检查网络是否处于工作状态！";
        [hud hide:YES afterDelay:2.0];
    }];
    
    
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

//- (void)setPlayBoard:(PlayBoard *)playBoard
//{
//    _playBoard = playBoard;
//}
//
//- (PlayBoard *)playBoard
//{
//    if (!_playBoard) {
//        _playBoard = [PlayBoard playBoardFromFile:@"puz1"];
//    }
//    return _playBoard;
//}


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
    GWGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GWGridViewCellIdentifier forIndexPath:indexPath];
    
    GWGridCellCurrentState cellCurrentState = [self gridCellCurrentStateFromIndexPath:indexPath];
//    cell.label.delegate = self;
    
    
    switch (cellCurrentState) {
        case GWGridCellCurrentStateBlock:
            cell.label.text = @"";
            cell.imageView.image = [self imageForBlockCell];
            break;
        case GWGridCellCurrentStateBlank:
            cell.label.text = @"";
            cell.imageView.image = [self imageForClickableCell];
            break;
        case GWGridCellCurrentStateGuessing:
            cell.label.text = [self gridCellCurrentStringFromIndexPath:indexPath];
            cell.imageView.image = [self imageForClickableCell];
            break;
        case GWGridCellCurrentStateDone:
            cell.label.text = [self gridCellCurrentStringFromIndexPath:indexPath];
            cell.imageView.image = [self imageForClickableCell];
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
    
    if (selectedGridCell) {
        if ([self cellWithIndexPath:indexPath belongsToSelectedHorizontalWord:selectedHorizontalWord orSelectedVerticalWord:selectedVerticalWord]){//添加判断
            cell.imageView.image = [self imageForRelatedCell];
        }
        CGPoint cellLocation = [self locationFromIndexPath:indexPath];
        if (cellLocation.x == selectedLocation.x && cellLocation.y == selectedLocation.y) {
            cell.imageView.image = [self imageForSelectedCell];
        }
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
    
    if (!scoreCounter) {
        scoreCounter = [GWScoreCounter beginGameWithCurrentPlayBoard:self.playBoard];
    }

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
                gridCellWhichShouldShowAnswer.imageView.image = [self imageForRelatedCell];
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
                gridCellWhichShouldShowAnswer.imageView.image = [self imageForRelatedCell];
            }
        }
  
    }
    
    //设置descriptionLabel文案
    self.descriptionLabel.text = [self descriptionStringMergeWithHorizontalDescription:horizontalDescription andVerticalDescription:verticalDescription];

    
    
    switch (cellCurrentState) {

        case GWGridCellCurrentStateBlank:
        case GWGridCellCurrentStateGuessing:
        case GWGridCellCurrentStateDone:
            // change color
            selectedGridCell.imageView.image = [self imageForSelectedCell];

            // 弹起键盘
            [[PMCustomKeyboard shareInstance] showInView:self.view animated:YES];
            break;
        case GWGridCellCurrentStateBlock:
        case GWGridCellCurrentStateUnKnown:
            if ([PMCustomKeyboard shareInstance].isShowing) {
                [[PMCustomKeyboard shareInstance] removeFromSuperview:YES];
            }
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
        selectedGridCell.imageView.image = [self imageForClickableCell];
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
            gridCellWhichShouldShowAnswer.imageView.image = [self imageForClickableCell];
        }
    }
    deselectWord = [self.playBoard wordOfPoint:deselectLocation inHorizontalDirection:NO];
    if (deselectWord) {
        int length = deselectWord.length;
        
        for (int i=0; i<length; i++) {
            CGPoint cellLocation = CGPointMake(deselectWord.start_x, deselectWord.start_y+i);
            NSIndexPath* indexPath = [self indexPathFromLocation:cellLocation];
            GWGridCell* gridCellWhichShouldShowAnswer = (GWGridCell*)[_gridView cellForItemAtIndexPath:indexPath];
            gridCellWhichShouldShowAnswer.imageView.image = [self imageForClickableCell];
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
    if ([PMCustomKeyboard shareInstance].isShowing) {
        [[PMCustomKeyboard shareInstance] removeFromSuperview];
    }
}


#pragma mark -
#pragma mark UITextFieldTextDidChangeNotification
- (void)textFieldTextDidChangeNotification:(NSNotification *)notification
{
    NSString* inputChar = notification.object;
    
    if ([inputChar isEqualToString:@" "]) {
        [self resetPlayBoard];
        return;
    }
    selectedGridCell.label.text = inputChar;
    
    //用户已输入，调用playboard相应接口
    CGPoint nextPoint = [self.playBoard nextPointByUpdatingBoardWithInputValue:inputChar atPoint:selectedLocation];
    NSLog(@"nextPoint = %f, %f", nextPoint.x, nextPoint.y);
    
    //调用playboard接口 1.检查用户是否填完了 2.检查用户是否答对了
    // a 未填完 无提示
    // b 填完 答错 提示错误
    // c 填完 答对 显示正确汉字答案
    
    //先判断垂直方向，再判断水平方向
    if ([self.playBoard isFullFillOfWordAtPoint:selectedLocation inHorizontalDirection:NO]) {
        
        if (![self.playBoard isBingoOfWordAtPoint:selectedLocation inHorizontalDirection:NO]){
            //答错了，弹出错误提示
            [scoreCounter userEnterWrongAnswer];
            [self showErrorToast];
            
        }else{
            //答对了，将对应单词转换为汉字结果。
            Word* correctWord = [self.playBoard wordOfPoint:selectedLocation inHorizontalDirection:NO];
            [scoreCounter userEnterCorrectWord:correctWord];
            
            int length = correctWord.length;
            
            for (int i=0; i<length; i++) {
                CGPoint cellLocation = CGPointMake(correctWord.start_x, correctWord.start_y+i);
                NSIndexPath* indexPath = [self indexPathFromLocation:cellLocation];
                GWGridCell* gridCellWhichShouldShowAnswer = (GWGridCell*)[_gridView cellForItemAtIndexPath:indexPath];
                gridCellWhichShouldShowAnswer.label.text = [self gridCellCurrentStringFromIndexPath:indexPath];

                [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft  forView:gridCellWhichShouldShowAnswer cache:YES];
                    gridCellWhichShouldShowAnswer.label.text = [self gridCellCurrentStringFromIndexPath:indexPath];
                } completion:^(BOOL finished) {
                    
                }];
                
            }
            
        }
    }
    
    //水平方向
    if ([self.playBoard isFullFillOfWordAtPoint:selectedLocation inHorizontalDirection:YES]) {
        
        if (![self.playBoard isBingoOfWordAtPoint:selectedLocation inHorizontalDirection:YES]) {
            //答错了，弹出错误提示
            [scoreCounter userEnterWrongAnswer];
            [self showErrorToast];
            
        }else{
            //答对了，将对应单词转换为汉字结果。
            Word* correctWord = [self.playBoard wordOfPoint:selectedLocation inHorizontalDirection:YES];
            [scoreCounter userEnterCorrectWord:correctWord];
            
            int length = correctWord.length;
            
            for (int i=0; i<length; i++) {
                CGPoint cellLocation = CGPointMake(correctWord.start_x+i, correctWord.start_y);
                NSIndexPath* indexPath = [self indexPathFromLocation:cellLocation];
                GWGridCell* gridCellWhichShouldShowAnswer = (GWGridCell*)[_gridView cellForItemAtIndexPath:indexPath];
//                gridCellWhichShouldShowAnswer.label.text = [self gridCellCurrentStringFromIndexPath:indexPath];
                                
                [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft  forView:gridCellWhichShouldShowAnswer cache:YES];
                    gridCellWhichShouldShowAnswer.label.text = [self gridCellCurrentStringFromIndexPath:indexPath];
                } completion:^(BOOL finished) {
                    
                }];
            }

        }
    }

    //判断游戏是否已经结束
    if ([self.playBoard isGameBoardCompleted]) {

        [self hasCompletedTheGame];
        
    }else{
        //输入焦点自动跳到下一个位置
        if (1) {//这里需要加入判断nextpoint是否存在的逻辑
            [self collectionView:self.gridView didSelectItemAtIndexPath:[self indexPathFromLocation:nextPoint]];
        }
    }
}



#pragma mark -
#pragma mark keyboardNotification

//弹出键盘时的动画
- (void)keyboardWillShowNotification:(NSNotification *)notification
{
    
    CGFloat keyboardHeight = ((UIView*)notification.object).bounds.size.height;
    
    CGFloat changeHeight = keyboardHeight - 82;//CGRectGetMaxY(self.view.frame) + CGRectGetMaxY(self.gridViewBackgroundImageView.frame);//真正位移高度为 键盘高度减去网格底部与页面底部的距离
    
    CGRect newFrame = self.gridViewBackgroundImageView.frame;
    newFrame.size.height -= changeHeight;
    self.gridViewBackgroundImageView.frame = newFrame;
    
    newFrame = self.gridView.frame;
    newFrame.size.height -= changeHeight;
    self.gridView.frame = newFrame;

//    CGPoint newContentOffset = self.gridView.contentOffset;
//    newContentOffset.y += changeHeight;
//    self.gridView.contentOffset = newContentOffset;
}

//收起键盘时的动画
- (void)keyboardWillHideNotification:(NSNotification *)notification
{
    
    CGFloat keyboardHeight = ((UIView*)notification.object).bounds.size.height;
 
    CGFloat changeHeight = keyboardHeight - 82;//CGRectGetMaxY(self.view.frame) + CGRectGetMaxY(self.gridViewBackgroundImageView.frame);//真正位移高度为 键盘高度减去网格底部与页面底部的距离
    
    CGRect newFrame = self.gridViewBackgroundImageView.frame;
    newFrame.size.height += changeHeight;
    self.gridViewBackgroundImageView.frame = newFrame;
    newFrame = self.gridView.frame;
    newFrame.size.height += changeHeight;
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
#pragma mark Image & Color Method

- (UIColor*)colorForBackgroundView
{
    UIColor* color = [UIColor colorWithRed:234.0/256 green:234.0/256 blue:234.0/256 alpha:1.0];
    return color;
}

- (UIColor*)colorForDescriptionLabelBackground
{
    UIColor* color = [UIColor colorWithRed:220.0/256 green:220.0/256 blue:220.0/256 alpha:1.0];
    return color;
}

- (UIColor*)colorForDescriptionLabelText
{
    UIColor* color = [UIColor colorWithRed:112.0/256 green:110.0/256 blue:110.0/256 alpha:1.0];
    return color;
}

- (UIImage*)imageForBlockCell
{
    UIColor* color = [UIColor colorWithRed:207.0/256 green:204.0/256 blue:204.0/256 alpha:1.0];
    
    return [self createImageWithColor:color];
}

- (UIImage*)imageForClickableCell
{
    UIColor* color = [UIColor whiteColor];
    
    return [self createImageWithColor:color];
}

- (UIImage*)imageForSelectedCell
{
    UIColor* color = [UIColor colorWithRed:127.0/256 green:184.0/256 blue:115.0/256 alpha:1.0];
    
    return [self createImageWithColor:color];
}
- (UIImage*)imageForRelatedCell
{
    UIColor* color = [UIColor colorWithRed:221.0/256 green:247.0/256 blue:215.0/256 alpha:1.0];
    
    return [self createImageWithColor:color];
}

#pragma mark -
#pragma mark Internal Method

- (void)showErrorToast
{
//    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.color = [UIColor whiteColor];
//    hud.labelTextColor = [UIColor blueColor];
//    hud.mode = MBProgressHUDModeText;
//    hud.labelText = @"猜错了！";
//    [hud hide:YES afterDelay:1.0];
}

- (void)showCompletedToast
{
    //答错了，弹出错误提示
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.color = [UIColor whiteColor];
    
    hud.labelText = @"闯关成功！";
    hud.labelTextColor = [UIColor blueColor];
    
    hud.detailsLabelText = [NSString stringWithFormat:@"你获得的分数是:%d！你真厉害！", scoreCounter.currentScore];
    hud.detailsLabelTextColor = [UIColor blackColor];
    [hud hide:YES afterDelay:3.0];
}
- (void)hasCompletedTheGame
{
    //这里写完成游戏逻辑
    NSLog(@"闯关成功！！！！你真厉害！！");
    [self showCompletedToast];
    [scoreCounter endGame];
    NSLog(@"score = %d!", scoreCounter.currentScore);
    
    //如果用户登陆了，就上传分数给服务器
    if ([[GWAccountStore shareStore] hasLogined]) {
        [self sendScoreToServer];
    }
    
}

- (void)resetPlayBoard
{
    [self.playBoard resetBoard];
    [self refreshWithNewData];
    [scoreCounter resetCounter];
}

- (void)sendScoreToServer
{
//    示例：http://10.105.223.24/CrossWordPuzzlePHP/sendscore.php?user=xx&score=xx&id=xx
    NSMutableDictionary* paraDic = [NSMutableDictionary dictionary];
    GWAccount* currentAccount = [[GWAccountStore shareStore] currentAccount];
    [paraDic setObject:currentAccount.username forKey:@"user"];
    [paraDic setObject:[NSNumber numberWithInt:scoreCounter.currentScore] forKey:@"score"];
    [paraDic setObject:self.playBoard.uniqueid forKey:@"id"];
    
    [GWNetWorkingWrapper getPath:@"sendscore.php" parameters:paraDic successBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}
#pragma mark -
#pragma mark Internal Method to do with indexPath,location and gridcell state
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
