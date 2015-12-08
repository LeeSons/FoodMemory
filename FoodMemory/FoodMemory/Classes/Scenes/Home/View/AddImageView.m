//
//  AddImageView.m
//  FoodMemory
//
//  Created by morplcp on 15/12/4.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#define kImageH 100 // 图片高度
#define kImageW 75 // 图片宽度
#define kMaxColumn 3 // 每行显示的图片个数
#define kMaxImageCount 9 // 最多显示图片个数
#define kDeleImageWH 25 // 删除按钮的宽高
#define kAdekeImage @"bac.jpg" // 删除按钮的图片
#define kAddImage @"nav_add" // 添加按钮的图片

#import "AddImageView.h"
#import "AppDelegate.h"

@interface AddImageView ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, assign) NSInteger editTag;

@end

@implementation AddImageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *btn = [self creatButtonWithImage:kAddImage andSelector:@selector(addNew:)];
        [self addSubview:btn];
    }
    return self;
}

- (NSMutableArray *)images{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (void)addNew:(UIButton *)sender{
    //
    if (![self deleClose:sender]) {
        self.editTag = -1;
        [self callImagePicker];
    }
}

- (void)changeOld:(UIButton *)sender{
    if (![self deleClose:sender]) {
        self.editTag = sender.tag;
        [self callImagePicker];
    }
}

- (BOOL)deleClose:(UIButton *)btn{
    if (btn.subviews.count == 2) {
        [[btn.subviews lastObject] removeFromSuperview];
        [self stop:btn];
        return YES;
    }
    return NO;
}

- (void)callImagePicker{
    UIImagePickerController *pc = [[UIImagePickerController alloc] init];
    pc.allowsEditing = YES;
    pc.delegate = self;
    [[self viewController] presentViewController:pc animated:YES completion:nil];
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (UIButton *)creatButtonWithImage:(id)imageNameOrImage andSelector:(SEL)selector{
    UIImage *addImage = nil;
    if ([imageNameOrImage isKindOfClass:[NSString class]]) {
        addImage = [UIImage imageNamed:imageNameOrImage];
    }else if ([imageNameOrImage isKindOfClass:[UIImage class]]){
        addImage = imageNameOrImage;
    }
    UIButton *addBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [addBtn setImage:addImage forState:(UIControlStateNormal)];
    [addBtn addTarget:self action:selector forControlEvents:(UIControlEventTouchUpInside)];
    addBtn.tag = self.subviews.count;
    // 添加长按手势
    if (addBtn.tag != 0) {
        UILongPressGestureRecognizer *gester = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [addBtn addGestureRecognizer:gester];
    }
    return addBtn;
}

- (void)longPress:(UIGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIButton *btn = (UIButton *)sender.view;
        UIButton *dele = [UIButton buttonWithType:(UIButtonTypeCustom)];
        dele.bounds = CGRectMake(0, 0, kDeleImageWH, kDeleImageWH);
        [dele setImage:[UIImage imageNamed:kAdekeImage] forState:(UIControlStateNormal)];
        [dele addTarget:self action:@selector(deletePic:) forControlEvents:(UIControlEventTouchUpInside)];
        dele.frame = CGRectMake(btn.frame.size.width - dele.frame.size.width, 0, dele.frame.size.width, dele.frame.size.height);
        [btn addSubview:dele];
        [self start:btn];
    }
}

- (void)start:(UIButton *)btn{
    double angle1 = -5.0 / 180.0 * M_PI;
    double angle2 = 5.0 / 180.0 * M_PI;
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.values = @[@(angle1),@(angle2),@(angle1)];
    anim.duration = 0.25;
    anim.repeatCount = MAXFLOAT;
    
    // 保持状态
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    [btn.layer addAnimation:anim forKey:@"shake"];
}

- (void)stop:(UIButton *)btn{
    [btn.layer removeAnimationForKey:@"shake"];
}

- (void)deletePic:(UIButton *)btn{
    [self.images removeObject:[(UIButton *)btn.superview imageForState:(UIControlStateNormal)]];
    [btn.superview removeFromSuperview];
    if ([[self.subviews lastObject] isHidden]) {
        [[self.subviews lastObject] setHidden:NO];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    NSInteger count = self.subviews.count;
    CGFloat btnW = kImageW;
    CGFloat btnH = kImageH;
    NSInteger maxColumn = kMaxColumn > self.frame.size.width / kImageW ? self.frame.size.width / kImageW : kMaxColumn;
    CGFloat marginX = (self.frame.size.width - maxColumn * btnW) / (count + 1);
    CGFloat marginY = marginX;
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.subviews[i];
        CGFloat btnX = (i % maxColumn) * (marginX + btnW) + marginX;
        CGFloat btnY = (i % maxColumn) * (marginY + btnH) + marginY;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (self.editTag == -1) {
        UIButton *btn = [self creatButtonWithImage:image andSelector:@selector(changeOld:)];
        [self insertSubview:btn atIndex:self.subviews.count - 1];
        [self.images addObject:image];
        if (self.subviews.count - 1 == kMaxImageCount) {
            [[self.subviews lastObject] setHidden:YES];
        }
    }else{
        UIButton *btn = (UIButton *)[self viewWithTag:self.editTag];
        NSInteger index = [self.images indexOfObject:[btn imageForState:(UIControlStateNormal)]];
        [self.images removeObjectAtIndex:index];
        [btn setImage:image forState:(UIControlStateNormal)];
        [self.images insertObject:image atIndex:index];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
