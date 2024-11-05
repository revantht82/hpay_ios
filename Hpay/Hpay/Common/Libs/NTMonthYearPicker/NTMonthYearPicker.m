#import "NTMonthYearPicker.h"
//
// NTMonthYearPickerViewDelegate
//


//
// NTMonthYearPickerView
//

@interface NTMonthYearPickerView : UIPickerView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic) NTMonthYearPickerMode datePickerMode;
@property (nonatomic, retain) NSLocale *locale;
@property (nonatomic, copy) NSCalendar *calendar;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSDate *minimumDate;
@property (nonatomic, retain) NSDate *maximumDate;
@property (nonatomic,assign) id<NTMonthYearPickerViewDelegate> pickerDelegate;

- (void)setDate:(NSDate *)date animated:(BOOL)animated;

@end

@implementation NTMonthYearPickerView {
    // Picker data (list of months and years)
    NSArray *_days;
    NSArray *_months;
    NSArray *_years;

    // Cached min/max year/month values
    // We do this to avoid expensive NSDateComponents-based date math in pickerView:viewForRow
    NSInteger _minimumYear;
    NSInteger _maximumYear;
    NSInteger _minimumMonth;
    NSInteger _maximumMonth;
    NSInteger _maximumDay;
}

@synthesize datePickerMode;
@synthesize locale = _locale;
@synthesize calendar = _calendar;
@synthesize date = _date;
@synthesize minimumDate;
@synthesize maximumDate;
@synthesize pickerDelegate;

// Default min/max year values used if minimumDate/maximumDate is not set
// These values match that of UIDatePicker
const NSInteger kMinYear = 0;
const NSInteger kMaxYear = 2030;

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initCommon];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initCommon];
    }
    return self;
}

- (void)initCommon {
    self.dataSource = self;
    self.delegate = self;
    //self.showsSelectionIndicator = YES;

    // Initialize default cached values
    [self initCachedValues];

    // Initialize picker data
    [self initPickerData];

    // Set default date to today
//    _date = [NSDate date];
}

- (void)initCachedValues {
    _minimumYear = -1;
    _maximumYear = -1;
    _minimumMonth = -1;
    _maximumMonth = -1;
}

- (void)initPickerData {
    // Form list of months
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:self.locale];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
    NSUInteger numberOfDaysInMonth = range.length;

    NSMutableArray *days = [NSMutableArray array];
    for(int i = 1; i <= numberOfDaysInMonth; i++) {
        [days addObject: [NSString stringWithFormat:@"%d",i]];
    }
    _days = days;
    
    _months = [dateFormatter monthSymbols];

    // Form list of years
    [dateFormatter setDateFormat:@"yyyy"];
    NSDateComponents *comps = [[NSDateComponents alloc] init];

    NSMutableArray *years = [[NSMutableArray alloc] init];
    for( int year = kMinYear ; year <= kMaxYear ; ++year ) {
        [comps setYear:year];
        NSDate *yearDate = [self.calendar dateFromComponents:comps];
        NSString *yearStr = [dateFormatter stringFromDate:yearDate];

        [years addObject:yearStr];
    }
    _years = years;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    // Set initial picker selection
    @try  {
        [self selectionFromDate:FALSE];
    }
    @catch (NSException *exception) {
        NSLog(@"%@ ",exception.name);
        NSLog(@"Reason: %@ ",exception.reason);
    }
}

#pragma mark - Date picker mode

- (void)setDatePickerMode:(NTMonthYearPickerMode)mode {
    datePickerMode = mode;

    [self reloadAllComponents];
    [self selectionFromDate:FALSE];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [self reloadAllComponents];
}

#pragma mark - Locale

- (NSLocale *)locale {
    if( _locale == nil ) {
        _locale = [self.calendar locale];
    }
    return _locale;
}

- (void)setLocale:(NSLocale *)loc {
    _locale = loc;
}

#pragma mark - Calendar

- (NSCalendar *)calendar {
    if( _calendar == nil ) {
        _calendar = [NSCalendar currentCalendar];
    }
    return _calendar;
}

- (void)setCalendar:(NSCalendar *)cal {
    _calendar = cal;
}

#pragma mark - Date

- (NSDate *)date {
    return _date;
}

- (void)setDate:(NSDate *)dt {
    [self setDate:dt animated:FALSE];
}

