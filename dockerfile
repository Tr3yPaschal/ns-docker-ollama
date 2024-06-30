# NOTE: Stop Ollama on the local machine
# sudo systemctl stop ollama

# Use an official Python runtime as a parent image
FROM python:3.11

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Upgrade pip
RUN python -m pip install --upgrade pip

# Install necessary tools
RUN apt-get update && apt-get install -y pciutils lshw

# Install the CUDA keyring
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.1-1_all.deb
RUN dpkg -i cuda-keyring_1.1-1_all.deb

# Add NVIDIA CUDA repository
RUN echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/cuda.list

# Update and install CUDA toolkit (adjust version as necessary)
RUN apt-get update && apt-get install -y cuda

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Install ollama-llama3
RUN curl -fsSL https://ollama.com/install.sh | sh

# Make port 5000 available to the world outside this container
EXPOSE 5000
EXPOSE 11434

# Define environment variable
ENV NAME World

# Run app.py when the container launches
CMD ["python", "app.py"]
