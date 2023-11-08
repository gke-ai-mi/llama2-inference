# GKE AI/ML infra: Llama2 inference setup using Nvidia Triton Inference Server

Serving Llama 2 models on GKE GPUs through Nvidia Triton Inference Server

Triton Inference Server

Triton Inference Server enables teams to deploy any AI model from multiple deep learning and machine learning frameworks, including TensorRT, TensorFlow, PyTorch, ONNX, OpenVINO, Python, RAPIDS FIL, and more. Triton supports inference across cloud, data center, edge and embedded devices on NVIDIA GPUs, x86 and ARM CPU, or AWS Inferentia. Triton Inference Server delivers optimized performance for many query types, including real time, batched, ensembles and audio/video streaming. Triton inference Server is part of NVIDIA AI Enterprise, a software platform that accelerates the data science pipeline and streamlines the development and deployment of production AI.

Major features include:

Supports multiple deep learning frameworks

Supports multiple machine learning frameworks

Concurrent model execution

Dynamic batching

Sequence batching and implicit state management for stateful models

Provides Backend API that allows adding custom backends and pre/post processing operations

Model pipelines using Ensembling or Business Logic Scripting (BLS)

HTTP/REST and GRPC inference protocols based on the community developed KServe protocol

A C API and Java API allow Triton to link directly into your application for edge and other in-process use cases

Metrics indicating GPU utilization, server throughput, server latency, and more



## Summary:
This tutorial walks through how to setup Llama2 and other hugging face based LLM models through Nvidia Inference Server based on GKE and GPU(Nvidia T4, L4 etc)

## Tutorial steps:

### Prerequisites
Huggingface account settings with HF API Token. You also need to have access permission granted for Llama2 LLM models. 
GCP project and access
### Download the github repo, https://github.com/gke-ai-mi/llama2-inference/
```
git clone https://github.com/gke-ai-mi/llama2-inference/
cd $PWD/llama2-inference
chmod +x create-cluster.sh
```
### Create the GKE cluster
update the create-cluster.sh script with write parameters, and provision GKE cluster
comment out the following lines if you need public instead of private cluster:
  --enable-ip-alias \
  --enable-private-nodes  \
  --master-ipv4-cidr 172.16.0.32/28 \
  --scopes="gke-default,storage-rw"

```
./create-cluster.sh
```
### Update and upload the Llama 2 Model repository files.

Run the following commands to upload model repository, replace your-bucket-name
```
gsutil mb gs://your-bucket-name
gsutil cp model_repository/llama2 -r gs://your-bucket-name/model_repository/llama2
```

### Run cloud build to create container images:
1 Create a Artifact Registry repo, us-east1-docker.pkg.dev/rick-vertex-ai/triton-llm 
2 Run following command to build Llama2 Inference container through vLLM engine,
```
cd python-backend
gcloud builds submit .
```
3 Run following command to build testing client container to test llama 2 batch inference:

```
cd python-backend/client
gcloud builds submit .
```
### Deploy kubernetes resources into GKE cluster
Update the following line in llama2-gke-deploy.yaml file, with your model repository URI in cloud storage:

args: ["tritonserver", "--model-store=gs://triton-inference-llm-repos/model_repository"
Execute the command to deploy inference deployment in GKE, update the HF_TOKEN values

```
gcloud container clusters get-credentials llama2-inference-cluster --zone us-west1-b
export HF_TOKEN=<paste-your-own-token>
kubectl create secret generic llama2 --from-literal="HF_TOKEN=$HF_TOKEN" -n triton
kubectl apply -f llama2-gke-deploy.yaml -n triton
```
### Test out the batch inference:
```
kubectl run -it -n triton --image us-east1-docker.pkg.dev/rick-vertex-ai/triton-llm/llama2-client bash 
```

Once you in the container, update the client.py with the endpoint with the Service IP of generated. 
Then run the following command inside the testing container:
```
python3 client.py
```
If everything runs smoothly, there will be a results.txt file generated, you may check the contents of 

### Note for vLLM:
vLLM has been tested out, with faster performance, with a little bit different setup
#### Update deployment file
Update llama2-gke-deploy.yaml, container image: nvcr.io/nvidia/tritonserver:23.10-vllm-python-py3
#### Upload model directory to Cloud Storage:
gsutil cp model_repository/vllm -r gs://your-bucket-name/model_repository/vllm

### Test out the batch inference:
Run following command to build testing client container to test llama 2 batch inference:

```
cd vllm/client
gcloud builds submit .

```
kubectl run -it -n triton --image us-east1-docker.pkg.dev/rick-vertex-ai/triton-llm/vllm-client bash 
```

Once you in the container, update the client.py with the endpoint with the Service IP of generated. 
Then run the following command inside the testing container:
```
python3 client.py
```
If everything runs smoothly, there will be a results.txt file generated, you may check the contents






