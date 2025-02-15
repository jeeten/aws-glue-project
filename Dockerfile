# Use the official AWS Glue image as the base
FROM amazon/aws-glue-libs:glue_libs_4.0.0_image_01

# Set the working directory
WORKDIR /home/glue_user/workspace

# Copy local scripts and dependencies into the container
COPY ./workspace /home/glue_user/workspace
#COPY ./requirements_3.10.txt /home/glue_user/workspace/

# Install any additional Python dependencies
#RUN pip3 install --no-cache-dir -r /home/glue_user/workspace/requirements_3.10.txt

# Expose ports for Spark UI and Glue UI
EXPOSE 4040
EXPOSE 18080

# Keep the container running
CMD ["/bin/bash"]