- (void)setDate:(NSDate *)dt animated:(BOOL)animated {
    _date = dt;
    [self selectionFromDate:animated];
}

#pragma mark - Min / Max date

- (void)setMinimumDate:(NSDate *)minDate {
    minimumDate = minDate;

    // Pre-calculate min year & month
    if( minimumDate != nil ) {
        NSDateComponents *comps = [self.calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth) fromDate:minimumDate];
        _minimumYear = comps.year;
        _minimumMonth = comps.month;
    } else {
        _minimumYear = -1;
        _minimumMonth = -1;
    }

    [self reloadAllComponents];
}

- (void)setMaximumDate:(NSDate *)maxDate {
    maximumDate = maxDate;

    // Pre-calculate max year & month
    if( maximumDate != nil ) {
        NSDateComponents *comps = [self.calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:maximumDate];
        _maximumMonth = comps.month;
        _maximumDay = comps.day;
        _maximumYear = comps.year;

    } else {
        _maximumYear = -1;
        _maximumMonth = -1;
    }

    [self reloadAllComponents];
}

#pragma mark - Date <-> selection

- (void)selectionFromDate:(BOOL)animated {
    // Extract the month and year from the current date value
    NSDateComponents* comps = [self.calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:self.date];
    NSInteger day = [comps day];
    NSInteger month = [comps month];
    NSInteger year = [comps year];
    
    // Select the corresponding rows in the UI
    [self selectRow:(month - 1) inComponent:0 animated:animated];
    [self selectRow:(day - 1) inComponent:1 animated:animated];
    [self selectRow:(year - kMinYear) inComponent:2 animated:animated];
}

- (NSDate *)dateFromSelection {
    NSInteger month, day, year;

    // Get the currently selected month and year
    month = [self selectedRowInComponent:0] + 1;
    day = [self selectedRowInComponent:1] + 1;
    year  = [self selectedRowInComponent:2] + kMinYear;

    // Assemble into a date object
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setCalendar:[NSCalendar currentCalendar]];

    [comps setDay: day];
    [comps setMonth:month];
    [comps setYear:year];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[calendar dateFromComponents:comps]];
    NSUInteger numberOfDaysInMonth = range.length;
    
    NSMutableArray *days = [NSMutableArray array];
    for(int i = 1; i <= numberOfDaysInMonth; i++) {
        [days addObject: [NSString stringWithFormat:@"%d",i]];
    }
    _days = days;
                               
    return [calendar dateFromComponents:comps];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
//    BOOL isYearComponent = (datePickerMode == NTMonthYearPickerModeYear) || (component == 1);
    switch (component) {
        case 0:
            return [_months count];

        case 1:
            return [_days count];

        case 2:
            return [_years count];

        default:
            return 0;
    }
}

#pragma mark - UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    // Create (or reuse) the label instance
    UILabel *label = (UILabel *)view;
    if( label == nil ) {
        CGSize rowSize = [pickerView rowSizeForComponent:component];
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rowSize.width, rowSize.height)];
        label.font = [UIFont systemFontOfSize:24];
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
    }

    // Is the month or year represented by this component out of bounds? (i.e. < min or > max)
//    BOOL outOfBounds = FALSE;
//     if (component == 0) {
//        NSInteger month = row + 1;
//
//        // Extract the year from the current date
//        NSDateComponents *comps = [self.calendar components:(NSCalendarUnitYear) fromDate:self.date];
//        NSInteger year = comps.year;
//
//        if( ( (maximumDate != nil) && ((year > _maximumYear) || ((year == _maximumYear) && (month > _maximumMonth))) ) ||
//            ( (minimumDate != nil) && ((year < _minimumYear) || ((year == _minimumYear) && (month < _minimumMonth))) ) ) {
//            outOfBounds = TRUE;
//        }
//    }
//
//    else if (component == 1) {
//        NSInteger year = row + kMinYear;
//
//        if( ((maximumDate != nil) && (year > _maximumYear)) ||
//            ((minimumDate != nil) && (year < _minimumYear)) ) {
//            outOfBounds = false;
//        }
//    }
//
//    else if( component == 2 ) {
//        NSInteger year = row + kMinYear;
//
//        if( ((maximumDate != nil) && (year > _maximumYear)) ||
//            ((minimumDate != nil) && (year < _minimumYear)) ) {
//            outOfBounds = TRUE;
//        }
//    }

    // Set label text & color
    NSString *textLabel = @"";
    
    switch (component) {
        case 0:
            textLabel = [_months objectAtIndex:row];
            break;
            
        case 1:
            textLabel = [_days objectAtIndex:row];
            break;;

        case 2:
            textLabel = [_years objectAtIndex:row];
            break;
    }
    label.text = textLabel;
