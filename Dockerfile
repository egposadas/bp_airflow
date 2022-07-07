# syntax=docker/dockerfile:1
FROM artifactory.teslamotors.com:2153/atm-baseimages/python:3.9-xray
RUN mkdir /root/.pip/
RUN echo "[global]" >> /root/.pip/pip.conf
RUN echo "index-url = https://pypi.teslamotors.com/simple" >> /root/.pip/pip.conf
RUN python -m pip install --upgrade pip
WORKDIR /app
COPY requirements.txt .
RUN python -m pip install -r requirements.txt
COPY . .
ENV AIRFLOW_HOME=/app
ENV AIRFLOW__CORE__LOAD_EXAMPLES=False
ENTRYPOINT ["airflow", "standalone"]
