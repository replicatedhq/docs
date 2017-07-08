.PHONY: run all vendordocs swagger2markup

all: run

run:
	docker-compose up

vendordocs:
	rm -f docs/reference/vendor-api.adoc
	git checkout docs/reference/vendor-api/index.md
	find . -name "*vendor-api*" -ls
	VENDOR_API="${SOURCE}" ./vendor.sh

setup:
	mkdir -p java
	curl -o java/swagger2markup-cli-1.0.0.jar http://central.maven.org/maven2/io/github/swagger2markup/swagger2markup-cli/1.0.0/swagger2markup-cli-1.0.0.jar
	curl -o java/swagger2markup-1.0.0.jar http://central.maven.org/maven2/io/github/swagger2markup/swagger2markup/1.0.0/swagger2markup-1.0.0.jar
