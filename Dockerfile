
FROM nvcr.io/nvidia/tritonserver:23.08-py3
WORKDIR /model_repository
COPY requirements.txt ./
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install -r requirements.txt

COPY model_repository/llamav2 ./llamav2

FROM nvcr.io/nvidia/tritonserver:23.09-py3 as builder
RUN mkdir -p /home/triton-server/app
WORKDIR /home/triton-server/app
COPY requirements.txt ./
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install -r requirements.txt

COPY . .
FROM nvcr.io/nvidia/tritonserver:23.09-py3 
WORKDIR /home/triton-server/app/.local
COPY --from=builder /root/.local /home/triton-server/app/.local