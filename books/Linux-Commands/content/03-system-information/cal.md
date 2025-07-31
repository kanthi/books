# cal

## Overview
The `cal` command displays a calendar for a specified month and year. It's useful for date reference, scheduling, and quick date calculations.

## Syntax
```bash
cal [options] [month] [year]
cal [options] [year]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-1` | Display single month (default) |
| `-3` | Display previous, current, and next month |
| `-A num` | Display num months after |
| `-B num` | Display num months before |
| `-y` | Display entire year |
| `-j` | Display Julian dates (day of year) |
| `-m` | Monday as first day of week |
| `-s` | Sunday as first day of week (default) |
| `-w` | Display week numbers |
| `--color` | Colorize output |

## Key Use Cases
1. Quick date reference
2. Planning and scheduling
3. Date calculations
4. Historical date lookup
5. Script date validation

## Examples with Explanations
### Example 1: Current Month
```bash
cal
```
Displays calendar for current month

### Example 2: Specific Month and Year
```bash
cal 12 2024
```
Shows December 2024 calendar

### Example 3: Entire Year
```bash
cal -y 2024
```
Displays full year 2024 calendar

### Example 4: Three Month View
```bash
cal -3
```
Shows previous, current, and next month

## Date Range Display
1. Show months after current:
   ```bash
   cal -A 3  # Next 3 months
   ```
2. Show months before current:
   ```bash
   cal -B 2  # Previous 2 months
   ```
3. Combine before and after:
   ```bash
   cal -B 1 -A 1  # Previous, current, next
   ```

## Julian Calendar
1. Show day of year:
   ```bash
   cal -j
   ```
2. Julian date for specific month:
   ```bash
   cal -j 3 2024  # March 2024 with day numbers
   ```

## Week Display Options
1. Monday as first day:
   ```bash
   cal -m
   ```
2. Show week numbers:
   ```bash
   cal -w
   ```
3. Combine options:
   ```bash
   cal -mw  # Monday first + week numbers
   ```

## Historical Dates
1. Historical calendar:
   ```bash
   cal 9 1752  # September 1752 (calendar reform)
   ```
2. Ancient dates:
   ```bash
   cal 1 1  # January year 1
   ```
3. Future dates:
   ```bash
   cal 12 2050  # December 2050
   ```

## Performance Analysis
- Very fast operation
- Minimal resource usage
- No network dependencies
- Good for scripting
- Efficient date calculations

## Related Commands
- `date` - Current date/time
- `ncal` - Alternative calendar
- `dateutils` - Date utilities
- `at` - Schedule commands
- `crontab` - Schedule recurring tasks

## Best Practices
1. Use for quick date reference
2. Combine with date command
3. Consider locale settings
4. Use Julian dates for day counting
5. Helpful for scheduling scripts

## Scripting Applications
1. Date validation:
   ```bash
   #!/bin/bash
   validate_date() {
       local month=$1 year=$2
       if cal "$month" "$year" >/dev/null 2>&1; then
           echo "Valid date"
           return 0
       else
           echo "Invalid date"
           return 1
       fi
   }
   ```
2. Business day calculation:
   ```bash
   count_weekdays() {
       local month=$1 year=$2
       cal "$month" "$year" | grep -E '[0-9]' | \
       tr ' ' '\n' | grep -E '^[0-9]+$' | wc -l
   }
   ```

## Integration Examples
1. With date for context:
   ```bash
   echo "Today is $(date +%A), $(date +%B) $(date +%d)"
   cal -3
   ```
2. Planning script:
   ```bash
   echo "Current month schedule:"
   cal
   echo ""
   echo "Upcoming deadlines:"
   # Show project deadlines
   ```

## Locale Considerations
1. Different locales affect:
   - First day of week
   - Month names
   - Date formatting

2. Set locale:
   ```bash
   LC_TIME=en_US.UTF-8 cal
   LC_TIME=de_DE.UTF-8 cal
   ```

## Output Formatting
1. Pipe to other commands:
   ```bash
   cal | grep -E '[0-9]'  # Extract date lines
   ```
2. Count days in month:
   ```bash
   cal 2 2024 | tail -1 | awk '{print $NF}'
   ```
3. Find specific day:
   ```bash
   cal | grep -o '\b15\b'  # Find 15th day
   ```

## Calendar Calculations
1. Days in month:
   ```bash
   days_in_month() {
       cal "$1" "$2" | awk 'NF {last=$NF} END {print last}'
   }
   ```
2. First day of month:
   ```bash
   first_day_of_week() {
       cal "$1" "$2" | awk '/^[A-Z]/ {getline; print NF}'
   }
   ```

## Troubleshooting
1. Invalid month/year combinations
2. Locale-specific formatting issues
3. Terminal width limitations
4. Historical calendar accuracy
5. Leap year calculations

## Advanced Usage
1. Custom formatting with ncal:
   ```bash
   ncal -b  # Brief format
   ncal -M  # Monday first
   ```
2. Specific day highlighting:
   ```bash
   cal | sed "s/$(date +%d)/[$(date +%d)]/"
   ```

## Historical Context
1. Calendar reform (1752):
   ```bash
   cal 9 1752  # Shows 11 missing days
   ```
2. Leap year examples:
   ```bash
   cal 2 2000  # Leap year (divisible by 400)
   cal 2 1900  # Not leap year (divisible by 100, not 400)
   ```

## Automation Examples
1. Monthly report header:
   ```bash
   #!/bin/bash
   echo "Monthly Report - $(date +%B %Y)"
   echo "================================"
   cal
   echo ""
   ```
2. Schedule reminder:
   ```bash
   # Show next month for planning
   NEXT_MONTH=$(date -d "next month" +%m)
   NEXT_YEAR=$(date -d "next month" +%Y)
   echo "Next month planning:"
   cal "$NEXT_MONTH" "$NEXT_YEAR"
   ```

## Color Output
Modern cal versions support color:
```bash
cal --color=always
```

Environment variable:
```bash
export CAL_COLOR=always
```

## Integration with Other Tools
1. With remind/calendar apps:
   ```bash
   cal && echo "" && remind ~/.reminders
   ```
2. With task managers:
   ```bash
   cal -3 && echo "" && task list
   ```