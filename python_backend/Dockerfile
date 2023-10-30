
FROM nvcr.io/nvidia/tritonserver:23.09-py3 as builder
RUN mkdir -p /home/triton-server/app
WORKDIR /home/triton-server/app
COPY requirements.txt ./
RUN python3 -m pip install  --user --upgrade pip
RUN python3 -m pip install  --user -r requirements.txt
RUN chmod -R a+x /usr/local/nvidia

COPY . .
FROM nvcr.io/nvidia/tritonserver:23.09-py3 
WORKDIR /home/triton-server/app/.local
COPY --from=builder /root/.local /home/triton-server/app/.local