//
//  HomeViewController.m
//  缤微纷购
//
//  Created by 郑洋 on 16/1/4.
//  Copyright © 2016年 xinxincao. All rights reserved.
//
#import "PTXQViewController.h"
#import "Height.h"
#import "PTModel.h"
#import "PTTableViewCell.h"
#import "SoSoViewController.h"
#import "DWTableViewController.h"
#import "FXQViewController.h"
#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "HomeModel.h"
#import "FooterCollectionReusableView.h"
#import "HeaderCollectionReusableView.h"
#import "XCCollectionViewCell.h"
#import "XQViewController.h"
#import "Header.h"
#import "LBView.h"
#import "HomeViewController.h"
#import "BFPTDetailViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface HomeViewController ()<LBViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>

@property (nonatomic,retain)UIView *butView;
@property (nonatomic,retain)UIButton *selectButton;

@property (nonatomic,retain)HeaderCollectionReusableView *headerView;
@property (nonatomic,retain)FooterCollectionReusableView *footerView;
@property (nonatomic,retain)LBView *lbView;
@property (nonatomic,retain)UITableView *tableV;
@property (nonatomic,retain)UIScrollView *scrollV;
@property (nonatomic,retain)UIView *viewBut;
@property (nonatomic,retain)UICollectionView *collentionView;

@property (nonatomic,retain)HomeSubModel *homeSubModel;
@property (nonatomic,retain)HomeModel *homeModel;
@property (nonatomic,retain)HomeOtherModel *homeOtherModel;
@property (nonatomic,retain)UIButton *button;
@property (nonatomic,retain)UIButton *but;
@property (nonatomic,retain)NSMutableArray *dataArray;
@property (nonatomic,retain)NSMutableArray *itemsArray;
@property (nonatomic,retain)NSArray *titleArr;
@property (nonatomic,assign)NSInteger headerSection;
@property (nonatomic,retain)PTModel *pt;
@property (nonatomic,retain)NSMutableArray *ptLBView;

@property (nonatomic,retain)UIImageView *otherImageView;
@property (nonatomic,retain)UIImageView *upImageView;
@property (nonatomic,retain)UIView *upBackView;
/**拼团cell的高度*/
@property (nonatomic,assign)CGFloat cellHeight;
/**定位管理*/
@property (nonatomic, strong) CLLocationManager * manager;
/**城市*/
@property (nonatomic, strong) NSString * currentCity;
/**城市沙盒路径*/
@property (nonatomic, strong) NSString * cityPath;
@end

@implementation HomeViewController

- (NSString *)cityPath {
    if (!_cityPath) {
        _cityPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"city.plist"];
    }
    return _cityPath;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentCity:) name:@"returncurrentCity" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    [self CollectionViewgetDate];
    //[self initwithSegment];
    //[self getAddress];
}

- (void)currentCity:(NSNotification *)notification {
    
    self.currentCity = notification.userInfo[@"city"];
    [[NSUserDefaults standardUserDefaults] setObject:self.currentCity forKey:@"city"];
    //[self.tableV reloadData];
}

- (void)updateViewCtrl{
    
    [self initWithCollectionView];
    [self initWithOtherView];
    
}


