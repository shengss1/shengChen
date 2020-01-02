//
//  SSLiveClockViewController.m
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

#import "SSLiveClockViewController.h"
#import "DDClock.h"
#import "BRDatePickerView.h"
#import "NumberTransformationView.h"
#import "TextTransformationLayer.h"
#import "SSDeadClockViewController.h"
#import "YTUserInfoManager.h"

@interface SSLiveClockViewController ()
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
@property (nonatomic,strong) NumberTransformationView *year;
/** mouth */
@property (nonatomic,strong) NumberTransformationView *mouth;
/** week */
@property (nonatomic,strong) NumberTransformationView *week;
/** day */
@property (nonatomic,strong) NumberTransformationView *day;
/** hour */
@property (nonatomic,strong) NumberTransformationView *hour;
/** minute */
@property (nonatomic,strong) NumberTransformationView *minute;

@property (nonatomic)NSString* birthdayStr;

@property (nonatomic , strong) NSTimer *addTimer;

@property (nonatomic)UIButton* xuanBtn;

@property (nonatomic)UIButton* saveBtn;

@end

@implementation SSLiveClockViewController
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

#pragma mark - tools
- (NumberTransformationView *)transformationViewWithFrame:(CGRect)frame {
    NumberTransformationView *view = [[NumberTransformationView alloc] initWithFrame:frame font:[UIFont systemFontOfSize:15]];
    
    return view;
}

#pragma mark - getter
//控制递增的timer
- (NSTimer *)addTimer {
    if (_addTimer) {
        return _addTimer;
    }
    _addTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSDate* fromDate = [NSDate new];
        // 设置系统时区为本地时区
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        // 计算本地时区与 GMT 时区的时间差
        NSInteger interval = [timeZone secondsFromGMT];
        // 在 GMT 时间基础上追加时间差值，得到本地时间
        fromDate = [fromDate dateByAddingTimeInterval:interval];
        
        NSDateFormatter *currentformatter = [[NSDateFormatter alloc] init];
        [currentformatter setDateFormat:@"yyyy"];
        NSInteger currentYear = [[currentformatter stringFromDate:fromDate] integerValue];
        [currentformatter setDateFormat:@"MM"];
        NSInteger currentMonth = [[currentformatter stringFromDate:fromDate] integerValue];
        [currentformatter setDateFormat:@"ss"];
        NSInteger secondf = [[currentformatter stringFromDate:fromDate] integerValue];
        
        NSUserDefaults *dataUser = [NSUserDefaults standardUserDefaults];
        NSString* birthStr = [NSString stringWithFormat:@"%@ 00:00:00",[dataUser objectForKey:@"birthDay"]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
        NSDate *toDate = [formatter dateFromString:birthStr];
        NSString *strDate = [formatter stringFromDate:toDate];
        NSInteger birthYear=[[strDate substringToIndex:4] integerValue];
        NSInteger birthMonth=[[strDate substringWithRange:NSMakeRange(5, 2)] integerValue];
        
        // 创建一个标准国际时间的日历
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        calendar.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        // 获取两个日期的间隔
        NSDateComponents *comp = [calendar components:NSCalendarUnitDay|NSCalendarUnitHour|kCFCalendarUnitMinute fromDate:fromDate toDate:toDate options:NSCalendarWrapComponents];
        NSInteger hour = (comp.hour - comp.day * 24);
        NSInteger minute = (comp.minute -hour*60);
        
        
        
        if (birthYear%400 == 0||(birthYear%100 != 0&&birthYear%4 == 0)) {
            //闰年
            self.year.numberValue = [NSNumber numberWithInteger:(-comp.day)/366];
        }else
        {
            //平年
            self.year.numberValue = [NSNumber numberWithInteger:(-comp.day)/365];
        }
        
        self.birthdayStr = [NSString stringWithFormat:@"%.8f",(double)((-minute)*60+secondf)/(double)(60*60*24*365)];
        self.noticeLb.text = [NSString stringWithFormat:@"你%@岁了",self.birthdayStr];
        
        self.mouth.numberValue = [NSNumber numberWithInteger:((currentYear-birthYear)*12+(currentMonth-birthMonth))];
        
        self.day.numberValue = [NSNumber numberWithInteger:(-comp.day)];
        
        self.hour.numberValue = [NSNumber numberWithInteger:hour];
        self.minute.numberValue = [NSNumber numberWithInteger:-minute];
        self.week.numberValue = [NSNumber numberWithInteger:(-comp.day/7)];
    }];
    return _addTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    img.image = [UIImage imageNamed:@"szz_bg"];
    img.contentMode = UIViewContentModeScaleAspectFill;
    img.clipsToBounds = YES;
    [self.view addSubview:img];
    [self initHeadView];
    [self initView];
    
    NSUserDefaults *dataUser = [NSUserDefaults standardUserDefaults];
    if (![YTUserInfoManager dx_isNullOrNilWithObject:[dataUser objectForKey:@"birthDay"]]) {
        //已设置出生日期
        [self.addTimer fire];
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
    
    _saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-110, CGRectGetMinY(backBtn.frame), 100, 24)];
    _saveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_saveBtn setTitle:@"选择出生日期" forState:UIControlStateNormal];
    _saveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.view addSubview:_saveBtn];
    [_saveBtn addTarget:self action:@selector(birthClick:) forControlEvents:UIControlEventTouchUpInside];
    NSUserDefaults *dataUser = [NSUserDefaults standardUserDefaults];
    if ([YTUserInfoManager dx_isNullOrNilWithObject:[dataUser objectForKey:@"birthDay"]]) {
        //未设置出生日期
        _saveBtn.hidden = YES;
    }else
    {
        _saveBtn.hidden = NO;
    }
}

