#!/bin/bash
#############--Proxmox Config snapshot--##########################
#  Author : sirpdboy
#  Mail: herboy2008@gmail.com
#  Version: v1.0.5
########################################################


#set date&time snapshot
startsnapshot(){
    DAY=$(whiptail --title "Config snapshot DAY" --inputbox "
set snapshot DAY, just enter number or n?
设置快照保存天数, 只需要输入纯数字即可，比如4天输入4?
    " 20 60    3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        while [ true ]
        do
            if [[ "$DAY" =~ ^[1-9]+$ ]]; then
                break
            else
                whiptail --title "Warnning" --msgbox "
Invalidate value.Please comfirm!
输入的值无效，请重新输入!
                " 10 60
                startsnapshot
            fi
        done
startvmid(){
list=`qm list|awk 'NR>1{print $1":"$2"......."$3" "}'`
    ls=`for i in $list;do echo $i|awk -F ":" '{print $1" "$2}';done`
    h=`echo $ls|wc -l`
    let h=$h*1
    if [ $h -lt 30 ];then
        h=30
    fi
    list1=`echo $list|awk 'NR>1{print $1}'`
    VMID=$(whiptail  --title "Config snapshot vmid  " --menu "
Choose vmid to unset nested:
设置快照虚拟机vm：" 25 60 15 \
    $(echo $ls) \
     3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        if(whiptail --title "Yes/No" --yesno "
you choose: $vmid ,continue?
你选的是：$VMID ，是否继续?
            " 10 60)then
            while [ true ]
            do
                if [ `echo "$VMID"|grep "^[0-9]*$"|wc -l` = 0 ];then
                    whiptail --title "Warnning" --msgbox "
Invalidate value.Please comfirm!
输入的值无效，请重新输入!
                    " 10 60

                            startvmid
                else
                    break
                fi
             done
              else
	          main
	      fi
	 else
	          main
	      fi
	      }
	      startvmid
	      starttime(){

                    TIME=$(whiptail --title "Config snapshot TIME" --inputbox "
set snapshot DAY, just enter number or n?
设置快照生成保存间隔小时(1-23), 只需要输入纯数字即可，比如每间隔4小时输入4?
    " 20 60    3>&1 1>&2 2>&3)
                    exitstatus=$?
                    if [ $exitstatus = 0 ]; then
                       while [ true ]
                      do
                        if [[ "$TIME" =~ ^[1-9]+$ ]]; then
                            break
                        else
                            whiptail --title "Warnning" --msgbox "
Invalidate value.Please comfirm!
输入的值无效，请重新输入!
                            " 10 60
                            starttime
                        fi
                       done
		  else
		      main
		  fi  
		}
		starttime
	PWD=`pwd`
	[  ! -s $PWD/baksnapshot.sh ] && curl -fsSL  https://raw.githubusercontent.com/sirpdboy/pvesnapshot/master/baksnapshot.sh  > $PWD/baksnapshot.sh
	if [  ! -s $PWD/baksnapshot.sh ] ;then
	         whiptail --title "Warring" --msgbox "
Warring!
文件不完整,安装失败！联系开发人员！wx！4745747！
                            " 10 60
			    exit
	fi
	if [ ! -s /usr/bin/baksnapshot.sh ] ;then
	    cp  $PWD/baksnapshot.sh /usr/bin/baksnapshot.sh
	    chmod +x /usr/bin/baksnapshot.sh
	fi
	sed -i '/baksnapshot/d' /etc/crontab
	echo "01 */$TIME * * * root baksnapshot.sh $DAY $VMID"  >> /etc/crontab
	baksnapshot.sh $DAY $VMID
	/etc/init.d/cron restart
	whiptail --title "Success" --msgbox "
参数：虚拟机$VMID,保留$DAY天记录,每$TIME小时自动生成快照!
自动快照任务设置成功！
                            " 10 60
   else
      main
   fi

}

stopsnapshot(){
if(whiptail --title "Yes/No Box" --yesno "
是否禁用自动生成快照?
" --defaultno 10 60) then
	sed -i '/baksnapshot/d' /etc/crontab
	[ -s $PWD/baksnapshot.sh ] || rm -rf /usr/bin/baksnapshot.sh
	/etc/init.d/cron restart
 else
        return
fi
}

setmenu(){
clear
    OPTION=$(whiptail --title " Config snapshot Menu " --menu "
请选择需要的功能：" 25 60 15 \
    "a" "更换快照菜单为查看快照" \
    "b" "恢复查看快照菜单为快照" \
    "x" "返回主菜单" \
    3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        case "$OPTION" in
        a )

if(whiptail --title "Yes/No Box" --yesno "
是否更换快照菜单为查看快照?
" --defaultno 10 60) then
	sed -i 's/6\"\:\[\"快照/6\"\:\[\"查看快照/g' /usr/share/pve-i18n/pve-lang-zh_CN.js
	sed -i 's,"回滚","回滚快照",g' /usr/share/pve-i18n/pve-lang-zh_CN.js
	sed -i 's,"做快照","手动快照",g' /usr/share/pve-i18n/pve-lang-zh_CN.js
		whiptail --title "Success" --msgbox "
Configed!
更换快照菜单为查看快照成功！
                            " 10 60
        setmenu
 else
        main
fi
            ;;
        b )

if(whiptail --title "Yes/No Box" --yesno "
是否恢复查看快照为快照?
" --defaultno 10 60) then
	sed -i 's/6\"\:\[\"查看快照/6\"\:\[\"快照/g' /usr/share/pve-i18n/pve-lang-zh_CN.js
	sed -i 's,"回滚快照","回滚",g' /usr/share/pve-i18n/pve-lang-zh_CN.js
	sed -i 's,"手动快照","做快照",g' /usr/share/pve-i18n/pve-lang-zh_CN.js
		whiptail --title "Success" --msgbox "
Configed!
恢复查看快照为快照成功！
                            " 10 60
        setmenu
 else
        main
fi
            ;;
        exit | x | q )
            main
            ;;
        esac
    else
        main
    fi


}

main(){
clear
    OPTION=$(whiptail --title " Config snapshot Menu " --menu "
请选择需要的功能：" 25 60 15 \
    "a" "启用自动生成快照" \
    "b" "禁用自动生成快照" \
    "c" "更换快照菜单名字" \
    "x" "退出菜单" \
    3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        case "$OPTION" in
        a )
	    startsnapshot
            echo "Config complete!Back to main menu 3s later."
            echo "已经完成自动生成快照配置！5秒后返回主界面。"
            echo "5"
            sleep 1
            echo "4"
            sleep 1
            echo "3"
            sleep 1
            echo "2"
            sleep 1
            echo "1"
            sleep 1
            main
            ;;
        b )
            stopsnapshot
            main
            ;;
        c )
            setmenu
            main
            ;;
        exit | x | q )
            exit
            ;;
        esac
    else
        exit
    fi
}

#--------santa-start--------------
DrawTriangle() {
	a=$1
	color=$[RANDOM%7+31]
	if [ "$a" -lt "8" ] ;then
		b=`printf "%-${a}s\n" "0" |sed 's/\s/0/g'`
		c=`echo "(31-$a)/2"|bc`
        d=`printf "%-${c}s\n"`
		echo "${d}`echo -e "\033[1;5;${color}m$b\033[0m"`"
	elif [ "$a" -ge "8" -a "$a" -le "21" ] ;then
		e=$[a-8]
		b=`printf "%-${e}s\n" "0" |sed 's/\s/0/g'`
		c=`echo "(31-$e)/2"|bc`
		d=`printf "%-${c}s\n"`
		echo "${d}`echo -e "\033[1;5;${color}m$b\033[0m"`"
	fi
}

DrawTree() {
	e=$1
	b=`printf "%-3s\n" "|" | sed 's/\s/|/g'`
	c=`echo "($e-3)/2"|bc`
	d=`printf "%-${c}s\n" " "`
	echo -e "${d}${b}\n${d}${b}\n${d}${b}\n${d}${b}\n${d}${b}\n${d}${b}"
    echo "       Merry Cristamas!"
}

Display(){
	for i in `seq 1 2 31`; do
		[ "$i"="21" ] && DrawTriangle $i
		if [ "$i" -eq "31" ];then
			DrawTree $i
		fi
	done
}
if [[ `date +%m%d` = 1224  ||  `date +%m%d` = 1225 ]] && [ ! -f '/tmp/santa' ];then
    for i in {1..6}
    do
        Display
        sleep 1
        clear
    done
    touch /tmp/santa
fi


main
