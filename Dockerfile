
FROM nvcr.io/nvidia/tritonserver:23.08-py3
WORKDIR /model_repository
COPY requirements.txt ./
RUN python3 -m pip install --upgrade pip
RUN pip install -r requirements.txt

COPY python_backend/model_repository/llamav2 ./llamav2