-(void)initView{
    
    self.clock = [[DDClock alloc]initWithTheme:DDClockThemeDefault position:CGPointMake((ScreenWidth - 200 )/2, 100)];
    [self.view addSubview:self.clock];
    
    if (is_iPhoneX) {
        [self.nobirthLb setFrame:CGRectMake((ScreenWidth-300)/2, 340, 300, 30)];
        [self.noticeLb setFrame:CGRectMake((ScreenWidth-300)/2, 340, 300, 30)];
        
    }else
    {
        [self.nobirthLb setFrame:CGRectMake((ScreenWidth-300)/2, 320, 300, 30)];
        [self.noticeLb setFrame:CGRectMake((ScreenWidth-300)/2, 320, 300, 30)];
    }
    self.nobirthLb.textColor = [UIColor whiteColor];
    self.nobirthLb.font = [UIFont systemFontOfSize:20];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:paragraphStyle,NSParagraphStyleAttributeName,[UIFont systemFontOfSize:20],NSFontAttributeName, nil];
    
    NSMutableAttributedString* avgStr = [[NSMutableAttributedString alloc]initWithString:@"你出生于" attributes:dict];
    NSRange range1 = [[avgStr string] rangeOfString:@"你"];
    [avgStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:30]range:range1];
    self.nobirthLb.attributedText = avgStr;
    
    self.noticeLb.font = [UIFont systemFontOfSize:20];
    self.noticeLb.textColor = [UIColor whiteColor];
    self.noticeLb.textAlignment = NSTextAlignmentCenter;
    
    [self.noticeLb1 setFrame:YLSRect(28/375, (CGRectGetMaxY(self.noticeLb.frame)+10)/667, 318/375, 20/667)];
    [self.noticeLb1 setText:@"在这个世界上，你已经存在"];
    self.noticeLb1.textColor = [UIColor whiteColor];
    [self.noticeLb1 setTextAlignment:NSTextAlignmentLeft];
    [self.noticeLb1 setFont:[UIFont systemFontOfSize:11]];
    
    [self.bgView setFrame:YLSRect(28/375, (CGRectGetMaxY(self.noticeLb1.frame)+10)/667, 318/375, 92/667)];
    self.bgView.backgroundColor = GETColor(235, 239, 240);
   
    
    self.year = [self transformationViewWithFrame:YLSRect(0, 3/667, 106/375, 20/667)];
    self.year.alignment = NSTextAlignmentCenter;
    self.year.textColor = GETColor(102, 102, 102);
    self.year.textMargin = 1;
    [self.bgView addSubview:self.year];
    UILabel *yeartintLab = [[UILabel alloc]initWithFrame:YLSRect(0, 23/667, 106/375, 20/667)];
    yeartintLab.textAlignment = NSTextAlignmentCenter;
    yeartintLab.font = [UIFont systemFontOfSize:15];
    yeartintLab.textColor = GETColor(102, 102, 102);
    yeartintLab.text = @"年";
    [self.bgView addSubview:yeartintLab];
    
    self.mouth = [self transformationViewWithFrame:YLSRect(106/375, 3/667, 106/375, 20/667)];
    self.mouth.alignment = NSTextAlignmentCenter;
    self.mouth.textMargin = 1;
    self.mouth.textColor = GETColor(102, 102, 102);
    [self.bgView addSubview:self.mouth];
    UILabel *monthtintLab = [[UILabel alloc]initWithFrame:YLSRect(106/375, 23/667, 106/375, 20/667)];
    monthtintLab.textAlignment = NSTextAlignmentCenter;
    monthtintLab.font = [UIFont systemFontOfSize:15];
    monthtintLab.textColor = GETColor(102, 102, 102);
    monthtintLab.text = @"月";
    [self.bgView addSubview:monthtintLab];
    
    self.week = [self transformationViewWithFrame:YLSRect(212/375, 3/667, 106/375, 20/667)];
    self.week.alignment = NSTextAlignmentCenter;
    self.week.textMargin = 1;
    self.week.textColor = GETColor(102, 102, 102);
    [self.bgView addSubview:self.week];
    UILabel *weektintLab = [[UILabel alloc]initWithFrame:YLSRect(212/375, 23/667, 106/375, 20/667)];
    weektintLab.textAlignment = NSTextAlignmentCenter;
    weektintLab.font = [UIFont systemFontOfSize:15];
    weektintLab.textColor = GETColor(102, 102, 102);
    weektintLab.text = @"周";
    [self.bgView addSubview:weektintLab];
    
    self.day = [self transformationViewWithFrame:YLSRect(0, 49/667, 106/375, 20/667)];
    self.day.alignment = NSTextAlignmentCenter;
    self.day.textMargin = 1;
    self.day.textColor = GETColor(102, 102, 102);
    [self.bgView addSubview:self.day];
    UILabel *daytintLab = [[UILabel alloc]initWithFrame:YLSRect(0, 69/667, 106/375, 20/667)];
    daytintLab.textAlignment = NSTextAlignmentCenter;
    daytintLab.font = [UIFont systemFontOfSize:15];
    daytintLab.textColor = GETColor(102, 102, 102);
    daytintLab.text = @"日";
    [self.bgView addSubview:daytintLab];
    
    self.hour = [self transformationViewWithFrame:YLSRect(106/375, 49/667, 106/375, 20/667)];
    self.hour.alignment = NSTextAlignmentCenter;
    self.hour.textMargin = 1;
    self.hour.textColor = GETColor(102, 102, 102);
    [self.bgView addSubview:self.hour];
    UILabel *hourtintLab = [[UILabel alloc]initWithFrame:YLSRect(106/375, 69/667, 106/375, 20/667)];
    hourtintLab.textAlignment = NSTextAlignmentCenter;
    hourtintLab.font = [UIFont systemFontOfSize:15];
    hourtintLab.textColor = GETColor(102, 102, 102);
    hourtintLab.text = @"小时";
    [self.bgView addSubview:hourtintLab];
    
    self.minute = [self transformationViewWithFrame:YLSRect(212/375, 49/667, 106/375, 20/667)];
    self.minute.alignment = NSTextAlignmentCenter;
    self.minute.textMargin = 1;
    self.minute.textColor = GETColor(102, 102, 102);
    [self.bgView addSubview:self.minute];
    UILabel *minutetintLab = [[UILabel alloc]initWithFrame:YLSRect(212/375, 69/667, 106/375, 20/667)];
    minutetintLab.textAlignment = NSTextAlignmentCenter;
    minutetintLab.font = [UIFont systemFontOfSize:15];
    minutetintLab.textColor = GETColor(102, 102, 102);
    minutetintLab.text = @"分钟";
    [self.bgView addSubview:minutetintLab];
    
    
    UIView* hline = [[UIView alloc]initWithFrame:YLSRect(0, 46/667, 318/375, 1/667)];
    hline.backgroundColor = GETColor(102, 102, 102);
    [self.bgView addSubview:hline];
       
    UIView* vline1 = [[UIView alloc]initWithFrame:YLSRect(106/375, 0, 1/375, 92/667)];
    vline1.backgroundColor = GETColor(102, 102, 102);
    [self.bgView addSubview:vline1];
       
    UIView* vline2 = [[UIView alloc]initWithFrame:YLSRect(212/375, 0, 1/375, 92/667)];
    vline2.backgroundColor = GETColor(102, 102, 102);
    [self.bgView addSubview:vline2];
    
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
    if ([YTUserInfoManager dx_isNullOrNilWithObject:[dataUser objectForKey:@"birthDay"]]) {
        //未设置出生日期
        self.nobirthLb.hidden = NO;
        self.noticeLb.hidden = YES;
        self.noticeLb1.hidden = YES;
        self.bgView.hidden = YES;
        [_xuanBtn setTitle:@"选择出生日期" forState:UIControlStateNormal];
    }else
    {
        self.nobirthLb.hidden = YES;
        self.noticeLb.hidden = NO;
        self.noticeLb1.hidden = NO;
        self.bgView.hidden = NO;
        [_xuanBtn setTitle:@"死之钟" forState:UIControlStateNormal];
    }
}

