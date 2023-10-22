
FROM nvcr.io/nvidia/tritonserver:23.08-py3
COPY requirements.txt ./
RUN python -m pip install --upgrade pip
RUN pip install -r requirements.txt

COPY python_backend/model_repository /opt/tritonserver/model_repository