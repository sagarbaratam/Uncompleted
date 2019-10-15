

pack_red = httpd
pack_ubun= apache2

def flav_check():
    cmd= "cat /etc/*release |grep -w NAME|cut -c 7-12"
    
    