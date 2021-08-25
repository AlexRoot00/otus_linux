hostname test.domain.space
apt update -y 
apt install -y apache2 openssl 
apt install -y selinux-basics selinux-policy* auditd
selinux-activate
a2enmod ssl
mkdir /home/apache2
cd /home/apache2/

openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout key.pem -out cert.pem -subj '/CN=test.domain.space'
sudo chown -R root:root
chmod 1770 /home/apache2/

#cat > /etc/hostname <<EOF
#127.0.0.1 localhost
#127.0.1.1 test.domain.space
#EOF

cat > /etc/apache2/ports.conf <<EOF
<IfModule ssl_module>
        Listen 843
</IfModule>
<IfModule mod_gnutls.c>
        Listen 843
</IfModule>
EOF


a2enmod ssl
service apache2 start
service apache2 enable
a2ensite 000-default
a2enmod access_compat actions alias allowmethods asis auth_basic auth_digest auth_form authn_anon authn_core authn_dbd authn_dbm authn_file authn_socache authnz_fcgi authnz_ldap authz_core authz_dbd authz_dbm authz_groupfile authz_host authz_owner authz_user autoindex buffer cache cache_disk cache_socache cgi cgid charset_lite data dav dav_fs dav_lock dbd deflate dialup dir dump_io echo env expires ext_filter file_cache filter headers heartbeat heartmonitor ident include info lbmethod_bybusyness lbmethod_byrequests lbmethod_bytraffic lbmethod_heartbeat ldap log_debug log_forensic lua macro mime mime_magic mpm_event mpm_prefork mpm_worker negotiation proxy proxy_ajp proxy_balancer proxy_connect proxy_express proxy_fcgi proxy_fdpass proxy_ftp proxy_html proxy_http proxy_scgi proxy_wstunnel ratelimit reflector remoteip reqtimeout request rewrite sed session session_cookie session_crypto session_dbd setenvif slotmem_plain slotmem_shm socache_dbm socache_memcache socache_shmcb speling ssl status substitute suexec unique_id userdir usertrack vhost_alias xml2enc
cat > /etc/apache2/sites-available/000-default.conf <<EOF
<IfModule mod_ssl.c>
   <VirtualHost *:843>
        ServerName test.domain.space
        ServerAlias www.test.domain.space
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html
        SSLEngine on
        SSLCertificateFile /home/apache2/cert.pem
        SSLCertificateKeyFile /home/apache2/key.pem
        SSLHonorCipherOrder on
        <FilesMatch "\.(cgi|shtml|phtml|php)$">
                                SSLOptions +StdEnvVars
                </FilesMatch>
                <Directory /usr/lib/cgi-bin>
                                SSLOptions +StdEnvVars
                </Directory>
        SSLCompression off
        ErrorLog /var/log/apache2/error.log
        CustomLog /var/log/apache2/access.log combined
</VirtualHost>

</IfModule>

EOF
service apache2 restart

apt install -y curl
curl https://localhost:843 -k
apt install nginx -y
cat > /etc/nginx/conf.d/test.domain.space.conf <<EOF
server {

    listen 8443 ssl;
    server_name test.domain.space;
    access_log off;
    error_log /var/log/nginx/error.log;
    ssl on;
    ssl_stapling on;
    ssl_stapling_verify on;

    ssl_certificate /home/apache2/cert.pem;
    ssl_certificate_key /home/apache2/key.pem;
   

    ssl_session_tickets off;

    ssl_session_timeout 1d;

    ssl_session_cache shared:SSL:50m;


    ssl_ciphers 'ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES256-SHA:ECDHE-ECDSA-DES-CBC3-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:DES-CBC3-SHA:!DSS';

    ssl_prefer_server_ciphers on;

    add_header Strict-Transport-Security max-age=31536000;

    location / {



        proxy_send_timeout 600;

        proxy_read_timeout 600;

        proxy_buffer_size   128k;

        proxy_buffers   4 256k;

        proxy_busy_buffers_size   256k;
        proxy_set_header HTTPS YES;
        proxy_pass https://localhost:843;
            }

} 
EOF

systemctl restart nginx
systemctl enable nginx
iptables -A INPUT -p tcp --dport 8443 -j ACCEPT
iptables -A INPUT -p tcp --dport 843 -s 127.0.0.1 -j ACCEPT
iptables -A INPUT -p tcp --dport 843 -j BLOCK
iptables -A INPUT -p tcp --dport 80 -j BLOCK
iptables-save 
curl https://localhost:8443 -k

reboot