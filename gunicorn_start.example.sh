#!/bin/bash

# Name of the application
NAME="matchminer_patient_app"
# Directory where the application code is located
FLASKDIR=/path/to/matchminer-patient
# User and group to run the application as
#USER=your_linux_user
#GROUP=your_linux_group
# Number of Gunicorn worker processes
NUM_WORKERS=3
# The host and port Gunicorn will bind to (should be a local socket in production)
# Use a Unix socket for secure and fast communication with Nginx.
  BIND_SOCK=unix:$FLASKDIR/gunicorn.sock
  
# The WSGI module to run
WSGI_MODULE=wsgi:app

echo "Starting $NAME as `whoami`"

# Activate the virtual environment
cd $FLASKDIR

# Set environment variables if you are using a .env file
export $(cat .env | xargs)

# Create the run directory if it doesn't exist
RUNDIR=$(dirname $BIND_SOCK)
test -d $RUNDIR || mkdir -p $RUNDIR

# Start Gunicorn


# Start Gunicorn
echo "BIND_SOCK value: $BIND_SOCK"
echo "Full gunicorn command: gunicorn ${WSGI_MODULE} --name $NAME --workers $NUM_WORKERS --timeout 120 --bind=$BIND_SOCK --log-level=info --log-file=-"

exec gunicorn ${WSGI_MODULE} --name $NAME --workers $NUM_WORKERS --timeout 180 --bind=$BIND_SOCK --log-level=info --log-file=-
