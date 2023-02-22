source common.sh

mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then
  echo -e "\e[31mMissing MySQL Root Password Argument\e[0m"
  exit 1
fi

print_head "Disabling MySQL version 8"
dnf module disable mysql -y &>>${log_file}
status_check $?

print_head "Copy MySQL Repo File"
cp ${code_dir}/configs/mysql.repo /etc/yum.repos.d/mysql.repo

print_head "Installing MySQL Server"
yum install mysql-community-server -y &>>${log_file}
status_check $?

print_head "Enable MySQL Service"
systemctl enable mysqld &>>${log_file}
status_check $?

print_head "Start MySQL Service"
systemctl start mysqld &>>${log_file}
status_check $?

print_head "Ser Root Password"
mysql_secure_installation --set-root-pass ${mysql_root_password} &>>${log_file}
status_check $?

mysql -uroot -pRoboShop@1
