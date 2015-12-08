//
//  ReleaseViewController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/4.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "ReleaseViewController.h"
#import "ShowImageViewCell.h"
#import "SelectImageViewCell.h"
#import "Dynamic.h"
#import "AGIPCToolbarItem.h"
#import "AGImagePickerController.h"
#import "LCPAlertView.h"
#define kMaxCollectionHeight4 (290 / 3.0 + 10)*2
#define kMaxCollectionHeight4_7 330
@interface ReleaseViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, AGImagePickerControllerDelegate, UITextViewDelegate>

@property (nonatomic, strong)NSMutableArray *showImgArray;
@property (nonatomic, strong)AGImagePickerController *pic;
@property (weak, nonatomic) IBOutlet UITextView *txtContent;
@property (weak, nonatomic) IBOutlet UITextView *txtBePlacehoder;
@property (weak, nonatomic) IBOutlet UICollectionView *collViewPic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *txtHeight;
@property (nonatomic, strong) LCPAlertView *alert;

- (IBAction)actionSelectLocation:(UIButton *)sender;

- (IBAction)actionCancel:(UIBarButtonItem *)sender;

@end

static NSString *selectCellIdent = @"selectCell";
static NSString *showCellIdent = @"showCell";

@implementation ReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collViewPic registerNib:[UINib nibWithNibName:@"ShowImageViewCell" bundle:nil] forCellWithReuseIdentifier:showCellIdent];
    [self.collViewPic registerNib:[UINib nibWithNibName:@"SelectImageViewCell" bundle:nil] forCellWithReuseIdentifier:selectCellIdent];
    self.collViewPic.delegate = self;
    self.collViewPic.dataSource = self;
    self.txtContent.delegate = self;
    self.alert = [[LCPAlertView alloc] initWithFrame:CGRectMake(kWindowWidth / 2.0 - 75, kWindowHeight * 0.8, 150, 30)];
    _alert.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_alert];
    [self setImgPicker];
    [self setTextViewHeight];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshLayout];
    [self.collViewPic reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (![text isEqualToString:@""]) {
        [_txtBePlacehoder setHidden:YES];
    }
    if ([text isEqualToString:@""] && range.length == 1 && range.location == 0){
        [_txtBePlacehoder setHidden:NO];
    }
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark -UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.showImgArray.count >= 9) {
        return self.showImgArray.count;
    }else{
        return self.showImgArray.count + 1;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.showImgArray.count >= 9) {
        ShowImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:showCellIdent forIndexPath:indexPath];
        UIImage *img = self.showImgArray[indexPath.row];
        cell.imgView.image = img;
        cell.deleImg = img;
        __weak typeof (self)vc = self;
        cell.closeImg = ^(UIImage *deleImg){
            [vc.showImgArray removeObject:deleImg];
            [vc refreshLayout];
            [self.collViewPic reloadData];
        };
        return cell;
    }else{
        if (indexPath.row == self.showImgArray.count) {
            SelectImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:selectCellIdent forIndexPath:indexPath];
            return cell;
        }else {
            ShowImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:showCellIdent forIndexPath:indexPath];
            UIImage *img = self.showImgArray[indexPath.row];
            cell.imgView.image = img;
            cell.deleImg = img;
            __weak typeof (self)vc = self;
            cell.closeImg = ^(UIImage *deleImg){
                [vc.showImgArray removeObject:deleImg];
                [vc refreshLayout];
                [self.collViewPic reloadData];
                LCPLog(@"%ld",self.showImgArray.count);
            };
            return cell;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.showImgArray.count >= 9) {
        LCPLog(@"点了");
    }else{
        if (indexPath.row == self.showImgArray.count) {
            [self opAction];
        }
    }
}

#pragma maek -UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (IsiPhone4 || IsiPhone5) {
        return CGSizeMake(290 / 3.0, 290 / 3.0);
    }
    return CGSizeMake(100, 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 2.5;
}

#pragma mark -CustomMethod

