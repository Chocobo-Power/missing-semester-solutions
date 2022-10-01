mcd () {
	mkdir -p "$1"
	cd "$1"
}

mongo-start () {
    docker-compose -f ~/.docker-compose-mongodb.yaml start
}

mongo-stop () {
    docker-compose -f ~/.docker-compose-mongodb.yaml stop
}

mongo-bash () {
    docker exec -it mongodb bash
}
