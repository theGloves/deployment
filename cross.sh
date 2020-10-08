for (( i=1; i <= 15 ; i++ ))
do
    bash tm-test.sh 15 300 120 6 2
	sleep 20
done

sleep 600
python py/autorancher.py clean