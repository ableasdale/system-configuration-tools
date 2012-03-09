BASE_FOLDER=$1
HOSTS=$2

# preflight
if [ "$TERM" == "screen" ]; then
    echo exit screen before running this script!
    exit 1
fi

i=0; for h in ${HOSTS[@]}; do
		echo copying properties for $h ...
        scp -r rebalance root@$h:$BASE_FOLDER
        scp /tmp/$h*.properties root@$h:$BASE_FOLDER/rebalance
done

i=0; (for h in ${HOSTS[@]}; do echo screen -t \"screen $i\" $i bash -c '"'ssh $h "'"cd $BASE_FOLDER/rebalance \&\& ./run.sh\; echo hit return\; read"'" '"'; i=$((i = i + 1)); done; echo screen $i) > dist/screen-commands
