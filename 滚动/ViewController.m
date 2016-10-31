//
//  ViewController.m
//  滚动
//
//  Created by qianfeng on 16/9/30.
//  Copyright © 2016年 cz. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic ,weak) UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *imageArr;

@property (nonatomic) NSInteger index;

@property (nonatomic, weak) NSTimer *timer;

@end

@implementation ViewController


- (void)setupTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (NSMutableArray *)imageArr
{
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
        for (int i = 1; i < 7; i++) {
            Model *model = [[Model alloc] init];
            model.imageName = [NSString stringWithFormat:@"%d", i];
            model.title = [NSString stringWithFormat:@"第%d张", i];
            [_imageArr addObject:model];
        }
    }
    return _imageArr;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        UIPageControl *pageCtrl = [[UIPageControl alloc] init];
        pageCtrl.numberOfPages = self.imageArr.count;
        pageCtrl.frame = CGRectMake(0, 150, self.collectionView.frame.size.width, 20);
        pageCtrl.backgroundColor = [UIColor orangeColor];
        pageCtrl.pageIndicatorTintColor = [UIColor grayColor];
        pageCtrl.currentPageIndicatorTintColor = [UIColor whiteColor];
        [self.view addSubview:pageCtrl];
        _pageControl = pageCtrl;
    }
    return _pageControl;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 300) collectionViewLayout:layout];
        layout.itemSize = CGSizeMake(self.view.frame.size.width, 280);
        collectView.delegate = self;
        collectView.dataSource = self;
        collectView.bounces = NO;
        collectView.pagingEnabled = YES;
        collectView.backgroundColor = [UIColor whiteColor];
        collectView.showsHorizontalScrollIndicator = NO;
        
        [collectView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionViewCell"];
        [self.view addSubview:collectView];
        _collectionView = collectView;
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self.dataSource addObject:self.imageArr.lastObject];
    [self.dataSource addObject:self.imageArr[0]];
    [self.dataSource addObject:self.imageArr[1]];
    
    [self pageControl];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    self.index = 0;
    [self setupTimer];
}


#pragma mark - delegate/datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView    cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];

    Model *model = self.dataSource[indexPath.item];
    cell.model = model;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self invalidateTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!_timer) {
        [self setupTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float x = scrollView.contentOffset.x;
    float w = self.collectionView.frame.size.width;
    if (x >= (w*3/2)) //右翻一页
    {
        _index += 1;
        if (_index == self.imageArr.count) {
            _index = 0;
        }
        NSInteger num = _index % self.imageArr.count;
        [self.dataSource replaceObjectAtIndex:1 withObject:self.imageArr[num]];
        if (num == self.imageArr.count - 1)
        {
            [self.dataSource replaceObjectAtIndex:2 withObject:self.imageArr.firstObject];
            [self.dataSource replaceObjectAtIndex:0 withObject:self.imageArr[num-1]];
        }
        else if (num == 0)
        {
            
            [self.dataSource replaceObjectAtIndex:2 withObject:self.imageArr[num+1]];
            [self.dataSource replaceObjectAtIndex:0 withObject:self.imageArr.lastObject];
        }
        else
        {
            //原本中间的model换掉再移动到collectionView中间
            [self.dataSource replaceObjectAtIndex:2 withObject:self.imageArr[num+1]];
            [self.dataSource replaceObjectAtIndex:0 withObject:self.imageArr[num-1]];
        }
    }
    else if (x <= (w/2)) //左翻一页
    {
        if (_index % self.imageArr.count == 0) {
            _index = 5;
        }
        _index -= 1;
        NSInteger num = _index % self.imageArr.count;
        [self.dataSource replaceObjectAtIndex:1 withObject:self.imageArr[num]];
        if (num == self.imageArr.count - 1)
        {
            [self.dataSource replaceObjectAtIndex:2 withObject:self.imageArr.firstObject];
            [self.dataSource replaceObjectAtIndex:0 withObject:self.imageArr[num-1]];
        }
        else if (num == 0)
        {
            
            [self.dataSource replaceObjectAtIndex:2 withObject:self.imageArr[num+1]];
            [self.dataSource replaceObjectAtIndex:0 withObject:self.imageArr.lastObject];
        }
        else
        {
            //原本中间的model换掉再移动到collectionView中间
            [self.dataSource replaceObjectAtIndex:2 withObject:self.imageArr[num+1]];
            [self.dataSource replaceObjectAtIndex:0 withObject:self.imageArr[num-1]];
        }
        
    }
    else
    {
        
    }
//    NSLog(@"%ld", _index);
    
    self.pageControl.currentPage = _index % self.imageArr.count;
    
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)automaticScroll
{
    CGFloat offsetX = self.collectionView.contentOffset.x + CGRectGetWidth(self.collectionView.frame);
    
    [self.collectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidEndDecelerating:self.collectionView];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    Model *model = cell.model;
    NSLog(@"点击了第%@张图片", model.imageName);
}



@end
