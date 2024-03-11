# Solution GKE Observability Workshop LAB-07

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

* Position yourself in the lab folder.
```
cd ~/gke-observability-workshop/lab-07
```

* You can check a [JSON template](./monitoring/dashboard.json) with the dashboard layout here.

* Validate the dashboard using the template.
```
gcloud monitoring dashboards create --validate-only --config-from-file ./monitoring/dashboard.json
```

* Create the Google Cloud Monitoring dashboard using the template.
```
gcloud monitoring dashboards create --config-from-file ./monitoring/dashboard.json
```

* Replace `PROJECT_ID_VALUE` in the [worker service definition](./monitoring/service-definition.json) spec template using the following command.
```
find . -type f -exec sed -i s/PROJECT_ID_VALUE/$CLOUDSDK_CORE_PROJECT/ {} +
```

* Create the [worker service](https://cloud.google.com/stackdriver/docs/solutions/slo-monitoring/api/using-api#service-create) using the Google Cloud API.
```
ACCESS_TOKEN=$(gcloud auth print-access-token)
SERVICE_ID=worker-service
curl  --http1.1 --header "Authorization: Bearer ${ACCESS_TOKEN}" --header "Content-Type: application/json" -X POST -d @monitoring/service-definition.json https://monitoring.googleapis.com/v3/projects/${PROJECT_ID}/services?service_id=${SERVICE_ID}
```