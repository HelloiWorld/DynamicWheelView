# DynamicWheelView
动态轮子，修改自code4app上项目MNWheelView（静态多ImageView实现图片轮播），用3个ImageView实现无限循环的功能，类似TableView重用机制，有点击以及下拉刷新和上拉加载更多的代理方法

![Image](https://github.com/HelloiWorld/DynamicWheelView/blob/master/DynamicWheelView/Assets.xcassets/2AA67A66-7EFF-40E3-B917-888EB9469492.imageset/2AA67A66-7EFF-40E3-B917-888EB9469492.png)

###使用方法  
    #import "DynamicWheelView.h"   
#####实现DynamicWheelDelegate  
    DynamicWheelView *dynamicWheelView=[[DynamicWheelView alloc] initWithFrame:CGRectMake(0, 102, [UIScreen mainScreen].bounds.size.width, 326)];  
    dynamicWheelView.delegate=self;  
    UIImage *image1=[UIImage imageNamed:@"1.jpg"];  
    UIImage *image2=[UIImage imageNamed:@"2.jpg"];  
    UIImage *image3=[UIImage imageNamed:@"3.jpg"];  
    UIImage *image4=[UIImage imageNamed:@"4.jpg"];  
    UIImage *image5=[UIImage imageNamed:@"5.jpg"];  
    dynamicWheelView.wheelArray=[NSMutableArray arrayWithObjects:@{@"image":image1},@{@"image":image2},@{@"image":image3},@{@"image":image4},@{@"image":image5}, nil];  
    [self.view addSubview:dynamicWheelView];  
  
#####实现点击和上下拉的代理DynamicWheelDelegate  
    -(void)select:(NSInteger)index{  
    //默认index从1开始,等同于初始数组index为0  
    NSLog(@"单击了%ld",(long)index);  
    }  
  
    -(void)refreshData{
    NSLog(@"刷新数据");
    }  
  
    -(void)loadData{  
    NSLog(@"没有数据了");  
    }  

