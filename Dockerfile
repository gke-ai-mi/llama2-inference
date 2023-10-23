
FROM nvcr.io/nvidia/tritonserver:23.08-py3
WORKDIR /model_repository
COPY requirements.txt ./
RUN python3 -m pip install --upgrade pip
RUN pip3 install -r requirements.txt

COPY model_repository/llamav2 ./llamav2