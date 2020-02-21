# Selenoid

[Selenoid](https://aerokube.com/selenoid/) is an open source automated testing solution for running browser tests with containerized browser instances.
Basically a containerized selenium hub. It supports features like video recording, saving session logs, etc. Read the documentation for the details.  

It is supposedly has a much faster Selenium protocol implementation and is super easy to setup as demonstrated here.

A process called selenoid (the hub) runs and accepts connections on port 4444. It is configured with a file called browsers.json
which contains, among other things, a list browsers and versions as capabilities.

When a selenium run starts with a specified browser and version a docker container is instantiated by the selenoid process
for executing the selenium test. 
 
There is also a UI for the selenoid where you can see information like which browsers and version are supported along with 
the configured number of parallel process. Additionally if the browsers specified in the browsers.json are the VNC versions, 
you can view the execution from the UI. 

### What Is What

* browsers.json: The configuration file for selenoid. Defines what browsers and versions to test with.

* selenoid-image-fetcher: Selenoid expects the browser container images to already be pulled onto the docker host running the
selenoid container. Instead of manually pulling images after updating the browsers.json file I created this simple Alpine based
container that will periodically read the browsers.json file and pull the browser versions defined in it. You can set the 
environment variable `PULL_WAIT_PERIOD` to the number of seconds between checks for changes to the browsers.json file. Defaults to `60` seconds.  

* selenoid-compose.yaml: Links and deploys Selenoid, Selenoid UI and the image fetcher on a single host as docker containers.

### Running The Images
To deploy simply clone this repository. Change directory into the selenoid directory and execute the following. 

* `docker-compose up -d`

This will bring up the image fetcher, selenoid and selnoud UI, in that order, on the docker host. 

**NOTE:** The restart policy for the containers is `unless-stopped`. This means, for example, unless you actually stop the 
containers with `docker-compose stop|down` the containers will be **restarted** after the machine is rebooted. 

### Updating the browsers.json
When you need to add a new browser version for testing. Simply edit the browsers.json. 
Unfortunately it seems you have to bring at least the selenoid container down after updating the browser.json file.
```
docker-compose down
docker-compose up -d
``` 

### Post Run Configuration

There is no post run configuration to be done. 

### Things to Know

The UI is reachable on the host at port 9000
 
A status for Selenoid can be gotten with `/status` on the selenoid hub container. 
For example, http://localhost:4444/status. This will return some Json like the below.

`{"total":5,"used":0,"queued":0,"pending":0,"browsers":{"chrome":{"75.0":{}},"firefox":{"57.0":{}}}}`


