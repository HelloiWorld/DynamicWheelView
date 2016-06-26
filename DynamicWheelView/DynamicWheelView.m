//
//  DynamicWheelView.m
//  CustomPromptView
//
//  Created by pzk on 16/6/8.
//  Copyright © 2016年 Aone. All rights reserved.
//

#import "DynamicWheelView.h"

//快速生成颜色
#define MNRGB(r,g,b) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0])
//动画时间
#define AnimateDuration 0.3
#define TopViewHeight 84
#define CenterViewHeight 104

@implementation DynamicWheelView{
    UIView *_baseView;
    BOOL isAnimating;
    //中间的ImageView所在数组的位置（默认index=tag+1，使用数组时需减1）
    NSInteger selectedIndex;
}

-(NSArray *)cacheArray{
    if (!_cacheArray) {
        _cacheArray = [NSArray arrayWithArray:_wheelArray];
    }
    return _cacheArray;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        if(!_baseView){
            [self initBaseView];
        }
    }
    return self;
}

- (void)initBaseView{
    _baseView=[[UIView alloc]initWithFrame:self.bounds];
//    NSLog(@"baseView: %@",NSStringFromCGRect(_baseView.frame));
    [self addSubview:_baseView];
    
    selectedIndex=2;
    
    UISwipeGestureRecognizer *recUp=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUpDown:)];
    recUp.direction=UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:recUp];
    UISwipeGestureRecognizer *recDown=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUpDown:)];
    recDown.direction=UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:recDown];
    
}

