//
//  DynamicWheelView.h
//  CustomPromptView
//
//  Created by pzk on 16/6/8.
//  Copyright © 2016年 Aone. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DynamicWheelDelegate <NSObject>
//点击按钮的序号【1，+00）
-(void)select:(NSInteger)index;
//下滑⬇️刷新数据,将网络抓取的数据赋给appendArray
-(void)refreshData;
//上滑⬆️加载数据,将网络抓取的数据赋给appendArray
-(void)loadData;
@end

@interface DynamicWheelView : UIView

@property (weak, nonatomic) id <DynamicWheelDelegate> delegate;

//传入数组 @[@{@"image":UIImage,@"other":@""},@{@"image":UIImage},nil]
@property(nonatomic,strong) NSMutableArray *wheelArray;

//附加数组，用来处理获取网络加载后的数据
@property(nonatomic,strong) NSArray *appendArray;

//重写初始化方法
-(instancetype)initWithFrame:(CGRect)frame;

@end
