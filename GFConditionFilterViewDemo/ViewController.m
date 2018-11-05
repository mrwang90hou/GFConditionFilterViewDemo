//
//  ViewController.m
//  GFConditionFilterViewDemo
//
//  Created by 王宁 on 2018/11/5.
//  Copyright © 2018年 王宁. All rights reserved.
//

#import "ViewController.h"
#import "GFConditionFilterView.h"
#import "UIView+Extension.h"

@interface ViewController ()
{
    // *存储* 网络请求url中的筛选项 数据来源：View中_dataSource1或者一开始手动的初值
    NSArray *_selectedDataSource1Ary;
    NSArray *_selectedDataSource2Ary;
    NSArray *_selectedDataSource3Ary;
    
    GFConditionFilterView *_conditionFilterView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"ListView";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // FilterBlock 选择下拉菜单选项触发
    _conditionFilterView = [GFConditionFilterView conditionFilterViewWithFilterBlock:^(BOOL isFilter, NSArray *dataSource1Ary, NSArray *dataSource2Ary, NSArray *dataSource3Ary) {
        
        // 1.isFilter = YES 代表是用户下拉选择了某一项
        // 2.dataSource1Ary 选择后第一组选择的数据  2 3一次类推
        // 3.如果你的项目没有清空筛选条件的功能，可以无视else 我们的app有清空之前的条件，重置，所以才有else的逻辑
        
        if (isFilter) {
            //网络加载请求 存储请求参数
            _selectedDataSource1Ary = dataSource1Ary;
            _selectedDataSource2Ary = dataSource2Ary;
            _selectedDataSource3Ary = dataSource3Ary;
            //
            //            NSLog(@"%@",dataSource1Ary);
            //            NSLog(@"%@",dataSource2Ary);
            //            NSLog(@"%@",dataSource3Ary);
        }else{
            // 不是筛选，全部赋初值（在这个工程其实是没用的，因为tableView是选中后必选的，即一旦选中就没有空的情况，但是如果可以清空筛选条件的时候就有必要 *重新* reset data）
            _selectedDataSource1Ary = @[@"综合排序"];
            _selectedDataSource2Ary = @[];
            _selectedDataSource3Ary = @[];
            NSLog(@"综合排序!");
            //记录当前请求的type 数值
        }
        //判断当前的状态选择，并进行网络请求
        [self startRequest];
    }];
    
    
    _conditionFilterView.y += 64;
    
    // 设置初次加载显示的默认数据 即初次加载还没有选择操作之前要显示的标题数据
    //    _selectedDataSource1Ary = @[@"综合排序"];
    //    _selectedDataSource1Ary = @[@"优惠券"];
    //    _selectedDataSource2Ary = @[@"券后价"];
    //    _selectedDataSource3Ary = @[@"销量"];
    
    // 传入数据源，对应三个tableView顺序
    //    _conditionFilterView.dataAry1 = @[@"1-1",@"1-2",@"1-3",@"1-4",@"1-5"];
    //    _conditionFilterView.dataAry2 = @[@"2-1",@"2-2",@"2-3",@"2-4",@"2-5"];
    //    _conditionFilterView.dataAry3 = @[@"3-1",@"3-2",@"3-3",@"3-4",@"3-5"];
    _conditionFilterView.dataAry1 = @[@"综合排序",@"优惠券从高到低",@"优惠券从低到高"];
    _conditionFilterView.dataAry2 = @[@"券后价由高到低",@"券后价由低到高"];
    _conditionFilterView.dataAry3 = @[@"销量由高到低",@"销量由低到高"];
    
    // 初次设置默认显示数据(标题)，内部会调用block 进行第一次数据加载
    [_conditionFilterView bindChoseArrayDataSource1:_selectedDataSource1Ary DataSource2:_selectedDataSource2Ary DataSource3:_selectedDataSource3Ary];
    /** 外部手动筛选加载*/
    [_conditionFilterView choseSortFromOutsideWithFirstSort:_selectedDataSource1Ary WithSecondSort:_selectedDataSource2Ary WithThirdSort:_selectedDataSource3Ary];
    [self.view addSubview:_conditionFilterView];
    
}

- (void)startRequest
{
    NSString *source1 = [NSString stringWithFormat:@"%@",_selectedDataSource1Ary.firstObject];
    NSString *source2 = [NSString stringWithFormat:@"%@",_selectedDataSource2Ary.firstObject];
    NSString *source3 = [NSString stringWithFormat:@"%@",_selectedDataSource3Ary.firstObject];
    NSArray *strArr = @[source1,source2,source3];
    NSString *typeStr = @"";
    for (NSString *str in strArr) {
        if (str) {
            typeStr = str;
            break;
        }
    }
    NSLog(@"typeStr = %@",typeStr);
    int flagNumer = 0;
    NSArray *typeStrArr = @[@"综合排序",@"优惠券从高到低",@"优惠券从低到高",@"券后价由高到低",@"券后价由低到高",@"销量由高到低",@"销量由低到高"];
    for (int i = 0; i<typeStrArr.count; i++) {
        if ([typeStr isEqualToString:[typeStrArr objectAtIndex:i]]) {
            flagNumer = i;
            break;
        }
    }
    NSLog(@"当前查询方法为：%@,第%d种查询方法！！！",[typeStrArr objectAtIndex:flagNumer],flagNumer);
    //flag=0综合查询,1优惠券面值高到低，2优惠券面值低到高，3券后价由高到低，4、券后价由低到高，5，销量由高到低，6，销量由低到高
    
    
    NSDictionary *dic = [_conditionFilterView keyValueDic];
    // 可以用字符串在dic换成对应英文key
    
    NSLog(@"\n第一个条件:%@\n  第二个条件:%@\n  第三个条件:%@\n",source1,source2,source3);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
