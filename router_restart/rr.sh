#!/bin/bash
folder=/etc/mysc/router_restart
#folder=/git/tests/router_restart/
host1=8.8.8.8
host2=ya.ru
host3=mail.ru
a=0
b=0
c=0
#считываем количество попыток
read count<$folder/count
#пути к скриптам управления реле
r1up=/etc/mysc/cpio/relay/up1.sh
r1down=/etc/mysc/cpio/relay/down1.sh
#r1up="echo relay up"
#r1down="echo relay down"

#вычисляем количество запущенных копий нашей программы
ch=`ps auxww |grep rr.sh |grep /bin/bash |wc |awk '{print $1-1}'`
echo "процессов $ch"
if [ $ch -gt 1 ]; then
echo "Process already running. Please wait and try again later."
exit
    else
{

echo $count
#проверяем пинги
if ping -c 1 $host1; then let a=$a+1
    else a=0
    fi

if ping -c 1 $host2; then let b=$b+1
    else b=0
    fi

if ping -c 1 $host3; then let c=$c+1
    else c=0
    fi
let d=$a+$b+$c

echo $d

if [ $d == 0 ]; then echo "Интернет не работает"
    count=$((count+1))

	if [ $count -gt 5 ]; then
		
		$r1down
		echo "уже было 5 попыток. Делаю паузу 30 min"
		sleep 1800s
		echo "0">$folder/count
		
	else
	
	    $r1up
	    sleep 10s
	    $r1down
	    echo "relay was restarted" > $folder/email
	    date |awk -F ":" '{print $1">"$2">"$3}' >> $folder/email
	    echo "count is" >> $folder/email
	    echo $count >> $folder/email
echo $count
	    echo $count > $folder/count
fi
else echo "Интернет работает."
echo "0">$folder/count
    if [ -f $folder/email ]; then
	cat $folder/email |ssmtp -s "router_restarted" n.v.shadrin
	cd $folder && rm $folder/email
    else exit
    fi
fi
}
fi