- (void)initwithSegment{
    
    self.butView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BF_ScaleFont(160), 25)];
    
    self.button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, BF_ScaleFont(80), 25)];
    _button.backgroundColor = [UIColor whiteColor];
    _button.layer.cornerRadius = 12;
    _button.layer.masksToBounds = YES;
    self.button.selected = YES;
    _button.tag = 100;
    [_button setTitle:@"缤纷商城" forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont systemFontOfSize:CGFloatY(14)];
    [_button setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [_button addTarget:self action:@selector(setControll:) forControlEvents:UIControlEventTouchUpInside];
    
    self.but = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_button.frame)-15, 0, BF_ScaleFont(80), 25)];
    _but.backgroundColor = rgb(39, 64, 139, 1);
    _but.layer.cornerRadius = 12;
    _but.layer.masksToBounds = YES;
    [_but setTitle:@"缤纷拼团" forState:UIControlStateNormal];
    _but.titleLabel.font = [UIFont systemFontOfSize:CGFloatY(14)];
    _but.tag = 200;
    [_but setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [_but addTarget:self action:@selector(setControll:) forControlEvents:UIControlEventTouchUpInside];
    [self.butView addSubview:_but];
    [self.butView addSubview:_button];
    self.navigationItem.titleView = self.butView;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"iconfont-sousuo-3.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(soso)];
    
    UIBarButtonItem *location = [UIBarButtonItem itemWithTarget:self action:@selector(clickToChangeCity) image:@"4.pic_hd" highImage:@"4.pic_hd" text:self.currentCity];
    BFLog(@"dianjile %@,,,",self.currentCity);
    UIBarButtonItem *leftSpace = [UIBarButtonItem leftSpace:BF_ScaleFont(-10)];
    self.navigationItem.leftBarButtonItems = @[leftSpace,location];
    
    

}

- (void)clickToChangeCity {
    DWTableViewController *dwVC = [[DWTableViewController alloc]init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:dwVC];
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma  mark 缤纷商城初始化
- (void)initWithScrollView{
  
#warning 契合度最高的话 最好时修改 LBView   直接传model进去
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    if (_homeModel.bannerDataArray.count != 0) {
        for (HomeOtherModel * model in _homeModel.bannerDataArray) {
            [arr addObject:model.content];
        }
    }else{
        return;
    }

    self.lbView = [[LBView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/2)];
    self.lbView.isServiceLoadingImage = YES;
    self.lbView.dataArray = [arr copy];
    self.lbView.delegateLB = self;

    [self.headerView addSubview:self.lbView];
}
#pragma mark 分类列表初始化
- (void)initWithBut{
    
    self.titleArr = @[@"果实",@"地方特产",@"休闲零食",@"酒水",@"今日特价",@"新品首发",@"热销排行",@"试吃体验"];
    
    self.viewBut = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lbView.frame), kScreenWidth, (but_x)*2+20)];
    self.viewBut.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < 8; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake((i%4+1)*5+(i%4)* (but_x),(i/4+1)*5+(i/4)*(but_x), but_x, but_x);
       
        button.tag = 10 + i;
        [button addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, image_x-5, image_x-5)];
        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"iicon0%d.png",i+1]];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(image.frame), but_x, 20)];
        label.text = [NSString stringWithFormat:@"%@",self.titleArr[i]];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:CGFloatY(14)];
        
        [button addSubview:image];
        [button addSubview:label];
        [self.headerView addSubview:self.viewBut];
        [self.viewBut addSubview:button];
    }
}

#pragma  mark UICollectionView初始化
- (void)initWithCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
    
    flowLayout.itemSize = CGSizeMake(item_x, item_x);
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);

    self.collentionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:flowLayout];
    
    self.collentionView.backgroundColor = [UIColor whiteColor];
    self.collentionView.dataSource = self;
    self.collentionView.delegate = self;
    self.collentionView.showsHorizontalScrollIndicator = NO;
    self.collentionView.showsVerticalScrollIndicator = NO;
    self.collentionView.multipleTouchEnabled = YES;
    
    [self.collentionView registerClass:[XCCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.collentionView registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [self.collentionView registerClass:[FooterCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    self.collentionView.allowsMultipleSelection = YES;
    
    [self.view addSubview:self.collentionView];
    
}

#pragma  mark 首页下方广告图
- (void)initWithOtherView{

    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < self.homeModel.footDataArray.count; i++) {
        self.otherImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, ((kScreenWidth/2)*i+(i*5)), kScreenWidth, kScreenWidth/2)];
        
        for (HomeOtherModel *home in self.homeModel.footDataArray) {
            [arr addObject:home.content];
     }
    [self.otherImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",arr[i]]] placeholderImage:[UIImage imageNamed:@"750.jpg"]];
        [self.footerView addSubview:self.otherImageView];
    }
}

#pragma  mark 上方广告图
- (void)initWithUpView{
    
    NSInteger count = self.homeModel.oneDataArray.count;
    
    self.upBackView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.viewBut.frame), kScreenWidth, kScreenWidth/2*count)];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < count; i++) {
        self.upImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,((kScreenWidth/2)*i), kScreenWidth, kScreenWidth/2)];
        
        for (HomeOtherModel *home in self.homeModel.oneDataArray) {
            [arr addObject:home.content];
        }
        [self.upImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",arr[i]]] placeholderImage:[UIImage imageNamed:@"750.jpg"]];
        
        [self.headerView addSubview:self.upBackView];
        [self.upBackView addSubview:self.upImageView];
    }

}

