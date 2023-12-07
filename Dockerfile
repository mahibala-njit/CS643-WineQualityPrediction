# Base image - Ubuntu
FROM ubuntu:latest

# Update packages and install required dependencies
RUN apt-get update && apt-get install -y \
    openjdk-8-jdk \
    python3 \
    python3-pip \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV SPARK_HOME=/opt/spark
ENV PATH=$SPARK_HOME/bin:$PATH
ENV PYSPARK_PYTHON=python3

# Download and install Spark
RUN wget -qO- https://downloads.apache.org/spark/spark-3.3.3/spark-3.3.3-bin-hadoop3.tgz | tar xvz -C /opt \
    && mv /opt/spark-3.3.3-bin-hadoop3 $SPARK_HOME \
    && chown -R root:root $SPARK_HOME

# Set up working directory
WORKDIR /app

# Copy the Python script and requirements file
COPY prediction.py /app/
COPY requirements.txt /app/

# Install dependencies
RUN pip install --upgrade pip && pip install -r requirements.txt
RUN chmod 774 *

# Start application
CMD ["spark-submit", "prediction.py"]