- (void)setImgPicker{
    __block typeof (self)vc = self;
    self.pic = [AGImagePickerController sharedInstance:self];
    self.pic.didFailBlock = ^(NSError *error){
        LCPLog(@"%@",error);
        if (error == nil) {
            //[vc.selectImgArray removeAllObjects];
            LCPLog(@"取消了");
            [vc dismissViewControllerAnimated:YES completion:nil];
        } else {
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [vc dismissViewControllerAnimated:YES completion:nil];
            });
        }
    };
    self.pic.didFinishBlock = ^(NSArray *info){
        if (vc.showImgArray.count + info.count > 9) {
            [vc.pic alert:@"超过9张了哦！"];
            return;
        }
        NSMutableArray *array = [NSMutableArray arrayWithArray:info];
        NSMutableArray *arrayH = [NSMutableArray array];
        for (ALAsset *alasset in array) {
            CGImageRef refH = [[alasset defaultRepresentation] fullScreenImage];
            UIImage *imgH = [[UIImage alloc] initWithCGImage:refH];
            [arrayH addObject:imgH];
        }
        for (int i = 0; i < arrayH.count; i++) {
            [vc.showImgArray insertObject:arrayH[i] atIndex:0];
        }
        [vc dismissViewControllerAnimated:YES completion:nil];
    };
}

- (void)setTextViewHeight{
    if (IsiPhone4 || IsiPhone5) {
        self.txtHeight.constant = 100;
    }
}

- (void)refreshLayout{
    if (self.showImgArray.count <= 2) {
        self.collHeight.constant = 100 + 10;
    }else if (self.showImgArray.count > 2 && self.showImgArray.count <= 5){
        self.collHeight.constant = (100 + 10) * 2;
    }else{
        if (IsiPhone4 || IsiPhone5) {
            self.collHeight.constant = kMaxCollectionHeight4;
        }else {
            self.collHeight.constant = kMaxCollectionHeight4_7;
        }
    }
    if (self.showImgArray.count > 9) {
        NSInteger count = self.showImgArray.count;
        for (int i = 9; i < count; i++) {
            [self.showImgArray removeLastObject];
        }
    }
}

- (void)opAction{
    self.pic.shouldShowSavedPhotosOnTop = NO;
    self.pic.shouldChangeStatusBarStyle = YES;
    self.pic.maximumNumberOfPhotosToBeSelected = 9 - self.showImgArray.count;
    AGIPCToolbarItem *selectAll = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"全选" style:UIBarButtonItemStyleBordered target:nil action:nil] andSelectionBlock:^BOOL(NSUInteger index, ALAsset *asset) {
        return YES;
    }];
    AGIPCToolbarItem *deselectAll = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"取消全选" style:UIBarButtonItemStyleBordered target:nil action:nil] andSelectionBlock:^BOOL(NSUInteger index, ALAsset *asset) {
        return NO;
    }];
    self.pic.toolbarItemsForManagingTheSelection = @[selectAll,deselectAll];
    [self presentViewController:_pic animated:YES completion:nil];
    [_pic showFirstAssetsController];
}

// 发表动态
- (void)postDynamic:(NSArray *)array{
    Dynamic *dynamic = [[Dynamic alloc] init];
    dynamic.uId = @"123456789";
    dynamic.content = self.txtContent.text;
    if (array) {
        dynamic.imgArray = [NSMutableArray arrayWithArray:array];
    }
    dynamic.praise_count = 0;
    dynamic.collection_count = 0;
    dynamic.comments_count = 0; // 查询评论表相关本条动态的评论个数
    dynamic.location_name = @"天上";
    [LeanCloudDBHelper saveObjectWithClassName:@"dynamic" Model:dynamic CallBack:^(BOOL result) {
        if (result) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newDynamic" object:@1];
        }
    }];
}

#pragma mark -lazyLoad

- (NSMutableArray *)showImgArray{
    if (!_showImgArray) {
        _showImgArray = [NSMutableArray array];
    }
    return _showImgArray;
}

- (IBAction)actionSelectLocation:(UIButton *)sender {
    
}

- (IBAction)actionCancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 发表
- (IBAction)actionPost:(UIBarButtonItem *)sender {
    if (self.txtContent.text == nil || [self.txtContent.text isEqualToString: @""]) {
        self.alert.message = @"不能发布空状态";
        [self.alert show];
        return;
    }
    __weak typeof (self)vc = self;
    __block NSMutableArray *imgFileArray = [NSMutableArray array];
    if (self.showImgArray.count == 0) {
        [self postDynamic:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newDynamic" object:@0];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    for (int i = 0; i < self.showImgArray.count; i++) {
        NSData *data = UIImagePNGRepresentation(self.showImgArray[i]);
        __block AVFile *imgFile = [AVFile fileWithName:@"dynamicImg" data:data];
        [imgFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [imgFileArray addObject:imgFile];
            if (imgFileArray.count == vc.showImgArray.count) {
                [self postDynamic:imgFileArray];
            }
        } progressBlock:^(NSInteger percentDone) {
            LCPLog(@"%ld",percentDone);
        }];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newDynamic" object:@0];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end