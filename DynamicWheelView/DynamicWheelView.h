//
//  DynamicWheelView.h
//  CustomPromptView
//
//  Created by pzk on 16/6/8.
//  Copyright © 2016年 Aone. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DynamicWheelDelegate <NSObject>
-(void)select:(NSInteger)index;
//下滑刷新数据
-(void)refreshData;
//上滑加载数据
-(void)loadData;
@end

@interface DynamicWheelView : UIView

@property (weak, nonatomic) id <DynamicWheelDelegate> delegate;

//若传入的界面还可以做其他事，扩展字典
//传入数组 @[@{@"image":UIImage,@"other":@""},@{@"image":UIImage},nil]
@property(nonatomic,strong) NSMutableArray *wheelArray;

//附加数组，用来处理获取网络加载后的数据
@property(nonatomic,strong) NSArray *cacheArray;

//重写初始化方法
-(instancetype)initWithFrame:(CGRect)frame;

@end
