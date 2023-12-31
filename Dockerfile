# Use an official PyTorch base image with GPU support
FROM pytorch/pytorch:1.9.0-cuda11.1-cudnn8-runtime

# Set the working directory in the container
WORKDIR /app

# Install required system packages
RUN apt-get update && apt-get install -y \
    git \
    libopencv-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone the AlphaPose repository
RUN git clone https://github.com/MVIG-SJTU/AlphaPose.git

# Change to the AlphaPose directory
WORKDIR /app/AlphaPose

# Install Python dependencies
RUN pip install -r requirements.txt

# (Optional) Download the COCO 2017 dataset if needed
# RUN wget http://images.cocodataset.org/zips/train2017.zip
# RUN unzip train2017.zip -d /app/AlphaPose/data/coco/images/train2017/

# Copy your customized dataset and configuration files into the container
COPY custom_dataset /app/custom_dataset
COPY custom_config.yaml /app/AlphaPose/configs/custom_config.yaml

# Expose any necessary ports
# EXPOSE 8090

# Set environment variables (if needed)
# ENV MY_VARIABLE=value

# Command to run AlphaPose on your dataset
CMD ["python", "tools/demo.py", "--cfg", "configs/custom_config.yaml", "--indir", "custom_dataset/images", "--outdir", "output"]
