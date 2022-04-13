#!/bin/bash

# Prereqs: docker-compose
#          mvn (to compile the program)
#          curl

generate_post_data()
{
  cat <<EOF
{
  "name": "elasticsearch-sink",
  "config": {
    "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
    "tasks.max": "1",
    "topics": "test-topic",
    "key.ignore": "true",
    "schema.ignore": "true",
    "connection.url": "http://elasticsearch:9200",
    "type.name": "test-type",
    "name": "elasticsearch-sink",
    "key.converter": "org.apache.kafka.connect.json.JsonConverter",
    "key.converter.schemas.enable": "false",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter.schemas.enable": "false",
    "transforms": "insertTS,formatTS",
    "transforms.insertTS.type": "org.apache.kafka.connect.transforms.InsertField\$Value",
    "transforms.insertTS.timestamp.field": "messageTS",
    "transforms.formatTS.type": "org.apache.kafka.connect.transforms.TimestampConverter\$Value",
    "transforms.formatTS.format": "yyyy-MM-dd'T'HH:mm:ss",
    "transforms.formatTS.field": "messageTS",
    "transforms.formatTS.target.type": "string"
  }
}
EOF
}

# Restart everything from empty. The yaml file defining the
# containers has no persistent volumes.
docker-compose down
docker-compose up -d

# Give it a chance to start
echo "Waiting for 180 seconds..."
sleep 180

# Configure kafka connect
curl -i \
-H "Content-Type:application/json" \
-X POST --data "$(generate_post_data)" "http://localhost:8083/connectors"

# Wait a while longer to give everything a chance to stabilise
echo "Waiting for 15 seconds..."
sleep 15

#Publish messages to kafka
docker exec -i kafka bash -c "echo '{\"request\": {\"userId\" : \"23768432478278\"}}' | /opt/kafka/bin/kafka-console-producer.sh --broker-list kafka:9092 --topic test-topic"
exit $rc
