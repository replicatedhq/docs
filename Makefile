.PHONY: run all vendordocs swagger2markup

all: run

run:
	docker-compose up

vendordocs:
	rm -f site/content/reference/vendor-api.adoc
	git checkout site/content/reference/vendor-api/index.md
	find . -name "*vendor-api*" -ls
	VENDOR_API="${SOURCE}" ./bin/vendor.sh

setup:
	curl -o .local/swagger2markup-cli-1.0.0.jar http://central.maven.org/maven2/io/github/swagger2markup/swagger2markup-cli/1.0.0/swagger2markup-cli-1.0.0.jar
	curl -o .local/swagger2markup-1.0.0.jar http://central.maven.org/maven2/io/github/swagger2markup/swagger2markup/1.0.0/swagger2markup-1.0.0.jar
