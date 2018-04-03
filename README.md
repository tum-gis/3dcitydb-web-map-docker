# 3D City Database Web Map Client Docker image
This repo contains a Dockerfile for the [3D City Database Web-Map-Client (3D web client)](https://github.com/3dcitydb/3dcitydb-web-map/) based on the official [Node.js Docker images](https://hub.docker.com/_/node/). To get the 3D web client Docker images visit the [tumgis/3dcitydb-web-map](https://hub.docker.com/r/tumgis/3dcitydb-web-map/) DockerHub page. To get things moving fast take a look the *Quick start* section.

#### Special features
* *Landing page* and *data listing* for convenient 3D web client project creation

#### Image versions/tags
* **latest** - Latest stable version based on latest version of the 3D web client. Built from [master](https://github.com/tum-gis/3dcitydb-web-map-docker/tree/master) branch.
* **devel** - Development version containing latest features. Built from [devel](https://github.com/3dcitydb/3dcitydb-web-map/tree/devel) branch.
* **experimental** - Development version containing latest features. Built from [experimental](https://github.com/3dcitydb/3dcitydb-web-map/tree/experimental) branch. The latest commit of the [3DCityDB Web-Map-Client Github master branch](https://github.com/3dcitydb/3dcitydb-web-map/tree/master) is used for this build.
* **v1.0.0**, **v1.4.0** - Same content as **latest** image, but built with a specific version (**vX.X.X**) of the 3DCityDB Web-Map-Client. Built from the branches named like the versions.

Use `docker pull tumgis/3dcitydb-web-map:TAG` to download the latest version of the image with the specified `TAG` to your system.

#### More 3DCityDB Docker Images
Besides the Docker images form this repo images for the *3D City Database* and the *3D City Database Web Feature Service (WFS)* are available:
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

## Sharing data across multiple platforms (Windows, MacOS, Linux, etc.)
The 3DCityDB-Web-Map-Client Docker image also allows sharing data between different machines and operating systems such as Windows, MacOS, Linux, etc. using [Samba](https://en.wikipedia.org/wiki/Samba_(software)), which is a free software re-implementation of the SMB/CIFS networking protocol. Samba provides file and print services for various Microsoft Windows clients and can integrate with a Microsoft Windows Server domain, either as a Domain Controller (DC) or as a domain member.

To enable Samba:
```bash
docker run -dit --name 3dwebmap-container -p 80:8000 -p 139:139 -p 445:445 \
   -v /home/docker/data/:/var/www/data/ \
tumgis/3dcitydb-web-map \
	-u "username;password!" \
   -s "smb_shared;/var/www/data/;yes;no;yes;all;username;username;comment"
```
where:
+ The ports 139 and 445 are reserved for the Samba service. Do <b>not</b> change these numbers on Windows host machines.
+ In this example, the container data located in `/var/www/data` are mounted to `/home/docker/data` on the host machine using the [bind mount](https://docs.docker.com/storage/bind-mounts/) method.
+ The Samba service in this image is installed and configured based on [dperson/samba](https://github.com/dperson/samba). Optional Samba arguments can be provided in run-time, such as user credentials (parameter `-u`) and share information (parameter `-s`). These can be configured using the following syntax taken from [dperson/samba](https://github.com/dperson/samba):
   ```
   Options (fields in '[]' are optional, '<>' are required):
       -h               
                        This help
       -c "<from:to>"   
                        Setup character mapping for file/directory names
                        required arg: "<from:to>" character mappings separated by ','
       -g "<parameter>" 
                        Provide global option for smb.conf
                        required arg: "<parameter>" - IE: -g "log level = 2"
       -i "<path>"      
                        Import smbpassword
                        required arg: "<path>" - full file path in container
       -n               
                        Start the 'nmbd' daemon to advertise the shares
       -p               
                        Set ownership and permissions on the shares
       -r               
                        Disable recycle bin for shares
       -S               
                        Disable SMB2 minimum version
       -s "<name;/path>[;browse;readonly;guest;users;admins;writelist;comment]"
                        Configure a share
                        required arg: "<name>;</path>"
                        <name> is how it's called for clients
                        <path> path to share
                        NOTE: for the default values, just leave blank
                        [browsable] default:'yes' or 'no'
                        [readonly] default:'yes' or 'no'
                        [guest] allowed default:'yes' or 'no'
                        [users] allowed default:'all' or list of allowed users
                        [admins] allowed default:'none' or list of admin users
                        [writelist] list of users that can write to a RO share
                        [comment] description of share
       -u "<username;password>[;ID;group]"       
                        Add a user
                        required arg: "<username>;<passwd>"
                        <username> for user
                        <password> for user
                        [ID] for user
                        [group] for user
       -w "<workgroup>"       
                        Configure the workgroup (domain) samba should use
                        required arg: "<workgroup>"
                        <workgroup> for samba
       -W          
                        Allow access wide symbolic links
   ```

+ Once the container has been started and Samba is running, the shared directory can be accessed using the following commands:
   + In Windows:
   ```bash
   net use <disk_drive>: \\<SERVER>\smb_shared
   ```
   where the `<disk_drive>` can be an arbitrary unoccupied letter (e.g. `R`) and `SERVER` is the name or IP address of the host machine, where the container is being hosted. The latter can be found using the command `ifconfig` or `ipconfig`.
   
   Once the connection has been established, open the shared folder in Windows Explorer and create a new text file `Test.txt`. This text file should now also be visible on the web client (e.g. `http://myDockerHost/data/`) as shown below:
   <p align="center">
    	<img src="/images/SambaTest.png" width="50%" />
   </p>

   + In Linux:
   ```bash
   # 1. Install Samba utils
   sudo apt-get install cifs-utils
   # 2. Create a local directory to mount shared data
   mkdir local_smb_shared
   # 3. Mount the shared data to this directory
   sudo mount.cifs //<SERVER>/smb_shared \
      local_smb_shared -o user=username
   ```

   + In MacOS:
   ```bash
   mount_smbfs //username@<SERVER>/smb_shared /local_smb_shared
   ```

+ To unmount the shared directory from the local machine (source data will not be removed):
   + In Windows: Enter
   ```bash
   net use <disk_drive>: /Delete
   ```

   + In Linux:
   ```bash
   umount //<SERVER>/smb_shared
   ```

   + In MacOS:
   ```bash
   umount /local_smb_shared
   ```

To disable Samba, simply remove the Samba parameters from the `docker run` command:
```bash
docker run -dit --name 3dwebmap-container -p 80:8000 \
   -v /home/docker/data/:/var/www/data/ \
tumgis/3dcitydb-web-map
```

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
| baseimage_tag           | Tag of the Node.js image to use. A list of all available tags is available [here](https://hub.docker.com/_/node/). | *9* |
| webmapclient_version    | Version of the 3DCityDB-Web-Map-Client to build. Any branch name or tag from the [3DCityDB-Web-Map-Client GitHub](https://github.com/3dcitydb/3dcitydb-web-map/) repo can be used.            | *v1.4.0*           |

> **Note:**  
> The build process has been tested with the `node:9` base image and `v1.4.0` of the 3DCityDB-Web-Map-Client so far.
 
Build example:
```bash
docker build \
    --build-arg "baseimage_tag=9-slim" \
    --build-arg "webmapclient_version=master" \
  -t tumgis/3dcitydb-web-map:9-slim-master .
```

