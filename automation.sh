#!/usr/bin/sudo bash
DateTime=$(date '+%d%m%Y-%H%M%S')
s3Bucket=upgrad-nishith
Name="Nishith Shah"
echo $Name
sudo apt update -y
sudo apt install apache2
readonly DateTime
ps cax | grep httpd
if [ $? -eq 1 ]
 then
 echo "Apache process is running."
elif [ $? -eq 0 ]
then
 echo "Apache process is not running."
fi
if [ $(/etc/init.d/apache2 status | grep -v grep | grep 'apache2.service; enabled;' | wc -l) > 0 ]
then
 echo "Apache Server service is enabled."
else
  echo "Apache Server service is Disabled."
fi
cd /var/log/apache2
tar -cf nishith-httpd-logs-$DateTime.tar access.log error.log
cp nishith-httpd-logs-$DateTime.tar /tmp
aws s3 cp /tmp/nishith-httpd-logs-$DateTime.tar s3://$s3Bucket/nishith-httpd-logs-$DateTime.tar
echo "File uploaded to S3 bucket successful"
file="/var/www/html/inventory.html"
if [ ! -f "$file" ]
then
  echo "nishith-httpd-logs-$DateTime.tar" > /var/www/html/inventory.html
else
  echo "nishith-httpd-logs-$DateTime.tar" > /var/www/html/inventory.html
fi
echo "File created"
cd /etc/cron.d
sudo crontab -l > automation
sudo echo "* * * * * root /root/Automation_Project/automation.sh >/dev/null 2>&1" > automation
sudo crontab automation
echo " Script completed"