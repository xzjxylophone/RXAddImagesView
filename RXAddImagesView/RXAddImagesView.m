//
//  RXAddImagesView.m
//  ZH
//
//  Created by Rush.D.Xzj on 16/3/4.
//  Copyright © 2016年 Rush.D.Xzj. All rights reserved.
//

#import "RXAddImagesView.h"
#import "TZImagePickerController.h"

@interface RXAddImagesView ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, TZImagePickerControllerDelegate>

@property (nonatomic, strong) UIView *imageContentView;

@property (nonatomic, strong) NSMutableArray *imageViews;


@property (nonatomic, strong) UIView *addView;


@property (nonatomic, assign) CGFloat imageWidth;

@property (nonatomic, assign) CGFloat leftPadding;
@property (nonatomic, assign) CGFloat leftPaddingOffset;
@property (nonatomic, assign) CGFloat topPaddingOffset;
@property (nonatomic, assign) CGFloat topPadding;
@property (nonatomic, assign) NSInteger maxLineCount;
@property (nonatomic, assign) NSInteger bottomPadding;


@end


@implementation RXAddImagesView


- (UIViewController *)self_viewController
{
    for (UIView *next = self.superview; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}



#pragma mark - Action
- (void)addViewAction:(id)sender
{
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [as addButtonWithTitle:@"拍照"];
    [as addButtonWithTitle:@"选择已有照片"];
    NSInteger cancelButtonIndex = [as addButtonWithTitle:@"取消"];
    as.cancelButtonIndex = cancelButtonIndex;
    UIViewController *vc = [self self_viewController];
    [as showInView:vc.view];
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    NSLog(@"buttonIndex:%zd", buttonIndex);
    switch (buttonIndex) {
        case 0: // 拍照
        {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            UIViewController *vc = [self self_viewController];
            [vc presentViewController:imagePickerController animated:YES completion:^{}];
        }
            break;
        case 1: // 从相册中选择
        {
            NSInteger max = 9 - self.images.count;
            // 需要设置相关extendLout
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:max delegate:self];
            imagePickerVc.allowPickingVideo = NO;
            UIViewController *vc = [self self_viewController];
            [vc presentViewController:imagePickerVc animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}
#pragma mark - TZImagePickerControllerDelegate
/// User finish picking photo，if assets are not empty, user picking original photo.
/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    [self.images addObjectsFromArray:photos];
    CGFloat lastHeight = self.frame.size.height;
    [self refreshView];
    CGFloat newHeight = self.frame.size.height;
    NSLog(@"lastHeight:%.2f, newHeight:%.2f", lastHeight, newHeight);
    if (lastHeight != newHeight) {
        [self.delegate imageCountChangedInRXAddImagesView:self];
    }
    
}

/// User finish picking video,
/// 用户选择好了视频
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    
    //
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    NSString *key = picker.allowsEditing ? UIImagePickerControllerEditedImage: UIImagePickerControllerOriginalImage;
    UIImage *image = [info objectForKey:key];
    [self.images addObject:image];
    
    CGFloat lastHeight = self.frame.size.height;
    [self refreshView];
    CGFloat newHeight = self.frame.size.height;
    NSLog(@"lastHeight:%.2f, newHeight:%.2f", lastHeight, newHeight);
    if (lastHeight != newHeight) {
        [self.delegate imageCountChangedInRXAddImagesView:self];
    }
}





- (void)x:(CGFloat *)x y:(CGFloat *)y withIndex:(NSInteger)index
{
    NSInteger remain = index % self.maxLineCount;
    NSInteger divide = index / self.maxLineCount;
    *x = self.leftPadding + (self.imageWidth + self.leftPaddingOffset) * remain;
    *y = self.topPadding + (self.imageWidth + self.topPaddingOffset) * divide;
}
- (void)refreshView
{
    for (UIView *view in self.imageViews) {
        [view removeFromSuperview];
    }
    [self.imageViews removeAllObjects];
    
    for (NSInteger i = 0; i < self.images.count; i++) {
        CGFloat x = 0;
        CGFloat y = 0;
        [self x:&x y:&y withIndex:i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, self.imageWidth, self.imageWidth)];
        imageView.image = self.images[i];
        [self addSubview:imageView];
        [self.imageViews addObject:imageView];
    }
    
    
    if (self.images.count == 9) {
        [self.addView removeFromSuperview];
    } else {
        CGFloat x = 0;
        CGFloat y = 0;
        [self x:&x y:&y withIndex:self.images.count];
        CGRect addFrame = self.addView.frame;
        addFrame.origin.x = x;
        addFrame.origin.y = y;
        self.addView.frame = addFrame;
        
        [self addSubview:self.addView];
    }
    
    NSInteger divide = (self.images.count + 1) / self.maxLineCount;
    NSInteger remain = (self.images.count + 1) % self.maxLineCount;
    
    NSInteger rowCount = divide + (remain > 0 ? 1 : 0);
    
    CGRect selfFrame = self.frame;
    selfFrame.size.height = self.topPadding + (self.imageWidth + self.topPaddingOffset) * rowCount - self.topPaddingOffset + self.bottomPadding;
    self.frame = selfFrame;
}




- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        
        self.leftPaddingOffset = 6;
        self.topPaddingOffset = 6;
        self.leftPadding = 11;
        self.topPadding = 11;
        self.bottomPadding = 15;
        self.maxLineCount = 4;
        self.imageWidth = (width - self.leftPaddingOffset * 3 - self.leftPadding * 2) / (CGFloat)self.maxLineCount;
        
        
        self.imageViews = [NSMutableArray array];
        self.images = [NSMutableArray array];
        
        
        self.addView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.imageWidth, self.imageWidth)];
        self.addView.backgroundColor = [UIColor redColor];
        
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addViewAction:)];
        [self.addView addGestureRecognizer:tgr];

        
        [self addSubview:self.addView];
        
        self.frame = CGRectMake(0, 0, width, 0);
        [self refreshView];
        
        
        
    }
    return self;
}







+ (id)rxAddImagesView
{
    id result = [[RXAddImagesView alloc] initWithFrame:CGRectZero];
    return result;
}





@end
