//
//  ViewController.m
//  TableViewDemo
//
//  Created by caoyangmin on 15/12/15.
//

#import "ViewController.h"
#import "UITableView+CYMSectionAdditions.h"

#import "MySection1.h"
#import "MySection2.h"
#import "MySectionHeader.h"
#import "UITableView+CYMSectionAdditions.h"

@interface ViewController ()

@end

@implementation ViewController

MySectionHeader* _header;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    MySection1* sec1 = [[MySection1 alloc]init];
    MySection2* sec2 = [[MySection2 alloc]init];
    
    [_tabView addSection:sec1 reload:NO];
    [_tabView addSection:sec2 reload:NO];
    
    if(!_header){
        _header = [[MySectionHeader alloc]init];
    }
    //添加section header
    //这里不使用tabView addSection方法, 因为MySectionHeader不作为独立的section，不单独分配section id，而是绑定到section 0 上
    //当然也可以在MySection1和MySection2直接实现section Header
    [_header addTo:_tabView section:0 reload:NO];
    //[_tabView removeAllSections];
    
    //[_tabView addSection:sec2 reload:NO];
    //[_tabView addSection:sec1 reload:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
