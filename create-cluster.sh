# for tesla-t4
#gcloud container clusters create llama2-inference-cluster --num-nodes=2     --zone=us-west1-b     --accelerator="type=nvidia-tesla-t4,count=2,gpu-driver-version=default"  --machine-type="n1-standard-8"  --enable-private-nodes --master-ipv4-cidr 172.16.0.32/28  --enable-ip-alias --scopes="gke-default,storage-rw"


# for L4
export REGION=us-west1
export PROJECT_ID=$(gcloud config get project)

gcloud container clusters create llm-inference-t4 --location ${REGION} \
  --workload-pool ${PROJECT_ID}.svc.id.goog \
  --enable-image-streaming --enable-shielded-nodes \
  --shielded-secure-boot --shielded-integrity-monitoring \
  --enable-ip-alias \
  --node-locations=$REGION-a \
  --workload-pool=${PROJECT_ID}.svc.id.goog \
  --addons GcsFuseCsiDriver   \
  --no-enable-master-authorized-networks \
  --machine-type n2d-standard-4 \
  --num-nodes 1 --min-nodes 1 --max-nodes 5 \
  --ephemeral-storage-local-ssd=count=2 \
  --enable-ip-alias \
  --enable-private-nodes  \
  --master-ipv4-cidr 172.16.0.32/28

gcloud container node-pools create llm-inference-t4 --cluster llm-inference-t4 \
  --accelerator type=nvidia-tesla-t4,count=2,gpu-driver-version=latest \
  --machine-type n1-standard-8 \
  --ephemeral-storage-local-ssd=count=2 \
  --enable-autoscaling --enable-image-streaming \
  --num-nodes=0 --min-nodes=0 --max-nodes=3 \
  --shielded-secure-boot \
  --shielded-integrity-monitoring \
  --node-locations $REGION-a,$REGION-b --region $REGION --spot