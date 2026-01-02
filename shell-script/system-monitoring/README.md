# System Monitoring & Alerting Script

A lightweight bash script for monitoring system resources (CPU, RAM, Storage) and sending email alerts via Gmail when thresholds are exceeded.

## 🚀 Features

- **Real-time Monitoring**: Monitors CPU, RAM, and storage usage
- **Configurable Thresholds**: Set custom alert thresholds (default: 90%)
- **Email Notifications**: Sends alerts via Gmail SMTP
- **Lightweight**: Pure bash script with minimal dependencies
- **Easy Setup**: Simple configuration and deployment

## 📋 Prerequisites

- Linux/Unix system with bash
- `curl` command-line tool
- Gmail account with App Password enabled
- Basic system utilities: `top`, `free`, `df`, `awk`

## ⚙️ Configuration

### 1. Gmail App Password Setup

1. Enable 2-Factor Authentication on your Gmail account
2. Generate an App Password:
   - Go to Google Account settings
   - Security → 2-Step Verification → App passwords
   - Generate a new app password for "Mail"

### 2. Script Configuration

Edit the variables in `system-monitoring.sh`:

```bash
CPU_THRESHOLD=90        # CPU usage threshold (%)
RAM_THRESHOLD=90        # RAM usage threshold (%)
STORAGE_THRESHOLD=90    # Storage usage threshold (%)
EMAIL_ID="your-email@gmail.com"
APP_PASSWORD="your-app-password"
```

## 🛠️ Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd system-monitoring
```

2. Make the script executable:
```bash
chmod +x system-monitoring.sh
```

3. Configure your email credentials (see Configuration section)

## 🚀 Usage

### Manual Execution
```bash
./system-monitoring.sh
```

### Automated Monitoring with Cron

Add to crontab for automated monitoring:

```bash
# Edit crontab
crontab -e

# Add entry for monitoring every 5 minutes
*/5 * * * * /path/to/system-monitoring.sh

# Or every hour
0 * * * * /path/to/system-monitoring.sh
```

## 📊 Monitoring Details

| Resource | Command Used | Threshold | Alert Trigger |
|----------|--------------|-----------|---------------|
| **CPU** | `top -bn1` | 90% | When usage > threshold |
| **RAM** | `free` | 90% | When usage > threshold |
| **Storage** | `df -h /` | 90% | When usage > threshold |

## 📤 Email Function

The script uses a `send_email()` function that leverages curl to send SMTP emails via Gmail:

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

**Function Parameters:**
- `$1`: Email subject
- `$2`: Email body content

**SMTP Configuration:**
- **Server**: `smtp.gmail.com`
- **Port**: `465` (SSL/TLS)
- **Authentication**: Gmail App Password

## 📧 Email Alert Format

**Subject**: `[Resource] Usage Alert`

**Body**: `[Resource] usage is above the threshold of [X]%. Current usage: [Y]%.`

**Example**:
- Subject: `CPU Usage Alert`
- Body: `CPU usage is above the threshold of 90%. Current usage: 95%.`

## 🔧 Customization

### Modify Thresholds
```bash
# Lower thresholds for more sensitive monitoring
CPU_THRESHOLD=80
RAM_THRESHOLD=85
STORAGE_THRESHOLD=75
```

### Add Additional Recipients
```bash
# Modify the send_email function to include multiple recipients
--mail-rcpt "admin1@company.com" \
--mail-rcpt "admin2@company.com" \
```

### Monitor Additional Partitions
```bash
# Add monitoring for other mount points
STORAGE_USAGE_HOME=$(df -h /home | awk 'NR==2 {print $5}'| tr -d '%')
```

## 🐛 Troubleshooting

### Common Issues

1. **Email not sending**:
   - Verify Gmail App Password is correct
   - Check if 2FA is enabled
   - Ensure curl supports SSL/TLS

2. **Permission denied**:
   ```bash
   chmod +x system-monitoring.sh
   ```

3. **Command not found**:
   - Install missing utilities: `sudo apt-get install curl`

4. **Cron job not running**:
   - Check cron service: `sudo systemctl status cron`
   - Verify crontab syntax: `crontab -l`

### Testing

```bash
# Test email functionality
# Temporarily lower thresholds to trigger alerts
CPU_THRESHOLD=1
RAM_THRESHOLD=1
STORAGE_THRESHOLD=1
```

## 📁 Project Structure

```
system-monitoring/
├── README.md
└── system-monitoring.sh
```

## 🔒 Security Considerations

- **App Password**: Store securely, avoid hardcoding in production
- **File Permissions**: Restrict script access (`chmod 700`)
- **Environment Variables**: Consider using env vars for sensitive data

```bash
# Using environment variables
EMAIL_ID="${MONITOR_EMAIL}"
APP_PASSWORD="${MONITOR_APP_PASSWORD}"
```

## 🚀 Production Deployment

### Systemd Service (Recommended)

Create `/etc/systemd/system/system-monitor.service`:

```ini
[Unit]
Description=System Monitoring Service
After=network.target

[Service]
Type=oneshot
User=monitor
ExecStart=/opt/system-monitoring/system-monitoring.sh
EnvironmentFile=/etc/system-monitoring/config

[Install]
WantedBy=multi-user.target
```

Create timer `/etc/systemd/system/system-monitor.timer`:

```ini
[Unit]
Description=Run system monitoring every 5 minutes
Requires=system-monitor.service

[Timer]
OnCalendar=*:0/5
Persistent=true

[Install]
WantedBy=timers.target
```

Enable and start:
```bash
sudo systemctl enable system-monitor.timer
sudo systemctl start system-monitor.timer
```

## 📈 Enhancements

- Add logging functionality
- Implement different alert levels
- Add Slack/Teams integration
- Create web dashboard
- Add historical data storage
- Implement alert cooldown periods

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 👨💻 Author

Maintained by DevOps Engineers

---

**⭐ Star this repository if you find it helpful!**

