# llama2-inference

Serving Llama 2 models on GKE GPUs through Nvidia Inference Server

## Summary:
This tutorial walks through how to setup Llama2 and other hugging face based LLM models through Nvidia Inference Server based on GKE and GPU(Nvidia T4, L4 etc)

## Tutorial steps:

### Prerequisites
Huggingface account settings. You also need to have access permission granted for Llama2 LLM models. 
GCP project and access
### Download the github repo, https://github.com/gke-ai-mi/llama2-inference/
```
git clone https://github.com/gke-ai-mi/llama2-inference/
cd $PWD/llama2-inference
chmod +x create-cluster.sh
```
### Create the GKE cluster
update the create-cluster.sh script with write parameters, and provision GKE cluster
```
./create-cluster.sh
```
### Update and upload the Llama 2 Model repository files.
Update model.py file under model_repository/vllm/1/model.py:
In line 16, update huggingface API token you get from your Huggingface account settings. You also need to have access permission granted for Llama2 LLM models. 

Run the following commands to upload model repository, replace your-bucket-name
```
gsutil mb gs://your-bucket-name
gsutil cp model_repository/vllm -r gs://your-bucket-name/model_repository/vllm
```

### Run cloud build to create container images:
1 Create a Artifact Registry repo, us-east1-docker.pkg.dev/rick-vertex-ai/triton-llm 
2 Run following command to build Llama2 Inference container through vLLM engine,
```
cd vLLM
gcloud builds submit .
```
3 Run following command to build testing client container to test llama 2 batch inference:

```
cd vLLM/client
gcloud builds submit .
```
### Deploy kubernetes resources into GKE cluster

```
gcloud container clusters get-credentials llama2-inference-cluster --zone us-west1-b
kubectl apply -f llama2-gke-deploy.yaml -n triton
```
### Test out the batch inference:
```
kubectl run -it --images us-east1-docker.pkg.dev/rick-vertex-ai/triton-llm/vllm-client bash 
```

Once you in the container, update the client.py with the endpoint with the Service IP of generated. 
Then run the following command inside the testing container:
```
python3 client.py
```
If everything runs smoothly, there will be a results.txt file generated, you may check the contents of 







