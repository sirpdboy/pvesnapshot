# pvesnapshot

这是一个为proxmox ve写的工具脚本

方式一：手动下载上传命令行安装

需要用root账号来运行

下载文件后将文件上传到 pve的/root/目录 

在PVE中的shell中执行：

chmod  +x  ./snap.sh &&  ./snap.sh

方式二：一键无脑安装:

source <(curl -sL https://raw.githubusercontent.com/sirpdboy/pvesnapshot/master/snap.sh）

