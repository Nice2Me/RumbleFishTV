//
//  SearchViewController.m
//  GameLiveStreaming
//
//  Created by qianfeng on 15/10/5.
//  Copyright (c) 2015年 mayongxin. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchDetailViewController.h"
#import "NetDataEngine.h"
#import "GLSDBManager.h"
#import "RoomlistModel.h"
@interface SearchViewController ()
<
UISearchBarDelegate,
UITableViewDataSource,
UITableViewDelegate,
UINavigationControllerDelegate
>
@property(nonatomic)UISearchBar *searchBar;
@property(nonatomic)UISearchDisplayController *displayController;
@property(nonatomic)UITableView *tableView;
@property(nonatomic)NSMutableArray *dataSource;
@end


@implementation SearchViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.douFishTV = DouFishTVBackAndTitle;
        self.dataSource = [NSMutableArray array];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self customUI];
    [self customTableView];
    
    [self loadDataSource];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    [self.searchBar removeFromSuperview];
}


- (void)customUI {
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    containerView.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth, 44)];
    aLabel.backgroundColor = [UIColor lightGrayColor];
    aLabel.font = [UIFont systemFontOfSize:15];
    aLabel.text = @"历史搜索 ";
    aLabel.textAlignment = NSTextAlignmentLeft;
    aLabel.textColor = [UIColor grayColor];
    [containerView addSubview:aLabel];
    
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    aButton.bounds = CGRectMake(0, 0, 120, 30);
    aButton.center = CGPointMake(kScreenWidth - 60, 22);
    [aButton setTitle:@"清空历史记录" forState:UIControlStateNormal];
    [aButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [aButton addTarget:self action:@selector(buttonClickDataFromScreen:) forControlEvents:UIControlEventTouchUpInside];
    aButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [aButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [containerView addSubview:aButton];
    
    [self.view addSubview:containerView];
}


- (void)customTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - 44) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
    
    [self.view addSubview:self.tableView];
}


- (void)creatNavTitle {
    [super creatNavTitle];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(50, 0, kScreenWidth - 2 * 50, 30)];
    self.searchBar.placeholder = @"请输入搜索的内容";
    self.searchBar.showsSearchResultsButton = YES;
    self.searchBar.tintColor = [UIColor whiteColor];
    self.searchBar.delegate = self;
    
    self.navigationItem.titleView = self.searchBar;
    
    [self.searchBar becomeFirstResponder];
    [self.navigationController.navigationBar addSubview:self.searchBar];

    self.displayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
}


#pragma mark - 数据或者View的基本定制

- (void)loadDataSource {
    //    NSArray *dataArray =(NSMutableArray *)[[GLSDBManager sharedInstance]readAppInfoList:nil];
    //    for (int index =0; index <dataArray.count; index ++) {
    //        NSString *str =[self changeDataToEncoding:[dataArray objectAtIndex:index]];
    //        [self.dataSource addObject:str];
    //    }
    self.dataSource = (NSMutableArray *)[[GLSDBManager sharedInstance]readAppInfoList:nil];
    
    [self.tableView reloadData];
}


- (void)buttonClickDataFromScreen:(UIButton *)button {
    for (int index = 0; index < self.dataSource.count; index ++) {
        NSString *str = [self.dataSource objectAtIndex:index];
        
        [[GLSDBManager sharedInstance]deleteAppInfo:str type:nil];
    }
    
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
}


#pragma mark - 历史记录的数据处理的相关结果

- (NSString *)changeDataToEncoding:(NSString *)name {
    return [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


- (void)judgementDataToEquel:(SearchDetailViewController *)searchDetailVC andNSString:(NSString *)string {
    NSString *name = string;
    
    NSInteger tag = 0;
    for (int index = 0; index < self.dataSource.count; index ++) {
        
        NSString *dataStr =  [self.dataSource objectAtIndex:index];
        if ([name isEqualToString:dataStr]) {
            tag = 1;
            break;
            
        }
    }
    
    if (tag == 0) {
        NSString *str = name;
        [[GLSDBManager sharedInstance] addAppInfo:str type:nil];
        
        [self.dataSource addObject:str];
    }
    
    [self.tableView reloadData];
    //NSLog(@"%@",searchNextVC.keyword);
    [self.navigationController pushViewController:searchDetailVC animated:YES];
    
}


#pragma mark - delegate for UISearchBarDelegate

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@" "]) {
        return NO;
    }
    
    return YES;
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    //[searchBar resignFirstResponder];
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    return YES;
    
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar.text.length == 0) {
        return;
    }
    
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //
    SearchDetailViewController *searchDetailVC = [[SearchDetailViewController alloc]init];
    searchDetailVC.keyword = searchBar.text;
    
    [self judgementDataToEquel:searchDetailVC andNSString:searchBar.text];
    
    //    SportsDetailViewController *sports =[[SportsDetailViewController alloc]init];
    //    sports.id =searchBar.text;
    //    [self.navigationController pushViewController:sports animated:YES];
}


#pragma mark - delegate for UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"self.dataSource.count = %ld",self.dataSource.count);
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    NSString *name = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = name;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.searchBar.text = nil;
    
    if ([self.searchBar.text isEqualToString:@""]) {
        SearchDetailViewController *searchDetailVC =[[SearchDetailViewController alloc]init];
        searchDetailVC.keyword =[self.dataSource objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:searchDetailVC animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
