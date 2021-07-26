KAFKA_VERSION ?= 1.0.0
KAFKA_PROFILE = kafka-${KAFKA_VERSION}
export JAVA_TOOL_OPTIONS = -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn
LADDERS_IMAGE = $(shell aws sts get-caller-identity | jq -r '.Account').dkr.ecr.us-east-1.amazonaws.com/maxwell:1.33.1-ladders

all: compile

test:
	mvn -B test -P ${KAFKA_PROFILE}

compile:
	mvn -B compile -P ${KAFKA_PROFILE}

clean:
	mvn -B clean

depclean: clean
	rm -f $(CLASSPATH)

package: depclean kafka-0.8.2.2 kafka-0.9.0.1 kafka-0.10.0.1 kafka-0.10.2.1 kafka-0.11.0.1 kafka-1.0.0 kafka-2.7.0
	@# TODO: this is inefficient, we really just want to copy the jars...
	mvn package -DskipTests=true

kafka-%:
	mvn compile -P kafka-$(*)

ladders:
	docker build --tag $(LADDERS_IMAGE) .
	docker push $(LADDERS_IMAGE)
