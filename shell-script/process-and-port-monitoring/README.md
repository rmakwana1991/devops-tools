# Process and Port Monitoring Script

A lightweight Bash script for monitoring critical system processes and network ports with automated email alerting. Essential for maintaining service availability and system reliability in production environments.

## 🎯 Overview

This monitoring script provides real-time surveillance of:
- **Process Status**: Monitors if specified processes are running
- **Port Availability**: Checks if network ports are active and listening
- **Automated Alerts**: Sends email notifications when issues are detected

## ✨ Features

- **Dual Monitoring**: Process and port monitoring in a single script
- **Email Notifications**: Gmail SMTP integration for instant alerts
- **Lightweight**: Minimal system resource usage
- **Configurable**: Easy customization for different services
- **Production Ready**: Suitable for cron-based automation

## 📋 Prerequisites

- Linux/Unix system with Bash
- `curl` for email functionality
- `netstat` for port monitoring
- Gmail account with App Password

## ⚙️ Configuration

Update these variables in the script:

```bash
PROCESS_NAME="nginx"                    # Process to monitor
PORT_NUMBER="80"                        # Port to monitor  
EMAIL_ID="your-email@gmail.com"         # Gmail address
APP_PASSWORD="your-app-password"        # Gmail App Password
```

### Gmail Setup

1. Enable 2FA on Gmail account
2. Generate App Password: Google Account → Security → App passwords
3. Use the 16-character password in the script

## 🚀 Installation & Usage

```bash
# Make executable
chmod +x process-and-port-monitoring.sh

# Run manually
./process-and-port-monitoring.sh

# Schedule with cron (every 5 minutes)
*/5 * * * * /path/to/process-and-port-monitoring.sh
```

## 📊 Sample Output

**Normal Operation:**
```
Process Monitoring Started
nginx is running.
Port 80 is in use.
Process and Port Monitoring completed
```

**Alert Condition:**
```
Process Monitoring Started
nginx is not running.
Port 80 is not in use.
Process and Port Monitoring completed
```

## 🔧 Technical Details

### Process Monitoring
```bash
ps aux | grep -v grep | grep "$PROCESS_NAME"
```
- Uses `ps aux` to list all processes
- Filters out grep process itself
- Searches for specified process name

### Port Monitoring
```bash
netstat -tuln | grep -q ":$PORT_NUMBER "
```
- Uses `netstat` to list listening ports
- Checks TCP/UDP ports (`-tuln` flags)
- Searches for specific port number

### Email Function
```bash
send_email() {
    SUBJECT="$1"
    BODY="$2"
    curl --url 'smtps://smtp.gmail.com:465' --ssl-reqd \
      --mail-from "$EMAIL_ID" \
      --mail-rcpt "$EMAIL_ID" \
      --user "$EMAIL_ID:$APP_PASSWORD" \
      -T <(echo -e "From: $EMAIL_ID\nTo: $EMAIL_ID\nSubject: $SUBJECT\n\n$BODY")
}
```

**Features:**
- SMTPS encryption (port 465)
- Gmail App Password authentication
- RFC 2822 compliant email format
- Process substitution for message generation

## 🛠️ Customization Examples

### Multiple Process Monitoring
```bash
PROCESSES=("nginx" "apache2" "mysql" "redis-server")
for process in "${PROCESSES[@]}"; do
    if ! ps aux | grep -v grep | grep "$process" > /dev/null; then
        send_email "Process Alert" "$process is not running"
    fi
done
```

### Multiple Port Monitoring
```bash
PORTS=("80" "443" "3306" "6379")
for port in "${PORTS[@]}"; do
    if ! netstat -tuln | grep -q ":$port "; then
        send_email "Port Alert" "Port $port is not listening"
    fi
done
```

### Enhanced Email with System Info
```bash
send_enhanced_email() {
    SUBJECT="$1"
    BODY="$2"
    HOSTNAME=$(hostname)
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    
    ENHANCED_BODY="🚨 SYSTEM ALERT 🚨
    
Server: $HOSTNAME
Time: $TIMESTAMP
Issue: $BODY

Please investigate immediately."
    
    curl --url 'smtps://smtp.gmail.com:465' --ssl-reqd \
      --mail-from "$EMAIL_ID" \
      --mail-rcpt "$EMAIL_ID" \
      --user "$EMAIL_ID:$APP_PASSWORD" \
      -T <(echo -e "From: $EMAIL_ID\nTo: $EMAIL_ID\nSubject: [$HOSTNAME] $SUBJECT\n\n$ENHANCED_BODY")
}
```

