//
//  DynamicViewCell.m
//  FoodMemory
//
//  Created by morplcp on 15/12/6.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "DynamicViewCell.h"
#import "DynamicCollViewCell.h"
#import "AppDelegate.h"
#import "PhotoBoardViewController.h"
@interface DynamicViewCell ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong)NSMutableArray *placehoderArray;

@end

@implementation DynamicViewCell

static NSString *collCellIdent = @"imgColllCell";

- (void)awakeFromNib {
    [self.collView registerNib:[UINib nibWithNibName:@"DynamicCollViewCell" bundle:nil] forCellWithReuseIdentifier:collCellIdent];
    self.collView.delegate = self;
    self.collView.dataSource = self;
    self.collView.backgroundColor = RgbColor(231, 231, 231);
    self.collView.bounces = NO;
    [self setBodyHeight];
}

- (void)setDynamic:(AVObject *)dynamic{
    if (self.imgArray.count > 0) {
        [self.imgArray removeAllObjects];
    }
    if (self.imgHArray.count > 0) {
        [self.imgHArray removeAllObjects];
    }
    _dynamic = dynamic;
    _lblContent.text = [dynamic objectForKey:@"content"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    self.contentHeight.constant = [self getTextHeight:_lblContent.text];
    [dateFormatter setDateFormat:@"MM-dd"];
    _lblPostDate.text = [dateFormatter stringFromDate:dynamic.createdAt];
    _lblLocationName.text = [dynamic objectForKey:@"location_name"];
    [_btnZan setTitle:[NSString stringWithFormat:@"%@",[dynamic objectForKey:@"praise_count"]] forState:(UIControlStateNormal)];
    [_btnCommend setTitle:[NSString stringWithFormat:@"%@",[dynamic objectForKey:@"comments_count"]] forState:(UIControlStateNormal)];
    [_btnCollection setTitle:[NSString stringWithFormat:@"%@",[dynamic objectForKey:@"collection_count"]] forState:(UIControlStateNormal)];
    NSArray *array = [dynamic objectForKey:@"imgArray"];
    for (AVFile *file in array) {
        [self.imgHArray addObject:file.url];
        NSString *urlStr = [file getThumbnailURLWithScaleToFit:YES width:200 height:200];
        [self.imgArray addObject:urlStr];
    }
    [self getCollHeight:self.imgArray];
}

// 设置图片展示view的高度
- (void)getCollHeight:(NSArray *)array{
    if (array.count > 0 && array.count <= 3) {
        self.collHeight.constant = (kWindowWidth - 60) / 3.0 + 10;
    }else if (array.count > 3 && array.count <= 6){
        self.collHeight.constant = (kWindowWidth - 60) / 3.0 * 2 + 16;
    }else if (array.count > 6 && array.count <= 9){
        self.collHeight.constant = (kWindowWidth - 60) / 3.0 * 3 + 20;
    } else if (array.count == 0){
        self.collHeight.constant = 0;
    }
    [self setBodyHeight];
    [self.collView reloadData];
}

// 获取文本高度
- (CGFloat)getTextHeight:(NSString *)str{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(kWindowWidth - 40, 10000)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}
                                    context:nil];
    return rect.size.height;
}

// 设置动态展示view的高度
- (void)setBodyHeight{
    if (self.collHeight.constant == 0) {
        self.bodyViewHeight.constant = self.contentHeight.constant + 8;
    }
    self.bodyViewHeight.constant = [self getTextHeight:_lblContent.text] + self.collHeight.constant + 16;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark -UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imgArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DynamicCollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collCellIdent forIndexPath:indexPath];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.imgArray[indexPath.row]]];
    cell.imgIndex = indexPath.row;
    __weak typeof(self)vc = self;
    cell.showImage = ^(NSInteger index){
        AppDelegate *dele = [UIApplication sharedApplication].delegate;
        PhotoBoardViewController *photoVC = [PhotoBoardViewController new];
        photoVC.currentPhoto = index;
        
//        NSMutableArray *array = [NSMutableArray array];
//        for (NSString *url in vc.imgArray) {
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
//            UIImage *img = [UIImage imageWithData:data];
//            [array addObject:img];
//        }
      //  photoVC.thubArray = array;
        photoVC.imgArray = vc.imgHArray;
        [dele.mmdVC presentViewController:photoVC animated:YES completion:nil];
    };
    return cell;
}

#pragma maek -UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kWindowWidth - 60) / 3.0, (kWindowWidth - 60) / 3.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 2.5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

#pragma mark -lazyLoad

- (NSMutableArray *)imgArray{
    if (!_imgArray) {
        _imgArray = [NSMutableArray array];
    }
    return _imgArray;
}

- (NSMutableArray *)imgHArray{
    if (!_imgHArray) {
        _imgHArray = [NSMutableArray array];
    }
    return _imgHArray;
}

- (NSMutableArray *)placehoderArray{
    if (!_placehoderArray) {
        _placehoderArray = [NSMutableArray array];
    }
    return _placehoderArray;
}

- (IBAction)btnGroup:(UIButton *)sender {
}

- (IBAction)actionZan:(UIButton *)sender {
}

- (IBAction)actionCommend:(UIButton *)sender {
}

- (IBAction)btnCollection:(UIButton *)sender {
}


@end
