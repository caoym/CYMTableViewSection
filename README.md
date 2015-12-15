# CYMTableViewSection
Dispatch delegate to standalone section for UITableView.封装UITableView 的 section, 使section有独立的delegate和dataSource。

## WHY
IOS的UITableView组件，在复杂的场景下，经常会使用多个Section，每个Section都可能有不同的header/cell/footer。如果想对Section的逻辑进行封装，因为delegate和dataSource只能指向单独的实例上，并不是很方便，需要编写一些额外的代码，来分派UITableView的事件。

## WHAT
CYMTableViewSection扩展了UITableView，提供将SectionID对应的事件独立处理的能力。使用此扩展，将很容易对业务层的Section逻辑进行封装。

## HOW
以下例子介绍如何使用CYMTableViewSection

1. 实现两个Section（MySection1和MySection2）
    ```OBJC
    /** 测试section1*/
    @interface MySection1 : CYMTableViewSection<UITableViewDataSource> //只需继承自CYMTableViewSection
    @end

    @implementation MySection1
  
    -(instancetype)init
    {
        self = [super init];
        if (self) {
            self.dataSource = self;
        }
        return self;
    }
    //处理UITableViewDataSource事件
    //只会收到本Section实例对应的SectionId的事件
    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        static NSString *cellId = @"cellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: cellId];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"MySection1 | row %ld",(long)indexPath.row];
        return cell;
    }
    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return 3;
    }
    @end
    
    // 类似方式实现MySection2
    ...
    
    ```
2. 加入UITableView
  ```OBJ
  #import "UITableView+CYMSectionAdditions.h"

  @implementation ViewController
  
  - (void)viewDidLoad {
      [super viewDidLoad];
      //创建两个Section加入tableview
      MySection1* sec1 = [[MySection1 alloc]init];
      MySection2* sec2 = [[MySection2 alloc]init];
      
      [_tabView addSection:sec1 reload:NO];
      [_tabView addSection:sec2 reload:NO];
  }
  ```
3. 运行，查看结果
    
    ![](https://github.com/caoym/CYMTableViewSection/blob/master/doc/demo.png)

## 依赖
本扩展依赖[CYMDelegateChain](https://github.com/caoym/CYMDelegateChain) 