- (void)LBViewDelegate:(LBView *)lbView didSelected:(NSInteger)index{
    NSLog(@"轮播当前点击有效");
    
    switch (index) {
        case 0:
        {
            FXQViewController *fxq = [[FXQViewController alloc]init];
            [self.navigationController pushViewController:fxq animated:YES];
        }
            break;
        case 1:{
            FXQViewController *fxq = [[FXQViewController alloc]init];
            [self.navigationController pushViewController:fxq animated:YES];
        }
            break;
        default:
            break;
    }
    
}

#pragma  mark 首页切换
- (void)setControll:(UIButton *)button{
    
    self.selectButton.selected = NO;
    button.selected = YES;
    self.selectButton = button;
    
    switch (button.tag) {
        case 100:{
            [self.tableV removeFromSuperview];
            
            [self.butView bringSubviewToFront:button];
            [self initWithCollectionView];
            self.button.backgroundColor = [UIColor whiteColor];
            self.but.backgroundColor = rgb(39, 64, 139, 1);
        }
            break;
        case 200:{
            [self.scrollV removeFromSuperview];
            
            [self.butView bringSubviewToFront:button];
            [self tableViewgetDate];
            self.button.backgroundColor = rgb(39, 64, 139, 1);
            self.button.selected = NO;
            self.but.backgroundColor = [UIColor whiteColor];
            
        }
            break;
        default:
            break;
    }

}

#pragma  mark 分类列表点击事件
- (void)selectButton:(UIButton *)button{
    switch (button.tag) {
        case 10:{
            NSLog(@"首页分类点击有效");
        }
            break;
        case 11:{
            
        }
            break;
        case 12:{
            
        }
            break;
        case 13:{
            
        }
            break;
        case 14:{
            
        }
            break;
        case 15:{
            
        }
            break;
        case 16:{
            
        }
            break;
        case 17:{
            
        }
            break;
        case 18:{
            
        }
            break;

        default:
            break;
    }

}

#pragma  mark  CollectionView 代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    HomeSubModel *model = self.homeModel.homeDataArray[section];
    return model.imageArray.count;

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.homeModel.homeDataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    XCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
     HomeSubModel *model = self.homeModel.homeDataArray[indexPath.section];
    
    [cell.imageView sd_setImageWithURL:[model.imageArray objectAtIndex:indexPath.row] placeholderImage:[UIImage imageNamed:@"100.jpg"]];


    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
 
    FXQViewController *fxq = [[FXQViewController alloc]init];
    HomeSubModel *model = self.homeModel.homeDataArray[indexPath.section];
    fxq.ID = model.idArray[indexPath.row];
    [self.navigationController pushViewController:fxq animated:YES];


}

#pragma  mark  分区头高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return CGSizeMake(kScreenWidth, kScreenWidth+(kScreenWidth/2*(self.homeModel.oneDataArray.count))+(but_x)*2+40);
    }else{
        return CGSizeMake(kScreenWidth, kScreenWidth/2);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    NSInteger index = self.homeModel.homeDataArray.count;
    NSInteger number = self.homeModel.footDataArray.count;
    if (section == index-1) {
       
        return CGSizeMake(kScreenWidth, (kScreenWidth/2)*number+120);
    }else{
        return CGSizeMake(0, 0);
    }
}

