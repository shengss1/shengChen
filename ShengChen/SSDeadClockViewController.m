//
//  SSDeadClockViewController.m
//  SSGodPanUnion
//
//  Created by 金鼎玉铉 on 2019/12/16.
//  Copyright © 2019 金鼎玉铉. All rights reserved.
//
#define YLSRect(x, y, w, h)  CGRectMake([UIScreen mainScreen].bounds.size.width * x, [UIScreen mainScreen].bounds.size.height * y, [UIScreen mainScreen].bounds.size.width * w,  [UIScreen mainScreen].bounds.size.height * h)

/*
 *  RGB颜色
 */
#define GETColor(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]
//判断是iPhoneX 的宏
#define is_iPhoneX [UIScreen mainScreen].bounds.size.width == 375.0f && [UIScreen mainScreen].bounds.size.height == 812.0f

#define ScreenWidth   [UIScreen mainScreen].bounds.size.width
#define ScreenHeight  [UIScreen mainScreen].bounds.size.height

#import "SSDeadClockViewController.h"
#import "DDClock.h"
#import "BRStringPickerView.h"
#import "YTUserInfoManager.h"

@interface SSDeadClockViewController ()
@property (nonatomic)UIButton *backBtn;
@property (nonatomic,strong) DDClock *clock;

@property (nonatomic,strong) UILabel *nobirthLb;
/** 消息标签 */
@property (nonatomic,strong) UILabel *noticeLb;
/** 消息标签1 */
@property (nonatomic,strong) UILabel *noticeLb1;
/** view */
@property (nonatomic,strong) UIView *bgView;
/** year */
@property (nonatomic,strong) UILabel *year;//吃多少顿饭
/** mouth */
@property (nonatomic,strong) UILabel *mouth;//做多少次爱
/** week */
@property (nonatomic,strong) UILabel *week;//度过多少次周末
/** day */
@property (nonatomic,strong) UILabel *day;//享受多少个长假

@property (nonatomic)UIButton* xuanBtn;

@property (nonatomic)UIButton* deadBtn;

@end

@implementation SSDeadClockViewController
@synthesize backBtn;

-(UILabel *)nobirthLb
{
    if (!_nobirthLb)
    {
        _nobirthLb = [[UILabel alloc]init];
        [self.view addSubview:_nobirthLb];
    }
    return _nobirthLb;
}

-(UILabel *)noticeLb
{
    if (!_noticeLb)
    {
        _noticeLb = [[UILabel alloc]init];
        [self.view addSubview:_noticeLb];
    }
    return _noticeLb;
}

-(UILabel *)noticeLb1
{
    if (!_noticeLb1)
    {
        _noticeLb1 = [[UILabel alloc]init];
        [self.view addSubview:_noticeLb1];
    }
    return _noticeLb1;
}

-(UIView *)bgView
{
    if (!_bgView)
    {
        _bgView = [[UIView alloc]init];
        [self.view addSubview:_bgView];
    }
    return _bgView;
}

-(UILabel *)year
{
    if (!_year)
    {
        _year = [[UILabel alloc]init];
        [self.view addSubview:_year];
    }
    return _year;
}
-(UILabel *)mouth
{
    if (!_mouth)
    {
        _mouth = [[UILabel alloc]init];
        [self.view addSubview:_mouth];
    }
    return _mouth;
}
-(UILabel *)week
{
    if (!_week)
    {
        _week = [[UILabel alloc]init];
        [self.view addSubview:_week];
    }
    return _week;
}
-(UILabel *)day
{
    if (!_day)
    {
        _day = [[UILabel alloc]init];
        [self.view addSubview:_day];
    }
    return _day;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.birthdayStr = @"7.00149340";
    [self initHeadView];
    [self initView];
    NSUserDefaults *dataUser = [NSUserDefaults standardUserDefaults];
    if (![YTUserInfoManager dx_isNullOrNilWithObject:[dataUser objectForKey:@"DeadDay"]]) {
        //已设置寿命预测
        NSInteger deadYear = [[dataUser objectForKey:@"DeadDay"] integerValue];
        double hourAndMinute = [self.birthdayStr doubleValue]/(double)deadYear;
        NSInteger hour = hourAndMinute* 24;
        NSInteger minute = hourAndMinute* 24*60-60*hour;
        NSString* birthStr = [NSString stringWithFormat:@"%ld:%ld:00",hour,minute];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm:ss"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
        NSDate *toDate = [formatter dateFromString:birthStr];
        self.clock.currentTime = toDate;
        [self.clock setNeedsDisplay];
        
        self.noticeLb.text = [NSString stringWithFormat:@"这是你一生中的%ld点%ld分",hour,minute];
        
        self.year.text = [NSString stringWithFormat:@"吃%ld顿饭",(long)((deadYear-[self.birthdayStr doubleValue])*365*3)];
        self.week.text = [NSString stringWithFormat:@"度过%ld次周末",(long)((deadYear-[self.birthdayStr doubleValue])*365/7)];
        self.day.text = [NSString stringWithFormat:@"享受%ld个长假",(long)((deadYear-[self.birthdayStr doubleValue])*365/182.5)];
        
    }
    // Do any additional setup after loading the view.
}

