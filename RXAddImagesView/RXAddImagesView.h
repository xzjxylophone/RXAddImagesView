//
//  RXAddImagesView.h
//  ZH
//
//  Created by Rush.D.Xzj on 16/3/4.
//  Copyright © 2016年 Rush.D.Xzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RXAddImagesView;


@protocol RXAddImagesViewDelegate <NSObject>

- (void)imageCountChangedInRXAddImagesView:(RXAddImagesView *)rxAddImagesView;

@end

@interface RXAddImagesView : UIView
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, weak) id<RXAddImagesViewDelegate> delegate;


+ (id)rxAddImagesView;


@end