#pragma  mark 分区头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (kind == UICollectionElementKindSectionHeader) {

    self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    HomeSubModel *homeModel = self.homeModel.homeDataArray[indexPath.section];
    
    [self.headerView.sectionImage sd_setImageWithURL:[NSURL URLWithString:homeModel.upimg] placeholderImage:[UIImage imageNamed:@"750.jpg"]];
        self.headerSection = indexPath.row;
    if (indexPath.section == 0) {
        
        [self initWithScrollView];
        [self initWithBut];
        [self initWithUpView];
        self.headerView.sectionImage.frame = CGRectMake(0, CGRectGetMaxY(self.upBackView.frame), kScreenWidth, kScreenWidth/2);
    }else{
        [self.viewBut removeFromSuperview];
        [self.lbView removeFromSuperview];
        [self.upBackView removeFromSuperview];
        self.headerView.sectionImage.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth/2);
    }
        self.headerView.sectionImage.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(heardSectionTap)];
        
        [self.headerView.sectionImage addGestureRecognizer:tap];
        return self.headerView;
    }else{
        NSInteger index = self.homeModel.homeDataArray.count;
        if (indexPath.section == index-1) {
          
            self.footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
           
            [self initWithOtherView];
        }
        
        return self.footerView;
    }
    
}

#pragma  mark 分区头点击事件
- (void)heardSectionTap{
     XQViewController *xq = [[XQViewController alloc]init];
    switch (self.headerSection) {
        case 0:
        {
//            xq.ID = self.homeSubModel.upimg;
            NSLog(@"%@",self.homeSubModel.upimg);
            xq.ID = @"551";
        }
            break;
            
        default:
            break;
    }
    
   
//    xq.ID = @"551";
    [self.navigationController pushViewController:xq animated:YES];
}

#pragma  mark 缤纷拼团页面初始化
- (void)initWithTabView{
    
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    
    self.tableV.dataSource = self;
    self.tableV.delegate = self;
    self.tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableV.showsHorizontalScrollIndicator = NO;
    self.tableV.showsVerticalScrollIndicator = NO;
    self.tableV.backgroundColor = BFColor(0xD4D4D4);
    
    [self.tableV registerClass:[PTTableViewCell class] forCellReuseIdentifier:@"reuse"];
    
    [self.view addSubview:self.tableV];
   
}

#pragma  mark UITableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    PTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse" forIndexPath:indexPath];
    
    cell.model = self.dataArray[indexPath.row];
    self.cellHeight = cell.cellHeight;
    cell.backgroundColor = BFColor(0xD4D4D4);
    cell.selectionStyle = UITableViewCellAccessoryNone;
    
    return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.ptLBView == nil) {
        return 0;
    }else{
    return kScreenWidth/2;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    LBView *lb = [[LBView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, kScreenWidth/2)];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *str in self.ptLBView) {
        [arr addObject:str];
    }
    lb.isServiceLoadingImage = YES;
    lb.dataArray = [arr copy];
    return lb;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return kScreenWidth/2+[Height heightString:self.pt.intro font:13]+180;
    if (indexPath.row == self.dataArray.count-1) {
        return self.cellHeight+self.dataArray.count*20;
    }else {
        return self.cellHeight+20;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BFPTDetailViewController *ptxq = [[BFPTDetailViewController alloc]init];
    self.pt = self.dataArray[indexPath.row];
    ptxq.ID = self.pt.ID;
    [self.navigationController pushViewController:ptxq animated:NO];
}

