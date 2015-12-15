//
//  CYMTableViewSection.m
//  Created by caoyangmin on 15/12/3.
//

#import <objc/runtime.h>
#import "CYMTableViewSection.h"
#import "CYMDelegateChain.h" @see https://github.com/caoym/CYMDelegateChain


/** 验证条件，若不满足，则抛出异常*/
#ifndef VERIFY
#define VERIFY(fun, msg) \
if(!(fun)) { \
NSString*reason = [NSString stringWithFormat:@"[%s:%d:%s] %@",__FILE__, __LINE__,#fun,msg];\
NSLog(@"%@",reason);\
@throw [NSException exceptionWithName:@"NSException" reason:reason userInfo:nil];\
}
#endif

/** UITableViewDelegateHook */
@interface UITableViewDelegateHook : NSObject
    @property (nonatomic, weak, nullable) id delegate;
    @property NSInteger section;

@end

@implementation UITableViewDelegateHook

+ (NSInteger) argPos:(NSArray<NSString*>*) search Of:(SEL)aSelector {
    //获取参数位置
    NSString * selName = NSStringFromSelector(aSelector);

    NSArray<NSString*>* args = [selName componentsSeparatedByString:@":"];
    
    for( int i=0; i != args.count; i++){
        for (NSString* str in search) {
            if ([args[i] rangeOfString:str].length>0) {
                return i;
            }
        }
    }
    return -1;
}

- (BOOL) needHookSelector:(SEL)aSelector
{
    if (!_delegate || ![_delegate respondsToSelector:aSelector] ){
        return NO;
    }
    
    //简单粗暴的判断是否需要hook
    NSArray *keywords =[NSArray arrayWithObjects:
                     @"AtIndexPath",
                     @"forSection",
                     @"InSection",
                     @"WithIndexPath",
                     nil];

    return [[self class] argPos:keywords Of:aSelector ]>=0;
}
- (BOOL) needHookInvocation:(NSInvocation *)anInvocation
{
    if(![self needHookSelector:[anInvocation selector]]){
        return NO;
    }
    //判断是否是关于指定section的消息
    //NSString * selName = NSStringFromSelector([anInvocation selector]);
    
    NSMethodSignature*sig = anInvocation.methodSignature;
 
    NSArray *indexArg =[NSArray arrayWithObjects:
                     @"AtIndexPath",
                     @"WithIndexPath",
                     nil];
    
    //判断NSIndexPath参数
    NSInteger pos = [[self class] argPos:indexArg Of:[anInvocation selector] ];
    if (pos>=0) {
        pos += 2;
        const char * argType = [sig getArgumentTypeAtIndex:pos];
        if(strcmp(@encode(NSIndexPath*),argType)==0){
            
            __unsafe_unretained NSIndexPath* path=nil;
            [anInvocation getArgument:&path atIndex:pos];
            if (path && path.section == _section) {
                return YES;
            }
            return NO;
        }
        
    }
    //判断section参数
    NSArray *sectionArg =[NSArray arrayWithObjects:
                        @"forSection",
                        @"InSection",
                        nil];

    pos = [[self class] argPos:sectionArg Of:[anInvocation selector] ];
    if (pos>=0) {
        pos += 2;
        const char * argType = [sig getArgumentTypeAtIndex:pos];

        if(strcmp(@encode(NSInteger),argType)==0){
            NSInteger section;
            [anInvocation getArgument:&section atIndex:pos];
            if (section == _section) {
                return YES;
            }
            return NO;
        }
        
    }

    return NO;
}
/** 判断是否应该hook*/
- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([super respondsToSelector:aSelector]){
        return YES;
    }
    if (_delegate && [_delegate respondsToSelector:aSelector]){
        return [self needHookSelector:aSelector];
    }
    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature* signature = [super methodSignatureForSelector:aSelector];
    
    if (!signature){
        if ([self needHookSelector:aSelector]){
            return [_delegate methodSignatureForSelector:aSelector];
        }
    }
    return signature;
}
/** 执行 hook*/
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([super respondsToSelector:[anInvocation selector]] ){
        [super forwardInvocation:anInvocation];
        return;
    }
    if ([self needHookInvocation:anInvocation]) {
        [anInvocation invokeWithTarget:_delegate];
    }else{
        CYMDelegateChainContinue();
    }
    
}

@end


/** CYMTableViewSection */

@implementation CYMTableViewSection
{
    NSInteger _sectionId;
    UITableViewDelegateHook* _delegateHook;
    UITableViewDelegateHook* _dataSourceHook;

}

- (id<UITableViewDelegate>) delegate
{
    return _delegateHook.delegate;
}

- (id<UITableViewDataSource>) dataSource
{
    return _dataSourceHook.delegate;
}

- (void) setDelegate:(id<UITableViewDelegate>)delegate
{
    _delegateHook.delegate = delegate;
}

- (void) setDataSource:(id<UITableViewDataSource>) dataSource
{
    _dataSourceHook.delegate = dataSource;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        _delegateHook = [[UITableViewDelegateHook alloc]init];
        _dataSourceHook = [[UITableViewDelegateHook alloc]init];
    }
    return self;
}

-(void)addTo:(nonnull UITableView*)tableView section:(NSInteger)sectionId reload:(BOOL)reload
{
    VERIFY(tableView, @"nonnull tableView with null value");
    VERIFY(!_tableView, @"the section is already in an UITableView");
    _tableView = tableView;

    _delegateHook.section = _dataSourceHook.section = sectionId;
    CYMDelegateChainInsert(_tableView.delegate, _delegateHook, self);
    CYMDelegateChainInsert(_tableView.dataSource, _dataSourceHook, self);

    _sectionId = sectionId;
    
}
-(void)removeFromTableView:(BOOL)reload
{
    if (_tableView) {
        CYMDelegateChainRemove(_tableView.delegate, _delegateHook, self);
        CYMDelegateChainRemove(_tableView.dataSource, _dataSourceHook, self);
        
        NSNumber*num = objc_getAssociatedObject(_tableView, @"__numberOfSections");
        objc_setAssociatedObject(_tableView, @"__numberOfSections", num?[NSNumber numberWithInt:num.intValue-1]:[NSNumber numberWithInt:0], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        if(reload){
            [_tableView reloadData];
        }
        _tableView = nil;
    }
}
-(BOOL)isAttached{
    return _tableView != nil;
}


@end
