
FROM nvcr.io/nvidia/tritonserver:23.10-py3 as builder
RUN mkdir -p /home/triton-server/app
WORKDIR /home/triton-server/app
COPY requirements.txt ./
RUN python3 -m pip install  --user --upgrade pip
RUN python3 -m pip install  --user -r requirements.txt
#WORKDIR /usr/local
#RUN chown triton-server:triton-server /usr/local/nvidia
FROM nvcr.io/nvidia/tritonserver:23.10-py3
WORKDIR /home/triton-server/app/.local
COPY --from=builder /root/.local /home/triton-server/app/.local
ENV LD_LIBRARY_PATH /home/triton-server/app/.local/bin:/home/triton-server/app/.local/lib:/opt/hpcx/ucc/lib/:/opt/hpcx/ucx/lib/:/opt/tritonserver/backends/onnxruntime:/usr/local/cuda/compat/lib:/usr/local/cuda/lib64