-(void)xuanClick:(UIButton *)sender{
    NSUserDefaults *dataUser = [NSUserDefaults standardUserDefaults];
    if ([YTUserInfoManager dx_isNullOrNilWithObject:[dataUser objectForKey:@"birthDay"]]) {
        //未设置出生日期
        NSDate *minDate = [NSDate br_setYear:1910 month:3 ];
        NSDate *maxDate = [NSDate date];
            
        NSDate *date =[NSDate date];//简书 FlyElephant
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy"];
        NSInteger currentYear=[[formatter stringFromDate:date] integerValue];
        [formatter setDateFormat:@"MM"];
        NSInteger currentMonth=[[formatter stringFromDate:date]integerValue];
        [formatter setDateFormat:@"dd"];
        NSInteger currentDay=[[formatter stringFromDate:date]integerValue];
        [BRDatePickerView showDatePickerWithTitle:@"你出生于" dateType:BRDatePickerModeYMD defaultSelValue:[NSString stringWithFormat:@"%ld-%ld-%ld",currentYear,currentMonth,currentDay] minDate:minDate maxDate:maxDate isAutoSelect:NO themeColor:nil resultBlock:^(NSString *selectValue) {
                
            NSString* year=[selectValue substringToIndex:4];
            NSString* monthStr=[selectValue substringWithRange:NSMakeRange(5, 2)];
            NSString* secondStr=[selectValue substringWithRange:NSMakeRange(8, 2)];
                
            [dataUser removeObjectForKey:@"birthDay"];
            [dataUser setObject:[NSString stringWithFormat:@"%@-%@-%@",year,monthStr,secondStr] forKey:@"birthDay"];
            [dataUser synchronize];
            
            
                
            self.nobirthLb.hidden = YES;
            self.noticeLb.hidden = NO;
            self.noticeLb1.hidden = NO;
            self.bgView.hidden = NO;
            self.saveBtn.hidden = NO;
            [self.xuanBtn setTitle:@"死之钟" forState:UIControlStateNormal];
            
            NSDate* fromDate = [NSDate new];
            // 设置系统时区为本地时区
            NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
            // 计算本地时区与 GMT 时区的时间差
            NSInteger interval = [timeZone secondsFromGMT];
            // 在 GMT 时间基础上追加时间差值，得到本地时间
            fromDate = [fromDate dateByAddingTimeInterval:interval];
            
            NSDateFormatter *currentformatter = [[NSDateFormatter alloc] init];
            [currentformatter setDateFormat:@"yyyy"];
            NSInteger currentYear = [[currentformatter stringFromDate:fromDate] integerValue];
            [currentformatter setDateFormat:@"MM"];
            NSInteger currentMonth = [[currentformatter stringFromDate:fromDate] integerValue];
            [currentformatter setDateFormat:@"ss"];
            NSInteger secondf = [[currentformatter stringFromDate:fromDate] integerValue];
            
            
            NSUserDefaults *dataUser = [NSUserDefaults standardUserDefaults];
            NSString* birthStr = [NSString stringWithFormat:@"%@ 00:00:00",[dataUser objectForKey:@"birthDay"]];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
            NSDate *toDate = [formatter dateFromString:birthStr];
            NSString *strDate = [formatter stringFromDate:toDate];
            NSInteger birthYear=[[strDate substringToIndex:4] integerValue];
            NSInteger birthMonth=[[strDate substringWithRange:NSMakeRange(5, 2)] integerValue];
            
            // 创建一个标准国际时间的日历
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            calendar.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
            // 获取两个日期的间隔
            NSDateComponents *comp = [calendar components:NSCalendarUnitDay|NSCalendarUnitHour|kCFCalendarUnitMinute fromDate:fromDate toDate:toDate options:NSCalendarWrapComponents];
            NSInteger hour = (comp.hour - comp.day * 24);
            NSInteger minute = (comp.minute -hour*60);
            
            if (birthYear%400 == 0||(birthYear%100 != 0&&birthYear%4 == 0)) {
                //闰年
                self.year.numberValue = [NSNumber numberWithInteger:(-comp.day)/366];
            }else
            {
                //平年
                self.year.numberValue = [NSNumber numberWithInteger:(-comp.day)/365];
            }
            
            self.birthdayStr = [NSString stringWithFormat:@"%.8f",(double)((-minute)*60+secondf)/(double)(60*60*24*365)];
            self.noticeLb.text = [NSString stringWithFormat:@"你%@岁了",self.birthdayStr];
            
            self.mouth.numberValue = [NSNumber numberWithInteger:((currentYear-birthYear)*12+(currentMonth-birthMonth))];
            
            self.day.numberValue = [NSNumber numberWithInteger:(-comp.day)];
            
            self.hour.numberValue = [NSNumber numberWithInteger:hour];
            self.minute.numberValue = [NSNumber numberWithInteger:-minute];
            self.week.numberValue = [NSNumber numberWithInteger:(-comp.day/7)];
            
            [self.addTimer fire];
                
            } cancelBlock:^{
                
            }];
    }else
    {
        SSDeadClockViewController* dead = [[SSDeadClockViewController alloc]init];
        dead.birthdayStr = self.birthdayStr;
        [UIView  beginAnimations:nil context:NULL];

        [UIView setAnimationCurve:UIViewAnimationCurveLinear];

        [UIView setAnimationDuration:0.75];

        [self.navigationController pushViewController:dead animated:NO];

        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];

        [UIView commitAnimations];
    }
    
}

