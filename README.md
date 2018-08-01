[![Build Status](https://img.shields.io/travis/tum-gis/3dcitydb-web-map-docker/master.svg?label=master)](https://travis-ci.org/tum-gis/3dcitydb-web-map-docker) [![Build Status](https://img.shields.io/travis/tum-gis/3dcitydb-web-map-docker/devel.svg?label=devel)](https://travis-ci.org/tum-gis/3dcitydb-web-map-docker)
# 3D City Database Web Map Client Docker image
This repo contains a Dockerfile for the [3D City Database Web-Map-Client (3D web client)](https://github.com/3dcitydb/3dcitydb-web-map/) based on the official [Node.js Docker images](https://hub.docker.com/_/node/). To get the 3D web client Docker images visit the [tumgis/3dcitydb-web-map](https://hub.docker.com/r/tumgis/3dcitydb-web-map/) DockerHub page. To get things moving fast take a look the *Quick start* section.

#### Special features
* *Landing page* and *data listing* for convenient 3D web client project creation

#### Image versions/tags
* **latest** - Latest stable version based on latest version of the 3D web client. Built from [master](https://github.com/tum-gis/3dcitydb-web-map-docker/tree/master) branch.
* **devel** - Development version containing latest features. Built from [devel](https://github.com/3dcitydb/3dcitydb-web-map/tree/devel) branch.
* **experimental** - Development version containing latest features. Built from the latest commit of the [3DCityDB Web-Map-Client Github master branch](https://github.com/3dcitydb/3dcitydb-web-map/tree/master).
* **v1.1.0**, **v1.4.0**, **v1.6.0** - Same content as **latest** image, but built with a specific version (**vX.X.X**) of the 3DCityDB Web-Map-Client.

Use `docker pull tumgis/3dcitydb-web-map:TAG` to download the latest version of the image with the specified `TAG` to your system. For example: `docker pull tumgis/3dcitydb-web-map:v1.4.0`.

#### More 3DCityDB Docker Images
Check out the Docker images for the *3D City Database* and the *3D City Database Web Feature Service (WFS)* too:
* [3DCityDB Docker image](https://github.com/tum-gis/3dcitydb-postgis-docker/)  
* [3DCityDB Web Feature Service (WFS) image](https://github.com/tum-gis/3dcitydb-wfs-docker/)

> **Note:** Everything in this repo is in development stage. 
> If you experience any problems or have a suggestion/improvement please let me know by creating an issue [here](https://github.com/tum-gis/3dcitydb-web-map-docker/issues).

## What is the 3DCityDB-Web-Map-Client
The **3DCityDB-Web-Map-Client** is a web-based front-end of the 3DCityDB for high-performance 3D visualization and interactive exploration of **arbitrarily large semantic 3D city models in CityGML**. It utilizes the [Cesium Virtual Globe](http://cesiumjs.org/index.html) as its 3D geo-visualization engine based on HTML5 and Web Graphics Library (WebGL) to provide hardware acceleration and cross-platform functionalities like displaying 3D graphic contents on web browsers without the needs of additional plugins.

The key features and functionalities of the 3DCityDB-Web-Map-Client is summarized as follows: 

* Support for efficient displaying, caching, prefetching, dynamic loading and unloading of large pre-styled 3D visualization models in the form of tiled KML/glTF datasets exported from the 3DCityDB using the Importer/Exporter
* Intuitive user interface for adding and removing arbitrary number of data layers like 3D visualization model (KML/glTF), WMS imagery layer, and Cesium digital terrain model
* Support for linking the 3D visualization models (KML/glTF) with the cloud-based Google Fusion Table allowing for querying the thematic data of every 3D object
* Support for rich interaction with 3D visualization models (KML/glTF), for example, highlighting of 3D objects on mouseover and mouseclick as well as hiding and showing of the selected 3D objects
* Support for exploring a 3D object of interest from different view perspectives using third-party mapping services like Microsoft Bing Maps with oblique view, Google Streetview, and a combined version (DualMaps) 
* Support for on-the-fly activating and deactivating shadow visualization of 3D objects (only for glTF, KML is currently not supported yet) and Cesium digital terrain models
* Support for collaborative creation and sharing of the workspace of the 3DCityDB-Web-Map-Client by means of generating a scene link including information about the current camera perspective, activation status of the shadow visualization, parameters of the current loaded data layers etc. 

![3DCityDB](https://www.3dcitydb.org/3dcitydb/fileadmin/default/templates/images/logo.jpg "3DCityDB logo")
> [3DCityDB Official Homepage](https://www.3dcitydb.net/)  
> [3DCityDB Github](https://github.com/3dcitydb)  
> [CityGML](https://www.citygml.org/)  
> [3DCityDB and CityGML Hands-on Tutorial](https://www.gis.bgu.tum.de/en/projects/3dcitydb/#c1425)

## Quick start
This section describes how to get a 3DCityDB-Web-Map-Client container running as quick and easy as possible.
1. Install Docker on your system.
   This step is mandatory. Downloads and detailed instructions for various operating systems can be found here: [https://docs.docker.com/install/](https://docs.docker.com/install/)
2. Run the 3D web client Docker images using [`docker run`](https://docs.docker.com/engine/reference/commandline/run/). Use the `-p <host port:docker port>` switch to specify on which port the 3D web client will listen on your host system. For instance, use `-p 80:8000` if you want to access the 3D web client on the default *http port=80*.
  ```bash
  docker run -dit --name 3dwebmap-container -p 80:8000 tumgis/3dcitydb-web-map
  ```
3. As soon as the container has started, the 3D web client will be available on your Docker host with any common Web Browser. If you run the container locally with above port settings, the landing page is available here:  
  [http://localhost/](http://localhost/) or [http://127.0.0.1/](http://127.0.0.1/)

## Hosting data AND the 3D web client
The 3DCityDB-Web-Map-Client Docker image allows you to host the data you want to use in the client. All data, that is visible to the `/var/www/data/` directory of a running 3D web client container will be listed in the *data listing* and can be used in the client to create web visualizations. The best way to make data available to that directory is by using a so called [bind mount](https://docs.docker.com/storage/bind-mounts/) where a *host directory* is mapped to a *container directory*. Checkout this overview on Docker's [data storge and persistence](https://github.com/tum-gis/3dcitydb-docker-postgis#data-storage-and-persistence) for more insight on *bind mounts* and other possible options.

The following example will explain how to host the 3DCityDB-Web-Map-Client and an example data set.
We assume you have created some *glTF* data for testing using the [3DCityDB Importer/Exporter](https://www.3dcitydb.org/3dcitydb/d3dimpexp/). If this is not the case, a test dataset is available [here](https://github.com/3dcitydb/3dcitydb-web-map/tree/master/examples/glTFRailwaySceneLoD3Example/Railway_Scene_LoD3). For this example we assume the test dataset is stored at `/home/docker/data/` on your docker host:
```
$ ls -lh /home/docker/data/

-rw-r--r-- 1 root root 9.1K Mar 15 18:36 Railway_Scene_LoD3.json
-rw-r--r-- 1 root root 1.9K Mar 15 18:36 Railway_Scene_LoD3.kml
-rw-r--r-- 1 root root  316 Mar 15 18:36 Railway_Scene_LoD3_collada_MasterJSON.json
drwxr-xr-x 3 root root 4.0K Mar 15 18:36 Tiles

```
To start a 3DCityDB-Web-Map-Client Docker container and *bind mount* the `/home/docker/data/` host directory to the `/var/www/data/` container directory run:

```bash
docker run -dit --name 3dwebmap-container -p 80:8000 \
    -v /home/docker/data/:/var/www/data/ \    
  tumgis/3dcitydb-web-map
```

> **Note:**
> In the example above long commands are broken to several lines for readability using the Bash (` \ `) or CMD (`^`) line continuation.  

The data is now available in the data listing (e.g. `http://myDockerHost/data/`). Use your Browser's *Copy Link Address* feature to copy the URLs required in the 3D web client.

![Data listing view](https://github.com/tum-gis/3dcitydb-web-map-docker/blob/master/images/data-listing-01.png)

## How to build
To build a 3DCityDB-Web-Map-Client Docker image from the Dockerfile in this repo you need to download the source code from this repo and run the [`docker build`](https://docs.docker.com/engine/reference/commandline/build/) command. Follow the step below to build a 3DCityDB-Web-Map-Client Docker image or use the [`build.sh`](https://github.com/tum-gis/3dcitydb-web-map-docker/blob/master/build.sh) script.
```bash
# 1. Download source code using git
git clone https://github.com/tum-gis/3dcitydb-web-map-docker
# 2. Change to the source folder you just cloned
cd 3dcitydb-web-map-docker
# 3. Build a docker image tagged as e.g. 3dcitydb-web-map
docker build -t tumgis/3dcitydb-web-map .
```

If the build succeeds, you are ready to run the image as described above. To list all locally available images run [`docker images`](https://docs.docker.com/engine/reference/commandline/images/). 

### Build parameters
To build a Docker image with a custom *Tomcat base image*, a specific *3DCityDB WFS version*, or a custom *web app context path*, the [`docker build --build-arg`](https://docs.docker.com/engine/reference/commandline/build/) parameter is used.

| Parameter name          | Description                            | Default value     |
|-------------------------|----------------------------------------|-------------------|
| baseimage_tag           | Tag of the Node.js image to use. A list of all available tags is available [here](https://hub.docker.com/_/node/). | *10* |
| webmapclient_version    | Version of the 3DCityDB-Web-Map-Client to build. Any branch name or tag from the [3DCityDB-Web-Map-Client GitHub](https://github.com/3dcitydb/3dcitydb-web-map/) repo can be used.            | *v1.6.0*           |

> **Note:**  
> The build process has been tested with the `node:10` base image and `v1.6.0` of the 3DCityDB-Web-Map-Client so far.
 
Build example:
```bash
docker build \
    --build-arg "baseimage_tag=9-slim" \
    --build-arg "webmapclient_version=master" \
  -t tumgis/3dcitydb-web-map:9-slim-master .
```

