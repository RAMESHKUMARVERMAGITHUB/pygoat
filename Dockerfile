FROM python:3.11.0b1-buster

# set work directory
WORKDIR /app

# dependencies for psycopg2
RUN apt-get update && apt-get install --no-install-recommends -y \
    dnsutils \
    libpq-dev=11.16-0+deb10u1 \
    python3-dev=3.7.3-1 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install dependencies
RUN python -m pip install --no-cache-dir pip==22.0.4
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install gunicorn  # Install gunicorn

# copy project
COPY . /app/

# install pygoat
EXPOSE 8000

# Run migrations
RUN python manage.py migrate

# Set the entrypoint
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "6", "pygoat.wsgi:application"]





# # Use an official Python runtime as a parent image
# FROM python:3.11.0b1-buster

# # Set environment variables
# ENV PYTHONDONTWRITEBYTECODE 1
# ENV PYTHONUNBUFFERED 1

# # Set the working directory in the container
# WORKDIR /app

# # Clone the PyGoat repository from GitHub
# RUN git clone https://github.com/adeyosemanputra/pygoat.git .

# # Install PyGoat and its dependencies
# RUN bash installer.sh

# # Apply migrations
# RUN python3 manage.py migrate

# # Expose port 8000 to the outside world
# EXPOSE 8000

# # Command to run the PyGoat server
# CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]