-(void)initHeadView{
    if (is_iPhoneX) {
        backBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 44, 24, 24)];
        
    }else{
        backBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 24, 24)];
        
    }
    [backBtn setImage:[UIImage imageNamed:@"back_w"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UILabel* titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(backBtn.frame), ScreenWidth, 24)];
    titleLab.text = @"嗨，未来";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:18];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLab];
    
    _deadBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-110, CGRectGetMinY(backBtn.frame), 100, 24)];
    _deadBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_deadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_deadBtn setTitle:@"设置寿命预测" forState:UIControlStateNormal];
    _deadBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.view addSubview:_deadBtn];
    [_deadBtn addTarget:self action:@selector(deadClick:) forControlEvents:UIControlEventTouchUpInside];
    NSUserDefaults *dataUser = [NSUserDefaults standardUserDefaults];
    if ([YTUserInfoManager dx_isNullOrNilWithObject:[dataUser objectForKey:@"DeadDay"]]) {
        //未设置出生日期
        _deadBtn.hidden = YES;
        
    }else
    {
        _deadBtn.hidden = NO;
        
    }
}

-(void)initView{
    self.clock = [[DDClock alloc]initWithTheme:DDClockThemeDark position:CGPointMake((ScreenWidth - 200 )/2, 100)];
    [self.view addSubview:self.clock];
    
    if (is_iPhoneX) {
        [self.nobirthLb setFrame:CGRectMake((ScreenWidth-300)/2, 420, 300, 30)];
        [self.noticeLb setFrame:CGRectMake((ScreenWidth-300)/2, 340, 300, 30)];
        
    }else
    {
        [self.nobirthLb setFrame:CGRectMake((ScreenWidth-300)/2, 400, 300, 30)];
        [self.noticeLb setFrame:CGRectMake((ScreenWidth-300)/2, 320, 300, 30)];
    }
    self.nobirthLb.textColor = [UIColor whiteColor];
    self.nobirthLb.font = [UIFont systemFontOfSize:20];
    self.nobirthLb.textAlignment = NSTextAlignmentCenter;
    self.nobirthLb.text = @"您猜测自己能活多少岁";
    
    self.noticeLb.font = [UIFont systemFontOfSize:20];
    self.noticeLb.textColor = [UIColor whiteColor];
    self.noticeLb.textAlignment = NSTextAlignmentCenter;
    
    [self.noticeLb1 setFrame:YLSRect(28/375, (CGRectGetMaxY(self.noticeLb.frame)+10)/667, 318/375, 20/667)];
    [self.noticeLb1 setText:@"剩下的日子里，你大约可以"];
    self.noticeLb1.textColor = GETColor(123, 123, 123);
    [self.noticeLb1 setTextAlignment:NSTextAlignmentLeft];
    [self.noticeLb1 setFont:[UIFont systemFontOfSize:11]];
    
    [self.bgView setFrame:YLSRect(28/375, (CGRectGetMaxY(self.noticeLb1.frame)+10)/667, 318/375, 92/667)];
    self.bgView.layer.borderColor = GETColor(123, 123, 123).CGColor;
    self.bgView.layer.borderWidth = 1;
    
    [self.year setFrame:YLSRect(0, 0, 158/375, 46/667)];
    [self.year setFont:[UIFont systemFontOfSize:15]];
    self.year.textColor = GETColor(123, 123, 123);
    [self.year setTextAlignment:NSTextAlignmentCenter];
    [self.bgView addSubview:self.year];
    
    [self.mouth setFrame:YLSRect(159/375, 0, 158/375, 46/667)];
    [self.mouth setFont:[UIFont systemFontOfSize:15]];
    self.mouth.textColor = GETColor(123, 123, 123);
    [self.mouth setTextAlignment:NSTextAlignmentCenter];
    [self.bgView addSubview:self.mouth];
    
    [self.week setFrame:YLSRect(0, 46/667, 158/375, 46/667)];
    [self.week setFont:[UIFont systemFontOfSize:15]];
    self.week.textColor = GETColor(123, 123, 123);
    [self.week setTextAlignment:NSTextAlignmentCenter];
    [self.bgView addSubview:self.week];
    
    [self.day setFrame:YLSRect(159/375, 46/667, 158/375, 46/667)];
    [self.day setFont:[UIFont systemFontOfSize:15]];
    self.day.textColor = GETColor(123, 123, 123);
    [self.day setTextAlignment:NSTextAlignmentCenter];
    [self.bgView addSubview:self.day];
    
    UIView* hline = [[UIView alloc]initWithFrame:YLSRect(0, 46/667, 318/375, 1/667)];
    hline.backgroundColor = GETColor(102, 102, 102);
    [self.bgView addSubview:hline];
       
    UIView* vline = [[UIView alloc]initWithFrame:YLSRect(158/375, 0, 1/375, 92/667)];
    vline.backgroundColor = GETColor(102, 102, 102);
    [self.bgView addSubview:vline];
    
    _xuanBtn = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth-170)/2, ScreenHeight-100, 170, 50)];
    [_xuanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _xuanBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    _xuanBtn.layer.masksToBounds = YES;
    _xuanBtn.layer.cornerRadius = 25;
    _xuanBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _xuanBtn.layer.borderWidth = 1;
    [self.view addSubview:_xuanBtn];
    [_xuanBtn addTarget:self action:@selector(xuanClick:) forControlEvents:UIControlEventTouchUpInside];
    NSUserDefaults *dataUser = [NSUserDefaults standardUserDefaults];
    if ([YTUserInfoManager dx_isNullOrNilWithObject:[dataUser objectForKey:@"DeadDay"]]) {
        //未设置出生日期
        self.nobirthLb.hidden = NO;
        self.noticeLb.hidden = YES;
        self.noticeLb1.hidden = YES;
        self.bgView.hidden = YES;
        [_xuanBtn setTitle:@"选择年龄" forState:UIControlStateNormal];
    }else
    {
        self.nobirthLb.hidden = YES;
        self.noticeLb.hidden = NO;
        self.noticeLb1.hidden = NO;
        self.bgView.hidden = NO;
        [_xuanBtn setTitle:@"生之时" forState:UIControlStateNormal];
    }
    
}

