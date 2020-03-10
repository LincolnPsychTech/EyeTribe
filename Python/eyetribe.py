import socket
import json
import numpy
from datetime import datetime
from win32api import GetSystemMetrics

def connect(port=6555):
    # Create socket
    serverAddress = ("localhost", port) # Setup server ip and port, by defaul it uses localhost
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM) # Initialise socket object
    sock.connect(serverAddress) # Connect socket to server
    sock.settimeout(10) # Limit timeout to 10 seconds
    try:
        # Get screen details
        sock.sendall('{"category": "tracker", "request": "get", "values": ["screenresw"]}') # Send response for screen width
        w_raw = sock.recv(1024) # Get response
        w = json.JSONdecode(w_raw) # Parse response
        sock.sendall('{"category": "tracker", "request": "get", "values": ["screenresh"]}') # Send response for screen height
        h_raw = sock.recv(1024) # Get response
        h = json.JSONdecode(h_raw) # Parse response
    except: # If communication fails
        print('Warning: EyeTribe could not supply screen size. Using Python estimate.')
        w = GetSystemMetrics(0)
        h = GetSystemMetrics(1)
    screen = { # Store results in dict
                'Width': w.values.screenresw,
                'Height': h.values.screenresh}
    
    return sock, screen

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

    