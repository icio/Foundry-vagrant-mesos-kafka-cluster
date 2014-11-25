The Foundry
=====================

A vagrant configuration to set up a cluster of mesos master, slaves and zookeepers through ansible. It will also set up a seperate Kafka cluster that piggybacks off Zookeeper from the Mesos cluster.

This also installs HDFA HA (Namenodes on mesos-master1 and mesos-master2) and Spark (spark-submit at /home/spark/spark/bin/spark-submit on mesos-master3).

For Kafka and Bamboo, just uncomment the Kafka VM in the Vagrantfile and Inventory File. And for Bamboo, uncomment in the cluster.yml playbook. These were turned off since it takes forever to Vagrant Up with them, and will probably be re-enabled soon.

# Usage

Make sure you have the vagrant-hostmanager plugin installed
```
vagrant plugin install vagrant-hostmanager
```

Clone the repository, and run:

```
vagrant up
```

This will provision a mini Mesos cluster with one master, three slaves, and one
Kafka instance.  The Mesos master server also contains Zookeeper and the
Marathon framework. The slave will come with HAProxy, Docker, and Bamboo installed.

Bamboo handles service discovery and reconfigures HAProxy. See usage instructions here: https://github.com/QubitProducts/bamboo


# Deploying Docker containers

After provisioning the servers you can access Marathon here:
http://100.0.10.11:8080/ and the master itself here: http://100.0.10.11:5050/ and http://mesos-master1:8081 for Chronos.

Submitting a Docker container to run on the cluster is done by making a call to
Marathon's REST API:

First create a file, `ubuntu.json`, with the details of the Docker container that you want to run:

```
{
  "container": {
    "type": "DOCKER",
    "docker": {
      "image": "libmesos/ubuntu"
    }
  },
  "id": "ubuntu",
  "instances": "1",
  "cpus": "0.5",
  "mem": "128",
  "uris": [],
  "cmd": "while sleep 10; do date -u +%T; done"
}
```

And second, submit this container to Marathon by using curl:

```
curl -X POST -H "Content-Type: application/json" http://100.0.10.11:8080/v2/apps -d@ubuntu.json
```

You can monitor and scale the instance by going to the Marathon web interface linked above. 

# Using Spark

Load up the spark-shell using 
```
/home/spark/spark/bin/spark-shell --master mesos://mesos-master1:5050,mesos-master2:5050,mesos-master3:5050 --executor-memory 128M
```
And execute a simple script
```
sc.parallelize(1 to 10).count()
```

Go to http://mesos-master3:5050/#/frameworks
and see the workers in action

There should also be a Spark UI at http://mesos-master3:4040

There is a Spark Job Server Running at http://mesos-master:8090
```
curl --data-binary @job-server-tests/target/job-server-tests-0.4.2-SNAPSHOT.jar mesos-master:8090/jars/test

curl -d "input.string = a b c a b see" 'mesos-master:8090/jobs?appName=test&classPath=spark.jobserver.WordCountExample'
{
  "status": "STARTED",
  "result": {
    "jobId": "0d734d5b-9dc8-4b85-aa2e-3f36b0fe4d91",
    "context": "abbe3d0b-spark.jobserver.WordCountExample"
  }
}
```
From this point, you could asynchronously query the status and results:
```
curl mesos-master:8090/jobs/3d4ef63e-1222-41f1-ad43-164e0412a99b
{
  "status": "OK",
  "result": {
    "a": 2,
    "b": 2,
    "see": 1,
    "c": 1
  }
}
```

