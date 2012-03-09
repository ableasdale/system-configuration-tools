BASE_FOLDER=$1
HOSTS=$2

i=0; for h in ${HOSTS[@]}; do
	echo removing files for $h ...
	rm /tmp/$h*.properties
	ssh -A root@localhost "rm -rf $BASE_FOLDER/rebalance"
done