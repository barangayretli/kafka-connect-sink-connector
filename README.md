# Kafka Connect Elasticsearch Sink Connector

We will use docker and docker-compose to run this project. Increase your memory allocation to 6-8GB just to be safe.

## Change /etc/hosts file for kafka

Since in docker-compose.yml file, the environment variable “KAFKA_ADVERTISED_HOST_NAME” is set to “kafka”, you need to do a small change in your /etc/hosts file 

![](images/host.png)

## Run startup.sh

Simply run **startup.sh** file to make everything work. Give it some time to initialize, it might take a while.

```shellscript
/bin/bash startup.sh
```

After everything started up, you should see these containers running when you type **docker ps**:

![](images/dockerps.png)

## Messages stored in Elasticsearch

Finally, let’s check if the kafka connector worked as we intended.

Open your browser and go to  [http://localhost:9200/example-topic/_search?pretty](http://localhost:9200/example-topic/_search?pretty)

You should see something like this:

```json

{
  "took" : 256,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 3,
      "relation" : "eq"
    },
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "example-topic",
        "_type" : "_doc",
        "_id" : "example-topic+0+0",
        "_score" : 1.0,
        "_source" : {
          "request" : {
            "userId" : "23768432478278"
          },
          "messageTS" : "2022-04-13T20:42:05"
        }
      },
      {
        "_index" : "example-topic",
        "_type" : "_doc",
        "_id" : "example-topic+0+1",
        "_score" : 1.0,
        "_source" : {
          "request" : {
            "userId" : "23768432432453"
          },
          "messageTS" : "2022-04-13T20:42:14"
        }
      },
      {
        "_index" : "example-topic",
        "_type" : "_doc",
        "_id" : "example-topic+0+2",
        "_score" : 1.0,
        "_source" : {
          "request" : {
            "userId" : "23768432432237"
          },
          "messageTS" : "2022-04-13T20:42:23"
        }
      }
    ]
  }
}
```

Now you are ready to use your elasticsearch as datasource. Just use the [http://localhost:9200](http://localhost:9200) port as the URL and you should be good to go.

## Bonus

This part is optional, now you are ready to visualize the messages with Grafana by adding Elasticsearch as the datasource. 

If you don't have grafana installed and running already, run:

```shellscript
brew update
brew install grafana
brew services start grafana
```

Go to Configuration→Data Sources→Add Data Source→Select Elasticsearch and fill out the settings as the following. 

You need to keep in mind that your kafka topic name corresponds to the index name in elasticsearch.

![](images/datasource.png)


