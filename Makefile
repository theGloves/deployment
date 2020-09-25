
build:
	bash stage_quick_start.sh

deploy:
	bash sendmasterfile2.sh 
	python py/autorancher.py
