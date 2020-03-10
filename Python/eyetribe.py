import socket
import json
import numpy
from datetime import datetime

def connect(port=6555):
    serverAddress = ("localhost", port) # Setup server ip and port, by defaul it uses localhost
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM) # Initialise socket object
    sock.connect(serverAddress) # Connect socket to server
    sock.recv(1024) # Get response
    sock.settimeout(10) # Limit timeout to 10 seconds

    return sock

def disconnect(sock):
    sock.close() # Close the socket

def getval(sock):
    try:
        sock.sendall('{"category": "tracker", "request": "get", "values": ["frame"]}') # Send request to socket
        raw = sock.recv(1024) # Get data back from socket
        parsed = json.JSONDecoder(raw) # Parse json data to a dict
        val = parsed.values.frame # Remove extraneous layers
        val.timestamp = datetime(val.timestamp) # Convert timestamps to datetime format
    except: # If request fails...
        val = numpy.nan # Set value to NaN
        print("Warning: Could not get value from senor") # Issue warning
    return val

