# terraform-gcp-gke-openvpn
Module for OpenVPN via Terraform in Google Cloud Platform using GKE (Kubernetes)

## Intro

This repo is a practical implementation containing everything needed to stand up a personal VPN on Google Cloud with GCE/Docker.  Google Cloud Platform (GCP) offers an attractive always free tier that makes the idea of learning their stack appealing.  I became interested in using GCP for a free personal VPN a few months back and finally had some time to carve off to play around with this.

We will be using the docker-machine google driver and docker compose for our OpenVPN deployment.

## Instructions

First, make sure you have the prerequisite software:

```
jq                    - https://stedolan.github.io/jq/download
docker engine         - https://www.docker.com/community-edition
docker machine        - https://docs.docker.com/machine/install-machine/
terraform 0.9.6*      - https://www.terraform.io/downloads.html
```

### GCP initial setup

First thing to do is create a GCP account if you don't have one.  Then go setup a project and get your credentials.  If you name your project "terraform-gcp-openvpn" you won't have to change inputs for that.
I followed the steps here to setup my GCP credentials:

https://www.terraform.io/docs/providers/google/

Afterwards run:
```
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/keyfile.json"
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
gcloud init --quiet
```

### Terraform

We use terraform to provision everything.  This is a multistep process because there are some issues with Terraform and GCP integration at the moment.

First create an env file which will contain your credentials.  You can omit this step but you will be asked for the creds each time you run the terraform command.

```
echo "cluster_master_username=\"theuser\"" > env.tfvars
echo "cluster_master_password=\"thepassword\"" >> env.tfvars
```

Prepare for provisioning by loading the built in modules:

`terraform get`

To see what will be created:

`terraform plan -var-file=env.tfvars`

#### Provision the infrastructure

1.  First, allow API access for Terraform.  Currently this is the only way to do this for the servicemanagement API.
   go here: https://console.developers.google.com/apis/api/servicemanagement.googleapis.com/overview?project=terraform-gcp-gce-openvpn
   click enable it it is not enabled already

   Note, there is code in the project to do this automatically but currently this is not allowed by Google so you will see a failure if you don't do this manually.


# WIP notes:

From here:
https://docs.docker.com/machine/drivers/gce/

Stand up an instance running docker:
export GOOGLE_APPLICATION_CREDENTIALS=$HOME/.gcp/terraform-gcp-gce-openvpn.json
docker-machine create --driver google \
        --google-project terraform-gcp-gce-openvpn \
        --google-machine-type f1-micro \
        --google-zone us-east1-b \
        --google-network openvpn-network \
        --google-subnetwork openvpn-subnet \
        dm-openvpn




docker-machine rm  dm-openvpn
