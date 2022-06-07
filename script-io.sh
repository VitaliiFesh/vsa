set -e
echo
lsblk
echo
read -p 'Choose a disk: ' disk
cat /sys/block/$disk/queue/scheduler
echo
read -p 'Choose a scheduler: ' scheduler
#echo $scheduler > /sys/block/$disk/queue/scheduler
#echo "===========Changed=============="
path='/etc/udev/rules.d/89-disk-scheduler.rules'

if [ "$scheduler" == "noop" ]; then
    
    echo $scheduler > /sys/block/$disk/queue/scheduler    
    cat /sys/block/$disk/queue/scheduler
    sed -i -e '/^ACTION=="add|change", SUBSYSTEM=="block", KERNEL=="sd\[a-z\]"/ s/^/#/;' $path
    sed -i -e "/^ACTION==\"add|change\", SUBSYSTEM==\"block\", KERNEL==\"$disk\"/d" $path
    sed -i "s/non-rotating disks/&\nACTION==\"add|change\", SUBSYSTEM==\"block\", KERNEL==\"$disk\", ATTR{queue\/scheduler}=\"$scheduler\", ATTR{queue\/read_ahead_kb}=\"0\"/" $path 
    
elif [ "$scheduler" == "deadline" ]; then
    
    echo $scheduler > /sys/block/$disk/queue/scheduler
    cat /sys/block/$disk/queue/scheduler
    sed -i -e '/^ACTION=="add|change", SUBSYSTEM=="block", KERNEL=="sd\[a-z\]"/ s/^/#/;' $path
    sed -i -e "/^ACTION==\"add|change\", SUBSYSTEM==\"block\", KERNEL==\"$disk\"/d" $path
    echo "ACTION==\"add|change\", SUBSYSTEM==\"block\", KERNEL==\"$disk\", ATTR{queue/rotational}==\"1\", ATTR{queue/scheduler}=\"$scheduler\", ATTR{queue/rq_affinity}=\"2\", ATTR{queue/read_ahead_kb}=\"2048\", ATTR{queue/nr_requests}=\"1024\"" >> $path
    
elif [ "$scheduler" == "cfq" ]; then
    read -p 'SSD or HDD?: ' type

    shopt -s nocasematch; if [[ "$type" == "SSD" ]]; then
    
        echo $scheduler > /sys/block/$disk/queue/scheduler
        cat /sys/block/$disk/queue/scheduler
        sed -i -e '/^ACTION=="add|change", SUBSYSTEM=="block", KERNEL=="sd\[a-z\]"/ s/^/#/;' $path
        sed -i -e "/^ACTION==\"add|change\", SUBSYSTEM==\"block\", KERNEL==\"$disk\"/d" $path
        sed -i "s/non-rotating disks/&\nACTION==\"add|change\", SUBSYSTEM==\"block\", KERNEL==\"$disk\", ATTR{queue\/scheduler}=\"$scheduler\", ATTR{queue\/read_ahead_kb}=\"0\"/" $path
    shopt -s nocasematch; elif [[ "$type" == "HDD" ]]; then
    
        echo $scheduler > /sys/block/$disk/queue/scheduler
        cat /sys/block/$disk/queue/scheduler
        sed -i -e '/^ACTION=="add|change", SUBSYSTEM=="block", KERNEL=="sd\[a-z\]"/ s/^/#/;' $path
        sed -i -e "/^ACTION==\"add|change\", SUBSYSTEM==\"block\", KERNEL==\"$disk\"/d" $path
        echo "ACTION==\"add|change\", SUBSYSTEM==\"block\", KERNEL==\"$disk\", ATTR{queue/rotational}==\"1\", ATTR{queue\/scheduler}=\"$scheduler\", ATTR{queue/rq_affinity}=\"2\, ATTR{queue/read_ahead_kb}=\"2048\", ATTR{queue/nr_requests}=\"1024\"" >> $path
    else
        echo "There is no type"
    fi
    
else 
    echo "Value is wrong"
fi
echo
cat $path
