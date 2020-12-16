TAG="shardingbc"

workdir=$(echo $(cat config/config.json | jq ".${TAG}.depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".${TAG}.projectpwd")|sed 's/\"//g')
ted_bin=$(echo $(cat config/config.json | jq ".${TAG}.projectbin")|sed 's/\"//g')
image=$(echo $(cat config/config.json | jq ".${TAG}.image") | sed 's/\"//g')
container_id=$(echo $(cat config/config.json | jq ".${TAG}.containerid")|sed 's/\"//g')

