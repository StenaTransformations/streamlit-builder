FROM centos/python-36-centos7

MAINTAINER Andreas Ottosson <andreas.ottosson@stena.com>

# Set labels used in OpenShift to describe the builder images
LABEL io.k8s.description="Builder image for Streamlit dashboards." \
      io.k8s.display-name="Streamlit" \
      io.openshift.expose-services=" 8501:http" \
      io.openshift.tags="builder,python,streamlit"

# Switch to root user
USER 0

# Add Prereqs. for pyodbc
RUN curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/mssql-release.repo && \
    ACCEPT_EULA=Y yum install -y e2fsprogs-libs msodbcsql17 && \
    ACCEPT_EULA=Y yum install -y mssql-tools && \
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile && \
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc && \
    source ~/.bashrc && \
    yum install -y unixODBC-devel

# Set the default user for the image, the user itself was created in the base image
USER 1001

# Specify the ports the final image will expose
EXPOSE 8501

# Set the default CMD to print the usage of the image, if somebody does docker run
CMD ["usage"]