-(void)xuanClick:(UIButton *)sender{
    NSUserDefaults *dataUser = [NSUserDefaults standardUserDefaults];
    if ([YTUserInfoManager dx_isNullOrNilWithObject:[dataUser objectForKey:@"DeadDay"]]) {
        int birthYear = [self.birthdayStr intValue];
        NSMutableArray* ageArray = [[NSMutableArray alloc]init];
        for (int i = birthYear; i<120; i++) {
            [ageArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
        [BRStringPickerView showStringPickerWithTitle:@"选择死亡年龄" dataSource:ageArray defaultSelValue:[NSString stringWithFormat:@"%d",birthYear] resultBlock:^(id selectValue) {
            NSLog(@"%@",selectValue);
            NSInteger deadYear = [selectValue integerValue];
            double hourAndMinute = [self.birthdayStr doubleValue]/(double)deadYear;
            NSInteger hour = hourAndMinute* 24;
            NSInteger minute = hourAndMinute* 24*60-60*hour;
            NSString* birthStr = [NSString stringWithFormat:@"%ld:%ld:00",hour,minute];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm:ss"];
            [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
            NSDate *toDate = [formatter dateFromString:birthStr];
            self.clock.currentTime = toDate;
            
            self.noticeLb.text = [NSString stringWithFormat:@"这是你一生中的%ld点%ld分",hour,minute];
            
            self.year.text = [NSString stringWithFormat:@"吃%ld顿饭",(long)((deadYear-[self.birthdayStr doubleValue])*365*3)];
            self.week.text = [NSString stringWithFormat:@"度过%ld次周末",(long)((deadYear-[self.birthdayStr doubleValue])*365/7)];
            self.day.text = [NSString stringWithFormat:@"享受%ld个长假",(long)((deadYear-[self.birthdayStr doubleValue])*365/182.5)];
            
            [dataUser removeObjectForKey:@"DeadDay"];
            [dataUser setObject:[NSString stringWithFormat:@"%@",selectValue] forKey:@"DeadDay"];
            [dataUser synchronize];
            [self.clock setNeedsDisplay];
            
            self.nobirthLb.hidden = YES;
            self.noticeLb.hidden = NO;
            self.noticeLb1.hidden = NO;
            self.bgView.hidden = NO;
            self.deadBtn.hidden = NO;
            [self.xuanBtn setTitle:@"生之时" forState:UIControlStateNormal];
        }];
    }else
    {
        [UIView  beginAnimations:nil context:NULL];

        [UIView setAnimationCurve:UIViewAnimationCurveLinear];

        [UIView setAnimationDuration:0.75];

        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];

        [UIView commitAnimations];
        
        //这句需要放在翻转动画后面，否则没有效果
        [self.navigationController popViewControllerAnimated:NO];
    }
    
}

-(void)deadClick:(UIButton *)sender{
    NSUserDefaults *dataUser = [NSUserDefaults standardUserDefaults];
    int birthYear = [self.birthdayStr intValue];
    NSMutableArray* ageArray = [[NSMutableArray alloc]init];
    for (int i = birthYear; i<120; i++) {
        [ageArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    [BRStringPickerView showStringPickerWithTitle:@"选择死亡年龄" dataSource:ageArray defaultSelValue:[NSString stringWithFormat:@"%d",birthYear] resultBlock:^(id selectValue) {
        NSLog(@"%@",selectValue);
        NSInteger deadYear = [[dataUser objectForKey:@"DeadDay"] integerValue];
        double hourAndMinute = [self.birthdayStr doubleValue]/(double)deadYear;
        NSInteger hour = hourAndMinute* 24;
        NSInteger minute = hourAndMinute* 24*60-60*hour;
        NSString* birthStr = [NSString stringWithFormat:@"%ld:%ld:00",hour,minute];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm:ss"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
        NSDate *toDate = [formatter dateFromString:birthStr];
        self.clock.currentTime = toDate;
        
        self.noticeLb.text = [NSString stringWithFormat:@"这是你一生中的%ld点%ld分",hour,minute];
        
        self.year.text = [NSString stringWithFormat:@"吃%ld顿饭",(long)((deadYear-[self.birthdayStr doubleValue])*365*3)];
        self.week.text = [NSString stringWithFormat:@"度过%ld次周末",(long)((deadYear-[self.birthdayStr doubleValue])*365/7)];
        self.day.text = [NSString stringWithFormat:@"享受%ld个长假",(long)((deadYear-[self.birthdayStr doubleValue])*365/182.5)];
        [dataUser removeObjectForKey:@"DeadDay"];
        [dataUser setObject:[NSString stringWithFormat:@"%@",selectValue] forKey:@"DeadDay"];
        [dataUser synchronize];
        [self.clock setNeedsDisplay];
    }];
}

-(void)back:(UIButton *)sender{
    [UIView  beginAnimations:nil context:NULL];

    [UIView setAnimationCurve:UIViewAnimationCurveLinear];

    [UIView setAnimationDuration:0.75];

    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];

    [UIView commitAnimations];
    
    //这句需要放在翻转动画后面，否则没有效果
    [self.navigationController popViewControllerAnimated:NO];
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