## 🔒 Security Best Practices

### Credential Management
```bash
# Use environment variables
export EMAIL_ID="your-email@gmail.com"
export APP_PASSWORD="your-app-password"

# Reference in script
EMAIL_ID="${EMAIL_ID}"
APP_PASSWORD="${APP_PASSWORD}"
```

### File Permissions
```bash
# Restrict access to script
chmod 700 process-and-port-monitoring.sh

# Secure config file
chmod 600 monitoring.conf
```

### Security Checklist
- ✅ Use Gmail App Passwords only
- ✅ Enable SSL/TLS encryption
- ✅ Store credentials in environment variables
- ✅ Set restrictive file permissions
- ✅ Regularly rotate passwords
- ✅ Monitor email access logs

## 📈 Use Cases

| Scenario | Process | Port | Description |
|----------|---------|------|-------------|
| Web Server | `nginx` | `80,443` | Monitor web service availability |
| Database | `mysqld` | `3306` | Ensure database connectivity |
| Cache | `redis-server` | `6379` | Monitor caching service |
| API Service | `node` | `3000` | Monitor application endpoints |
| Load Balancer | `haproxy` | `80,443` | Monitor traffic distribution |

## 🔄 Integration Options

### Docker Integration
```bash
# Monitor Docker containers
CONTAINER_NAME="web-app"
if ! docker ps | grep "$CONTAINER_NAME" > /dev/null; then
    send_email "Container Alert" "$CONTAINER_NAME is not running"
fi
```

### Systemd Integration
```bash
# Monitor systemd services
SERVICE_NAME="nginx"
if ! systemctl is-active --quiet "$SERVICE_NAME"; then
    send_email "Service Alert" "$SERVICE_NAME is not active"
fi
```

### Log Integration
```bash
# Log monitoring results
LOG_FILE="/var/log/monitoring.log"
echo "$(date): $PROCESS_NAME status checked" >> "$LOG_FILE"
```

## 🚨 Troubleshooting

### Common Issues

**Email not sending:**
```bash
# Test curl connectivity
curl -v --url 'smtps://smtp.gmail.com:465'

# Verify App Password
echo "Testing Gmail authentication..."
```

**Process not detected:**
```bash
# Check exact process name
ps aux | grep nginx

# Verify process pattern
pgrep -f nginx
```

**Port monitoring issues:**
```bash
# Alternative port check methods
ss -tuln | grep ":80 "
lsof -i :80
```

## 📊 Monitoring Dashboard

Create a simple status dashboard:

```bash
#!/bin/bash
# monitoring-dashboard.sh

echo "=== System Monitoring Dashboard ==="
echo "Generated: $(date)"
echo "=================================="

# Process Status
echo "PROCESSES:"
for proc in nginx mysql redis-server; do
    if ps aux | grep -v grep | grep "$proc" > /dev/null; then
        echo "  ✅ $proc: Running"
    else
        echo "  ❌ $proc: Stopped"
    fi
done

# Port Status  
echo -e "\nPORTS:"
for port in 80 443 3306 6379; do
    if netstat -tuln | grep -q ":$port "; then
        echo "  ✅ Port $port: Listening"
    else
        echo "  ❌ Port $port: Not listening"
    fi
done
```

## 📝 Logging & Reporting

### Enhanced Logging
```bash
LOG_FILE="/var/log/process-port-monitoring.log"

log_event() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Usage
log_event "Process monitoring started"
log_event "nginx is running"
log_event "Port 80 is active"
```

### Weekly Reports
```bash
# Generate weekly summary
generate_report() {
    echo "Weekly Monitoring Report - $(date '+%Y-%m-%d')"
    echo "========================================"
    
    # Count alerts from log
    ALERTS=$(grep -c "Alert" "$LOG_FILE" || echo "0")
    echo "Total Alerts: $ALERTS"
    
    # Recent issues
    echo -e "\nRecent Issues:"
    tail -20 "$LOG_FILE" | grep -i "not running\|not in use"
}
```

## 🤝 Contributing

Contributions welcome! Areas for improvement:
- Additional monitoring methods
- Support for other email providers
- Slack/Teams integration
- Metrics collection
- Web dashboard interface

## 📄 License

MIT License - See LICENSE file for details.

## 👨‍💻 Author

**DevOps Engineer**
- System monitoring and alerting specialist
- Infrastructure automation expert
- Production reliability focus

---

*Part of a comprehensive DevOps monitoring toolkit for production environments.*