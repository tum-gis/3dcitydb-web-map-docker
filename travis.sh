#!/bin/bash
#------------------------------------------------------------------------------
# FUNCTIONS -------------------------------------------------------------------
#------------------------------------------------------------------------------

# compose Docker image tag ----------------------------------------------------
getTag() {
  temp=""

  # find tag prefix: master -> "", devel -> "devel"
  if [[ "$TRAVIS_BRANCH" == "devel" ]]; then
    temp="devel-"
  fi

  os=""
  # determine os debian -> "", alpine -> "alpine"
  if [[ "$dockerfile" == "alpine" ]]; then
    temp="${temp}alpine-"
  fi

  # append tag
  temp="${temp}${1}"
  echo "$temp"
}

# compose full image name (repo + image name + tag) ---------------------------
getImageName() {
  echo "${repo_name}/${image_name}:$(getTag ${1})"
}

# build Docker image ----------------------------------------------------------
build() {
  # build image
  docker build --build-arg baseimage_tag=${baseimage_tag} \
            --build-arg webmapclient_version=${webmapclient_version} \
            -t "temp:temp" \
            ${dockerfile}
}

# run Docker container --------------------------------------------------------
runContainer() {    
  docker run --name webcl -d -p 8000:8000 "temp:temp"
}

# deploy ----------------------------------------------------------------------
deploy() {  
  # deploy if not a pull request and branch is master or devel
  if [[ "$TRAVIS_PULL_REQUEST" == "false" && \
      ( "$TRAVIS_BRANCH" == "master" || "$TRAVIS_BRANCH" == "devel" ) ]]; then

      # login to docker hub
      echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

      # create tags and push to docker hub
      for str in ${tag//,/ } ; do
        docker tag "temp:temp" "$(getImageName ${str})"
        docker push "$(getImageName ${str})"
      done    
  fi
}

# cleanup ---------------------------------------------------------------------
cleanup() {
  docker rm -fv webcl
  docker rmi -f "temp:temp"
  # create tags and remove images  
  for str in ${tag//,/ } ; do
    docker rmi -f "$(getImageName ${str})"
  done
}

#------------------------------------------------------------------------------
# MAIN SCRIPT -----------------------------------------------------------------
#------------------------------------------------------------------------------

# Check if the function exists (bash specific)
if declare -f "$1" > /dev/null
then
  # call arguments verbatim
  "$@"
else
  # Show a helpful error
  echo "'$1' is not a known function name" >&2
  exit 1
fi
