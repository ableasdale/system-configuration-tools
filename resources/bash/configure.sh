HOSTS=(ip-10-218-43-190 ip-10-102-37-236 ip-10-62-167-204 ip-10-62-215-29 ip-10-60-189-202 ip-10-218-79-223 ip-10-102-3-196)
BASE_FOLDER=$ARGV[0]

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

i=0; (for h in ${HOSTS[@]}; do echo screen -t \"screen $i\" $i bash -c '"'ssh $h "'"cd $BASE_FOLDER/rebalance \&\& ./run.sh\; echo hit return\; read"'" '"'; i=$((i = i + 1)); done; echo screen $i) > screen-commands