-(void)setWheelArray:(NSMutableArray *)wheelArray{
    _wheelArray=wheelArray;
    
    CGFloat marginTop=14;
    CGFloat marginCenter=11;
    
    for (int i=0; i<3; i++) {
        
        UIImageView *imageView=[[UIImageView alloc]initWithImage:wheelArray[i][@"image"]];
        
        if (i==0) {
            imageView.frame=CGRectMake(72, marginTop, _baseView.frame.size.width-72*2, TopViewHeight);
        }else if(i==2){
            imageView.frame=CGRectMake(72, TopViewHeight+CenterViewHeight+marginTop+marginCenter*2, _baseView.frame.size.width-72*2, TopViewHeight);
        }else{
            imageView.frame=CGRectMake(50+2, TopViewHeight+marginTop+marginCenter, _baseView.frame.size.width-4-50*2, CenterViewHeight);
        }
        
        imageView.backgroundColor=[UIColor clearColor];
        imageView.tag=i+1;
        
        imageView.layer.cornerRadius = 4;
        imageView.clipsToBounds = YES;
        //添加四个边阴影
//        imageView.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
//        imageView.layer.shadowOffset = CGSizeMake(4,4);//偏移距离
//        imageView.layer.shadowOpacity = 0.8;//不透明度
//        imageView.layer.shadowRadius = 2.0;//半径
        // imageView.contentMode=UIViewContentModeScaleAspectFill;
        
        [_baseView addSubview:imageView];
    }
    
    CGFloat btnX=_baseView.frame.origin.x;
    CGFloat btnY=_baseView.frame.origin.y;
    CGFloat btnW=_baseView.frame.size.width;

    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(72+btnX, btnY+marginTop, btnW-144, TopViewHeight);
    NSLog(@"btn1:%@",NSStringFromCGRect(btn.frame));
    btn.tag=1;
    btn.backgroundColor=[UIColor clearColor];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    UIButton *btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame=CGRectMake(72+btnX, TopViewHeight+CenterViewHeight+marginTop+marginCenter*2, btnW-144, TopViewHeight);
    NSLog(@"btn2:%@",NSStringFromCGRect(btn2.frame));
    btn2.backgroundColor=[UIColor clearColor];
    btn2.tag=2;
    [btn2 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn2];
    
    UIButton *btn3=[UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame=CGRectMake(50+2, TopViewHeight+marginTop+marginCenter, _baseView.frame.size.width-4-50*2, CenterViewHeight);
    NSLog(@"btn3:%@",NSStringFromCGRect(btn3.frame));
    btn3.backgroundColor=[UIColor clearColor];
    btn3.tag=3;
    [btn3 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn3];
    
}

-(void)swipeUpDown:(UISwipeGestureRecognizer *)recognizer{
    
    if (recognizer.direction==UISwipeGestureRecognizerDirectionUp) {
        [self setAllFrame:@"SwipeUp"];
    }else if(recognizer.direction==UISwipeGestureRecognizerDirectionDown){
        [self setAllFrame:@"SwipeDown"];
    }
}

-(void)click:(UIButton *)sender{
    switch (sender.tag) {
        case 1:
            [self.delegate select:selectedIndex-1];
            break;
        case 2:
            [self.delegate select:selectedIndex+1];
            break;
        case 3:
            [self.delegate select:selectedIndex];
            break;
        default:
            break;
    }
}

-(void)setAllFrame:(NSString *)direction{
    
    if (isAnimating==YES) {
        return;
    }
    isAnimating=YES;
    
#pragma mark- 下滑
    if ([direction isEqualToString:@"SwipeDown"]) {
        
        selectedIndex--;
        if (selectedIndex<2) {
#pragma mark- 刷新数据
//            selectedIndex=_wheelArray.count+1;
            [self performSelectorOnMainThread:@selector(refreshData) withObject:self waitUntilDone:YES];
            
            selectedIndex=2;
            return;
        }
        
        [self animationScrollToTop];
    }
#pragma mark- 上滑
    else{
        
        selectedIndex++;
        if (selectedIndex>_wheelArray.count-1) {
#pragma mark- 加载数据
//            selectedIndex=0;
            [self loadData];
            return;
        }
        
        [self animationScrollToBottom];
    }
}

//最下面的视图滚动到顶端
-(void)animationScrollToTop{
    CGFloat maxH=0;
    UIImageView *maxYImageView;
    for (int i=1; i<4; i++){
        UIImageView *imageView=(UIImageView *)[_baseView viewWithTag:i];
        CGFloat max=CGRectGetMaxY(imageView.frame);
        if (max>maxH) {
            maxH=max;
            maxYImageView=imageView;
        }
    }
    if (maxH>0) {
        [_baseView sendSubviewToBack:maxYImageView];
    }
    [UIView animateWithDuration:AnimateDuration animations:^{
        CGRect rect=[[_baseView viewWithTag:1] frame];
        for (int i=1; i<4; i++){
            
            if (i==3) {
                [[_baseView viewWithTag:i] setFrame:rect];
                
                //先-1是取得最上面的一张图片，再减1取得数组序号
                NSInteger index=selectedIndex-1;
                if (index<=0) {
                    index=_wheelArray.count;
                }
                
                maxYImageView.image=_wheelArray[index-1][@"image"];
            }else{
                [[_baseView viewWithTag:i] setFrame:[[_baseView viewWithTag:i+1] frame]];
            }
        }
        
    } completion:^(BOOL finished) {
        isAnimating=NO;
        [self moveToFront];
    }];
}

//最上面的视图滚动到底端
-(void)animationScrollToBottom{
    CGFloat minH=1000;
    UIImageView *topImageView;
    
    for (int i=1; i<4; i++){
        UIImageView *imageView=(UIImageView *)[_baseView viewWithTag:i];
        CGFloat min=CGRectGetMinY(imageView.frame);
        if (min<minH) {
            minH=min;
            topImageView=imageView;
        }
    }
    if (minH<1000) {
        [_baseView sendSubviewToBack:topImageView];
    }
    
    [UIView animateWithDuration:AnimateDuration animations:^{
        CGRect rect=[[_baseView viewWithTag:3] frame];
        for (int i=1; i<4; i++){
            
            if (i==3) {
                [[_baseView viewWithTag:1] setFrame:rect];
                //先+1是取得下方的图片在数组中的tag，再-1是因为tag默认都+了1
                topImageView.image=_wheelArray[selectedIndex+1-1][@"image"];
            }else{
                [[_baseView viewWithTag:3-i+1] setFrame:[[_baseView viewWithTag:3-i] frame]];
            }
        }
        
    } completion:^(BOOL finished) {
        isAnimating=NO;
        [self moveToFront];
    }];
}

-(void)moveToFront{
    unsigned long count=_baseView.subviews.count;
    CGFloat maxW=0;
    UIImageView *maxWImageView;
    for (int i=1; i<count+1; i++){
        UIImageView *imageView=(UIImageView *)[_baseView viewWithTag:i];
        if (imageView.frame.size.width>maxW) {
            maxW=imageView.frame.size.width;
            maxWImageView=imageView;
        }
    }
    if (maxW>0) {
//        for (int j=0; j<count; j++)
            [_baseView bringSubviewToFront:maxWImageView];
    }
}

#pragma mark- 下滑刷新
-(void)refreshData{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("my.conCurrentQueue.refresh", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^(){
        //下载数据
        [self.delegate refreshData];
    });
    //等待异步下载完成才执行
    dispatch_barrier_async(concurrentQueue, ^(){
//        [_wheelArray removeAllObjects];
        [_wheelArray addObjectsFromArray:self.cacheArray];
        isAnimating=NO;
    });

}

#pragma mark- 上滑加载
-(void)loadData{
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("my.conCurrentQueue.load", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^(){
        //下载数据
        [self.delegate loadData];
    });
    //等待异步下载完成才执行
    dispatch_barrier_async(concurrentQueue, ^(){
        [_wheelArray addObjectsFromArray:self.cacheArray];
        
        [self performSelectorOnMainThread:@selector(animationScrollToBottom) withObject:self waitUntilDone:YES];
    });
}

@end
