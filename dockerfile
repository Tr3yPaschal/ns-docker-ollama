# Use the official NVIDIA Jetson Nano base image
FROM nvcr.io/nvidia/l4t-base:r32.5.0

# Set the working directory in the container
WORKDIR /app

# Install necessary tools and dependencies
RUN apt-get update && apt-get install -y \
    pciutils \
    lshw \
    wget \
    curl \
    gnupg2 \
    ca-certificates \
    software-properties-common

# Remove conflicting cuda-archive-keyring.gpg if it exists
RUN rm -f /usr/share/keyrings/cuda-archive-keyring.gpg

# Fetch and add the NVIDIA public GPG key for CUDA repository (Ubuntu 18.04)
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub

# Add NVIDIA CUDA repository
RUN echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list

# Update package lists and install CUDA toolkit
RUN apt-get update && apt-get install -y cuda

# Install Python and pip
RUN apt-get install -y python3 python3-pip

# Upgrade pip
RUN python3 -m pip install --upgrade pip

# Install any needed packages specified in requirements.txt
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Copy the current directory contents into the container at /app
COPY . /app

# Make port 5000 and 11434 available to the world outside this container
EXPOSE 5000
EXPOSE 11434

# Define environment variable
ENV NAME World

# Run app.py when the container launches
CMD ["python3", "app.py"]