-(void)birthClick:(UIButton *)sender{
    NSUserDefaults *dataUser = [NSUserDefaults standardUserDefaults];
    
    NSDate *minDate = [NSDate br_setYear:1910 month:3 ];
    NSDate *maxDate = [NSDate date];
    
    [BRDatePickerView showDatePickerWithTitle:@"你出生于" dateType:BRDatePickerModeYMD defaultSelValue:[dataUser objectForKey:@"birthDay"] minDate:minDate maxDate:maxDate isAutoSelect:NO themeColor:nil resultBlock:^(NSString *selectValue) {
            
        NSString* year=[selectValue substringToIndex:4];
        NSString* monthStr=[selectValue substringWithRange:NSMakeRange(5, 2)];
        NSString* secondStr=[selectValue substringWithRange:NSMakeRange(8, 2)];
            
        [dataUser removeObjectForKey:@"birthDay"];
        [dataUser setObject:[NSString stringWithFormat:@"%@-%@-%@",year,monthStr,secondStr] forKey:@"birthDay"];
        [dataUser synchronize];
        
        
            
        self.nobirthLb.hidden = YES;
        self.noticeLb.hidden = NO;
        self.noticeLb1.hidden = NO;
        self.bgView.hidden = NO;
        [self.xuanBtn setTitle:@"死之钟" forState:UIControlStateNormal];
        
        NSDate* fromDate = [NSDate new];
        // 设置系统时区为本地时区
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        // 计算本地时区与 GMT 时区的时间差
        NSInteger interval = [timeZone secondsFromGMT];
        // 在 GMT 时间基础上追加时间差值，得到本地时间
        fromDate = [fromDate dateByAddingTimeInterval:interval];
        
        NSDateFormatter *currentformatter = [[NSDateFormatter alloc] init];
        [currentformatter setDateFormat:@"yyyy"];
        NSInteger currentYear = [[currentformatter stringFromDate:fromDate] integerValue];
        [currentformatter setDateFormat:@"MM"];
        NSInteger currentMonth = [[currentformatter stringFromDate:fromDate] integerValue];
        [currentformatter setDateFormat:@"ss"];
        NSInteger secondf = [[currentformatter stringFromDate:fromDate] integerValue];
        
        
        NSUserDefaults *dataUser = [NSUserDefaults standardUserDefaults];
        NSString* birthStr = [NSString stringWithFormat:@"%@ 00:00:00",[dataUser objectForKey:@"birthDay"]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
        NSDate *toDate = [formatter dateFromString:birthStr];
        NSString *strDate = [formatter stringFromDate:toDate];
        NSInteger birthYear=[[strDate substringToIndex:4] integerValue];
        NSInteger birthMonth=[[strDate substringWithRange:NSMakeRange(5, 2)] integerValue];
        
        // 创建一个标准国际时间的日历
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        calendar.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        // 获取两个日期的间隔
        NSDateComponents *comp = [calendar components:NSCalendarUnitDay|NSCalendarUnitHour|kCFCalendarUnitMinute fromDate:fromDate toDate:toDate options:NSCalendarWrapComponents];
        NSInteger hour = (comp.hour - comp.day * 24);
        NSInteger minute = (comp.minute -hour*60);
        
        if (birthYear%400 == 0||(birthYear%100 != 0&&birthYear%4 == 0)) {
            //闰年
            self.year.numberValue = [NSNumber numberWithInteger:(-comp.day)/366];
        }else
        {
            //平年
            self.year.numberValue = [NSNumber numberWithInteger:(-comp.day)/365];
        }
        
        self.birthdayStr = [NSString stringWithFormat:@"%.8f",(double)((-minute)*60+secondf)/(double)(60*60*24*365)];
        self.noticeLb.text = [NSString stringWithFormat:@"你%@岁了",self.birthdayStr];
        
        self.mouth.numberValue = [NSNumber numberWithInteger:((currentYear-birthYear)*12+(currentMonth-birthMonth))];
        
        self.day.numberValue = [NSNumber numberWithInteger:(-comp.day)];
        
        self.hour.numberValue = [NSNumber numberWithInteger:hour];
        self.minute.numberValue = [NSNumber numberWithInteger:-minute];
        self.week.numberValue = [NSNumber numberWithInteger:(-comp.day/7)];
            
        } cancelBlock:^{
            
        }];
}

-(void)back:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
