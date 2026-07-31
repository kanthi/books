# sleep

## Overview
The `sleep` command pauses execution for a specified amount of time. It's essential for creating delays in scripts, timing operations, and controlling execution flow.

## Syntax
```bash
sleep number[suffix]
```

## Time Suffixes
| Suffix | Unit |
|--------|------|
| `s` | Seconds (default) |
| `m` | Minutes |
| `h` | Hours |
| `d` | Days |

## Key Use Cases
1. Script timing and delays
2. Rate limiting operations
3. Polling intervals
4. System testing
5. Batch processing control

## Examples with Explanations
### Example 1: Basic Sleep
```bash
sleep 5
```
Pauses for 5 seconds

### Example 2: Different Time Units
```bash
sleep 2m    # 2 minutes
sleep 1h    # 1 hour
sleep 0.5   # Half second
```

### Example 3: In Script Context
```bash
echo "Starting process..."
sleep 3
echo "Process started!"
```

## Common Usage Patterns
1. Retry with delay:
   ```bash
   while ! ping -c 1 google.com; do
       echo "Waiting for network..."
       sleep 5
   done
   ```
2. Batch processing:
   ```bash
   for file in *.txt; do
       process_file "$file"
       sleep 1  # Avoid overwhelming system
   done
   ```
3. Monitoring loops:
   ```bash
   while true; do
       check_system_status
       sleep 30
   done
   ```

## Fractional Seconds
1. Decimal notation:
   ```bash
   sleep 0.5   # Half second
   sleep 1.5   # 1.5 seconds
   sleep 0.1   # 100 milliseconds
   ```
2. Very short delays:
   ```bash
   sleep 0.01  # 10 milliseconds
   ```

## Performance Analysis
- Minimal CPU usage during sleep
- No active polling
- Efficient for timing control
- Good for rate limiting
- System scheduler dependent

## Related Commands
- `wait` - Wait for processes
- `timeout` - Run with time limit
- `usleep` - Microsecond sleep
- `nanosleep` - Nanosecond precision
- `at` - Schedule commands

## Best Practices
1. Use appropriate time units
2. Consider system load
3. Handle interrupts gracefully
4. Use for rate limiting
5. Avoid unnecessary delays

## Scripting Applications
1. Service startup delay:
   ```bash
   #!/bin/bash
   echo "Starting services..."
   start_database
   sleep 10  # Wait for database to initialize
   start_application
   ```
2. Retry mechanism:
   ```bash
   retry_command() {
       local max_attempts=5
       local delay=2

       for i in $(seq 1 $max_attempts); do
           if command; then
               return 0
           fi
           echo "Attempt $i failed, retrying in ${delay}s..."
           sleep $delay
           delay=$((delay * 2))  # Exponential backoff
       done
       return 1
   }
   ```

## Rate Limiting
1. API calls:
   ```bash
   for endpoint in "${endpoints[@]}"; do
       curl "$endpoint"
       sleep 1  # Respect rate limits
   done
   ```
2. File processing:
   ```bash
   find . -name "*.log" | while read file; do
       process_log "$file"
       sleep 0.5  # Prevent I/O overload
   done
   ```

## System Testing
1. Load testing:
   ```bash
   for i in {1..100}; do
       make_request &
       sleep 0.1  # Gradual load increase
   done
   ```
2. Stress testing:
   ```bash
   while true; do
       stress_test_component
       sleep 60  # Cool-down period
   done
   ```

## Integration Examples
1. With monitoring:
   ```bash
   while true; do
       if ! check_service_health; then
           alert_admin
           sleep 300  # Wait before next check
       else
           sleep 60   # Normal check interval
       fi
   done
   ```
2. Deployment script:
   ```bash
   deploy_application
   echo "Waiting for application to start..."
   sleep 30
   run_health_checks
   ```

## Signal Handling
Sleep can be interrupted by signals:
```bash
# This will be interrupted by Ctrl+C
sleep 3600 &
PID=$!
# Later: kill $PID
```

## Precision Considerations
1. System scheduler affects precision
2. Minimum sleep time varies by system
3. High-precision alternatives:
   ```bash
   # For microsecond precision
   usleep 500000  # 0.5 seconds

   # For nanosecond precision (if available)
   nanosleep 0.000000001  # 1 nanosecond
   ```

## Error Handling
1. Invalid time format:
   ```bash
   if ! sleep "$delay" 2>/dev/null; then
       echo "Invalid delay: $delay"
       exit 1
   fi
   ```
2. Interrupted sleep:
   ```bash
   sleep 60 || echo "Sleep was interrupted"
   ```

## Alternatives and Workarounds
1. Using read with timeout:
   ```bash
   read -t 5 -p "Press enter to continue (5s timeout): "
   ```
2. Using timeout command:
   ```bash
   timeout 5 cat  # Waits up to 5 seconds for input
   ```

## Real-world Examples
1. Database backup script:
   ```bash
   #!/bin/bash
   echo "Starting backup..."
   mysqldump database > backup.sql
   echo "Backup complete, waiting before compression..."
   sleep 5
   gzip backup.sql
   echo "Backup compressed and ready"
   ```
2. Service health monitor:
   ```bash
   while true; do
       if curl -f http://localhost:8080/health; then
           echo "Service healthy"
           sleep 60
       else
           echo "Service unhealthy, checking again soon"
           sleep 10
       fi
   done
   ```

## Troubleshooting
1. Sleep not working as expected
2. Precision issues
3. Signal interruption
4. Invalid time formats
5. System clock changes

## Security Considerations
1. Avoid predictable delays in security contexts
2. Consider timing attacks
3. Use random delays when appropriate:
   ```bash
   # Random delay between 1-5 seconds
   sleep $((1 + RANDOM % 5))
   ```

## Performance Impact
1. No CPU usage during sleep
2. Process remains in memory
3. Can affect script execution time
4. Consider parallel execution:
   ```bash
   # Instead of sequential delays
   for i in {1..10}; do
       (process_item $i; sleep 1) &
   done
   wait  # Wait for all background jobs
   ```