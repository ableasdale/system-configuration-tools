BASE_FOLDER=$1
HOSTS=$2

i=0; for h in ${HOSTS[@]}; do
	echo removing files for $h ...
	rm /tmp/$h*.properties
        #scp -r rebalance root@$h:$BASE_FOLDER
        # scp /tmp/$h*.properties root@$h:$BASE_FOLDER/rebalance
done