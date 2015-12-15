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

#import "UITableView+CYMSectionAdditions.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    MySection1* sec1 = [[MySection1 alloc]init];
    MySection2* sec2 = [[MySection2 alloc]init];
    
    [_tabView addSection:sec1 reload:NO];
    [_tabView addSection:sec2 reload:NO];
    
    //[_tabView removeAllSections];
    
    //[_tabView addSection:sec2 reload:NO];
    //[_tabView addSection:sec1 reload:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
