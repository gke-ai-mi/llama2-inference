gcloud container clusters create pytorch-training-cluster     --num-nodes=2     --zone=us-west1-b     --accelerator="type=nvidia-t4,count=2,gpu-driver-version=default"  --machine-type="n1-standard-8"     --scopes="gke-default,storage-rw"