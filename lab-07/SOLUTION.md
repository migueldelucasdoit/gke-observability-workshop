## GKE Monitoring and Alerting

[![Context](https://img.shields.io/badge/GKE%20Observability%20Workshop-07-blue.svg)](#)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)


## Steps

* Set the [*CLOUDSDK_CORE_PROJECT*](https://cloud.google.com/compute/docs/gcloud-compute#default_project) environment variable to your GCP project ID.
```
export CLOUDSDK_CORE_PROJECT=$(gcloud config get-value project)
```

* Set the [default compute region](https://cloud.google.com/compute/docs/gcloud-compute#set-default-region-zone-environment-variables) environment variable to `europe-west6`.
```
export CLOUDSDK_COMPUTE_REGION=europe-west6
```

* Set the [default compute zone](https://cloud.google.com/compute/docs/gcloud-compute#set-default-region-zone-environment-variables) environment variable to `europe-west6-a`.
```
export CLOUDSDK_COMPUTE_ZONE=europe-west6a
```

* Position yourself in the lab folder.
```
cd ~/gke-observability-workshop/lab-07
```

TODO