#pragma  mark 拼团解析
- (void)tableViewgetDate{
  
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"m"] = @"Json";
//    parameters[@"a"] = @"team_buy";
//    
//    [BFHttpTool GET:BF_URL params:parameters success:^(id responseObject) {
//        NSArray *array = [BFDataTool getPTArrayWithDic:responseObject];
//        [self.dataArray addObjectsFromArray:array];
//        [self initWithTabView];
//        [self.tableV reloadData];
//        
//    } failure:^(NSError *error) {
//        
//    }];

    NSURL *url = [NSURL URLWithString:@"http://bingo.luexue.com/index.php?m=Json&a=team_buy"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
       
        if (data != nil) {
            [self.dataArray removeAllObjects];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *array = [dic valueForKey:@"ads"];
            NSArray *arr = [dic valueForKey:@"item"];
            self.ptLBView = [NSMutableArray array];
            
            if (![dic[@"ads"] isKindOfClass:[NSNull class]]) {
                for (NSDictionary *dices in array) {
                    _pt = [[PTModel alloc]init];
                    _pt.content = [dices valueForKey:@"content"];
                    [self.ptLBView addObject:_pt.content];
                }
            }else {
                self.ptLBView = nil;
            }

            for (NSDictionary *dics in arr) {
                 _pt = [[PTModel alloc]init];
                _pt.ID = [dics valueForKey:@"id"];
                _pt.img = [dics valueForKey:@"img"];
                _pt.title = [dics valueForKey:@"title"];
                _pt.intro = [dics valueForKey:@"intro"];
                _pt.team_num = [dics valueForKey:@"team_num"];
                _pt.team_price = [dics valueForKey:@"team_price"];
                _pt.team_discount = [dics valueForKey:@"team_discount"];

            [self.dataArray addObject:_pt];

            }
          
        }
            [self initWithTabView];
            [self.tableV reloadData];
        
    }];

}


#pragma  mark 获取数据
- (void)CollectionViewgetDate{
 
    NSURL *url = [NSURL URLWithString:@"http://bingo.luexue.com/index.php?m=Json&a=index"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data != nil) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            HomeModel * homeModel = [[HomeModel alloc]initWithDictionary:dic];
            self.homeModel = homeModel;

        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateViewCtrl];
            [self.collentionView reloadData];
        });
        
    }];

}

#pragma  mark 搜索按钮点击事件
- (void)soso{
 
    SoSoViewController *soso = [[SoSoViewController alloc]init];
    [self.navigationController pushViewController:soso animated:YES];
}



- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)itemsArray{
    if (!_itemsArray) {
        _itemsArray = [NSMutableArray array];
    }
    return _itemsArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [self initwithSegment];
    BFLog(@"asdadasd");
    self.navigationController.navigationBar.barTintColor = rgb(0, 0, 205, 1);
    self.tabBarController.tabBar.hidden = NO;
}

- (void)getAddress{
    self.manager = [[CLLocationManager alloc]init];
    self.manager.delegate = self;
    //用于判断当前是ios7.0还是ios8.0
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        //NSLocationAlwaysUsageDescription   允许在前后台都可以授权
        //        NSLocationWhenInUseUsageDescription   允许在前台授权
        //手动授权
        
        //        主动请求前后台授权
        [self.manager requestAlwaysAuthorization];
        
        //主动请求前台授权
        //                [self.mgr requestWhenInUseAuthorization];
    }else {
        [self.manager startUpdatingLocation];
    }
    
}
//判断授权状态
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        //开启定位
        [self.manager startUpdatingLocation];
        // 定位的精确度
        self.manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        //        //每隔一点距离定位一次 （单位：米）
        //        self.mgr.distanceFilter = 10;
    }
    
}
//获取定位的位置信息
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    NSLog(@"%@",locations);
    //获取我当前的位置
    CLLocation *location = [locations lastObject];
    
    //停止定位
    [self.manager stopUpdatingLocation];
    //地理反编码
    //创建反编码对象
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    //调用方法，使用位置反编码对象获取位置信息
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *place = [placemarks lastObject];
        BFLog(@"chengshi%@",place.locality);
        [[NSUserDefaults standardUserDefaults] setObject:place.locality forKey:@"currentCity"];
        //        for (CLPlacemark *place in placemarks) {
//        if (place == nil) {
//            return ;
//        }
        //<<<<<<< HEAD
        //            self.userCity = place.locality;
        //        self.currentCity = self.userCity;
        //
        ////            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"为你定位到%@，是否从%@切换到当前城市",self.userCity,self.currentCity] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        ////            [alert show];
        ////        }
        //=======
//        self.userCity = place.locality;
//        if ([self.currentCity isEqualToString:self.userCity]) {
//            [self loadNewData];
//        }else{
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"为你定位到%@，是否从%@切换到当前城市",self.userCity,self.currentCity] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            [alert show];
//        }
    }];
    
    
}






@end