//    label.textColor = (outOfBounds ? [self getCurrentTheme].secondaryOnSurface : [self getCurrentTheme].primaryOnSurface);

    return label;
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    // Update date value
    _date = [self dateFromSelection];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error display content" message:@"Error connecting to server, no local database" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alertController addAction:ok];
    
    UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    topWindow.rootViewController = [UIViewController new];
    topWindow.windowLevel = UIWindowLevelAlert + 1;
    [topWindow makeKeyAndVisible];

//    [topWindow.rootViewController presentViewController:alertController animated:YES completion:nil];

    // If the currently selected date < the min date, reset it to the min date
    if( (minimumDate != nil) && ([self.date compare:minimumDate] == NSOrderedAscending) ) {
//        [self setDate:minimumDate animated:TRUE];

    }

    // If the currently selected date > the min date, reset it to the max date
    if( (maximumDate != nil) && ([self.date compare:maximumDate] == NSOrderedDescending) ) {
//        [self setDate:maximumDate animated:TRUE];
    }

    // If the year was changed, reload the month picker
    // This is to refresh the enabled/disabled state of the months
    if (component == 0) {
        [self reloadComponent:1];
    }
    
    if( component == 2 ) {
        [self reloadComponent:0];
    }

    // Notify delegate
    [pickerDelegate didSelectDate];
}

//- (NSComparisonResult)compareMonthYear:(NSDate *)date1 with:(NSDate *)date2 {
//    NSDateComponents *comps = [self.calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date1];
//    date1 = [self.calendar dateFromComponents:comps];
//
//    comps = [self.calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date2];
//    date2 = [self.calendar dateFromComponents:comps];
//
//    return [date1 compare:date2];
//}

@end

//
// NTMonthYearPicker
//

@interface NTMonthYearPicker (Delegate) <NTMonthYearPickerViewDelegate>
@end

@implementation NTMonthYearPicker {
    NTMonthYearPickerView *_pickerView;
}

@synthesize datePickerMode;
@synthesize locale;
@synthesize calendar;
@synthesize date;
@synthesize minimumDate;
@synthesize maximumDate;

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _pickerView = [[NTMonthYearPickerView alloc] initWithFrame:frame];
        [self initCommon];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _pickerView = [[NTMonthYearPickerView alloc] initWithCoder:aDecoder];

        CGSize pickerSize = [_pickerView sizeThatFits:CGSizeZero];
        _pickerView.frame = CGRectMake( 0, 0, pickerSize.width, pickerSize.height );

        [self initCommon];
    }
    return self;
}

- (void)initCommon {
    self.frame = _pickerView.frame;
    _pickerView.pickerDelegate = self;
    [self addSubview:_pickerView];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [_pickerView sizeThatFits:size];
}

- (void)didSelectDate {
//    [_pickerView dids]
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - NTMonthYearPicker API

- (NTMonthYearPickerMode)datePickerMode {
    return _pickerView.datePickerMode;
}

- (void)setDatePickerMode:(NTMonthYearPickerMode)dpm {
    _pickerView.datePickerMode = dpm;
}

- (NSLocale *)locale {
    return _pickerView.locale;
}

- (void)setLocale:(NSLocale *)loc {
    _pickerView.locale = loc;
}

- (NSCalendar *)calendar {
    return _pickerView.calendar;
}

- (void)setCalendar:(NSCalendar *)cal {
    _pickerView.calendar = cal;
}

- (NSDate *)date {
    return _pickerView.date;
}

- (void)setDate:(NSDate *)dt {
    [_pickerView setDate:dt];
}

- (void)setDate:(NSDate *)dt animated:(BOOL)animated {
    [_pickerView setDate:dt animated:animated];
}

- (NSDate *)minimumDate {
    return _pickerView.minimumDate;
}

- (void)setMinimumDate:(NSDate *)minDate {
    _pickerView.minimumDate = minDate;
}

- (NSDate *)maximumDate {
    return _pickerView.maximumDate;
}

- (void)setMaximumDate:(NSDate *)maxDate {
    _pickerView.maximumDate = maxDate;
}

@end
