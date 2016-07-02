//
//  ViewController.m
//  DynamicWheelView
//
//  Created by pzk on 16/6/26.
//  Copyright © 2016年 Aone. All rights reserved.
//

#import "ViewController.h"
#import "DynamicWheelView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenScale [UIScreen mainScreen].bounds.size.width/320.0

@interface ViewController ()<DynamicWheelDelegate>

@property (strong, nonatomic) DynamicWheelView *dynamicWheelView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _dynamicWheelView=[[DynamicWheelView alloc] initWithFrame:CGRectMake(0, 102, kScreenWidth, 326*kScreenScale)];
    _dynamicWheelView.delegate=self;
    _dynamicWheelView.wheelArray=[self wheel];
    [self.view addSubview:_dynamicWheelView];
    [self.view sendSubviewToBack:_dynamicWheelView];
}

-(NSMutableArray *)wheel{
    UIImage *image1=[UIImage imageNamed:@"1.jpg"];
    UIImage *image2=[UIImage imageNamed:@"2.jpg"];
    UIImage *image3=[UIImage imageNamed:@"3.jpg"];
    UIImage *image4=[UIImage imageNamed:@"4.jpg"];
    UIImage *image5=[UIImage imageNamed:@"5.jpg"];
    return [NSMutableArray arrayWithObjects:@{@"image":image1},@{@"image":image2},@{@"image":image3},@{@"image":image4},@{@"image":image5}, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- DynamicWheelDelegate
-(void)select:(NSInteger)index{
    //默认index从1开始,等同于初始数组index为0
    NSLog(@"单击了%ld",(long)index);
}

-(void)refreshData{
    //网络抓取的数据赋给appendArray
    
    NSLog(@"刷新数据");
}

-(void)loadData{
    //网络抓取的数据赋给appendArray
    
    NSLog(@"没有数据了");
    sleep(1);
}


@end
