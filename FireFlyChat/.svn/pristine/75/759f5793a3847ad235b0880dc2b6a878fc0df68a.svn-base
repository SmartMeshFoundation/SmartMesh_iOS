//
//  WSPageView.h
//  WSCycleScrollView
//
//  Created by iMac on 16/8/10.
//  Copyright © 2016年 sinfotek. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WSPageViewDataSource;
@protocol WSPageViewDelegate;

/******************************
 
 页面滚动的方向分为横向和纵向
 
 Version 1.0:
 目的:实现类似于选择电影票的效果,并且实现无限/自动轮播
 
 特点:1.无限轮播;2.自动轮播;3.电影票样式的层次感;4.非当前显示view具有缩放和透明的特效
 
 问题:考虑到轮播图的数量不会太大,暂时未做重用处理;对设备性能影响不明显,后期版本会考虑添加重用标识模仿tableview的重用
 
 ******************************/

typedef enum{
    NewPagedFlowViewOrientationHorizontal = 0,
    NewPagedFlowViewOrientationVertical
}NewPagedFlowViewOrientation;

@interface WSPageView : UIView<UIScrollViewDelegate>

@property (nonatomic,assign) NewPagedFlowViewOrientation orientation;//默认为横向

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic,assign) BOOL needsReload;
@property (nonatomic,assign) CGSize pageSize; //一页的尺寸
@property (nonatomic,assign) NSInteger pageCount;  //总页数

@property (nonatomic,strong) NSMutableArray *cells;
@property (nonatomic,assign) NSRange visibleRange;
@property (nonatomic,strong) NSMutableArray *reusableCells;//如果以后需要支持reuseIdentifier，这边就得使用字典类型了

@property (nonatomic,assign)   id <WSPageViewDataSource> dataSource;
@property (nonatomic,assign)   id <WSPageViewDelegate>   delegate;

/**
 *  指示器
 */
@property (nonatomic,retain)  UIPageControl *pageControl;

/**
 *  非当前页的透明比例
 */
@property (nonatomic, assign) CGFloat minimumPageAlpha;

/**
 *  非当前页的缩放比例
 */
@property (nonatomic, assign) CGFloat minimumPageScale;

/**
 *  当前是第几页
 */
@property (nonatomic, assign, readonly) NSInteger currentPageIndex;

/**
 *  定时器
 */
@property (nonatomic, weak) NSTimer *timer;

/**
 *  自动切换视图的时间,默认是5.0
 */
@property (nonatomic, assign) CGFloat autoTime;

/**
 *  原始页数
 */
@property (nonatomic, assign) NSInteger orginPageCount;


- (void)reloadData;

/**
 *  获取可重复使用的Cell
 *
 *  @return
 */
- (UIView *)dequeueReusableCell;

/**
 *  滚动到指定的页面
 *
 *  @param pageNumber
 */
- (void)scrollToPage:(NSUInteger)pageNumber;

/**
 *  开启定时器
 */
- (void)startTimer;

/**
 *  关闭定时器
 */
- (void)stopTimer;

@end


@protocol  WSPageViewDelegate<NSObject>

/**
 *  单个子控件的Size
 *
 *  @param flowView
 *
 *  @return
 */
- (CGSize)sizeForPageInFlowView:(WSPageView *)flowView;

@optional
/**
 *  滚动到了某一列
 *
 *  @param pageNumber
 *  @param flowView
 */
- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(WSPageView *)flowView;

/**
 *  点击了第几个cell
 *
 *  @param subView 点击的控件
 *  @param subIndex    点击控件的index
 *
 *  @return
 */
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex;

@end


@protocol WSPageViewDataSource <NSObject>

/**
 *  返回显示View的个数
 *
 *  @param flowView
 *
 *  @return
 */
- (NSInteger)numberOfPagesInFlowView:(WSPageView *)flowView;

/**
 *  给某一列设置属性
 *
 *  @param flowView
 *  @param index
 *
 *  @return   
 */
- (UIView *)flowView:(WSPageView *)flowView cellForPageAtIndex:(NSInteger)index;


@end
