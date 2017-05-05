# Openshift quickstart

This quickstart will help get a local minishift environment up and going. After 
completing the steps below, it will be possible to deploy the UofA projects quickly
and easily by following the corresponding OPENSHIFT_QUICKSTART.md in their repos.

## Prerequisites

* minishift installed - https://github.com/minishift/minishift
* A key with no password added in gitlab. E.g. jenkins user or your own key.
* oc command must be available.
```
sudo ln -sf $(find ~/.minishift -name oc -type f | tail -1) /usr/local/bin/oc
```
* Must have a clone of git@gitlab.adelaide.edu.au:web-team/s2i-shepherd-drupal.git and be in that directory.

## Configure OpenShift for building.

* Supply your deployment key - something like:
```
export KEY_FILE=~/uni/keys/jenkins_deployment_key/id_rsa
```

* And export a few other settings.
```
export KEY_NAME=deployment-key
export IMAGE=uofa/s2i-drupal
```

* Now for the real action. Start minishift, setup docker and build the s2i 
image in minishift, then revert to std local docker settings.
```
minishift start
eval $(minishift docker-env)
docker build -t ${IMAGE} .
eval $(minishift docker-env --unset)
```

* Grab the CA from timelord, as the UofA is a bit special.
```
scp timelord.services.adelaide.edu.au:/etc/ssl/certs/2014-quovardis-ca.crt \
~/2014-quovardis-ca.crt
```

* Setup our key with the ca so that gitlab cloning works.
```
oc secrets new-sshauth ${KEY_NAME} --ca-cert=${HOME}/2014-quovardis-ca.crt \
--ssh-privatekey=${KEY_FILE}
```
