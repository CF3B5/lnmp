FROM ubuntu:18.04
RUN export DEBIAN_FRONTEND=noninteractive && \
sed -i -e 's|archive.ubuntu.com|mirrors.aliyun.com|g' /etc/apt/sources.list && \
apt-get update && apt-get -y install sudo openssh-server net-tools aptitude vim nginx php-fpm php-curl php-mysql php-gd php-mbstring php-memcached php-mongodb php-xdebug memcached mysql-server && \
ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
dpkg-reconfigure -f noninteractive tzdata && \
useradd test && \
echo test:123|chpasswd && \
echo root:123|chpasswd

VOLUME /var/www/html /var/lib/mysql
EXPOSE 80 22
CMD service ssh start && \
service nginx start && \
service memcached start && \
service php7.2-fpm start && \
service mysql start && \
tail -f /var/log/nginx/access.log