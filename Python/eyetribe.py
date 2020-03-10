import socket
import json
import numpy
from datetime import datetime
from win32api import GetSystemMetrics
from matplotlib import path
from shapely.geometry import Point, Polygon


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
                'Height': h.values.screenresh
                }
    
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

def roi(name, x, y, screen={'Width': GetSystemMetrics(0), 'Height': GetSystemMetrics(1)}):
    #if screen is roi.__defaults__[3]: # If screen is default
    #    print('Warning: Screen info not supplied, defaulting to dimensions of current screen') # Warn user
    if isinstance(x, (list, tuple)) and isinstance(y, (list, tuple)) and len(x) == len(y): # If x and y are both lists/tuples of the same length...
        if all(isinstance(n, (int, float)) for n in x) and all(isinstance(n, (int, float)) for n in y): # If the contents of x and y are entirely numeric...
            pass # Continue
        else: # If x and y are lists/tuples of the same length but are not numeric...
            raise Exception('x and y must be list or tuple of numeric values of the same length') # Raise error for wrong input
    else: # If x and y are not both lists/tuples of the same length...
        raise Exception('x and y must be list or tuple of numeric values of the same length') # Raise error for wrong input
        
    if all(n<=1 & n>=-1 for n in x): # If all x values are between -1 and 1...
        if any(n<0 for n in x): # If any values are negative...
            x = tuple((n+1)/2 for n in x) # Transform values to positive
    x = tuple(n*screen['Width'] for n in x) # Transform values from relative to absolute
    
    if all(n<=1 & n>=-1 for n in y): # If all y values are between -1 and 1...
        if any(n<0 for n in y): # If any values are negative...
            y = tuple((n+1)/2 for n in y) # Transform values to positive
    y = tuple(n*screen['Width'] for n in y) # Transform values from relative to absolute
    

    roi = {
            'Class': 'roi',
            'Name': name,
            'x': tuple(x),
            'y': tuple(y) 
            }
    
    return roi

def isroi(data, *rois):
    eye_array = ["avg" "raw" "lefteye.avg" "lefteye.raw" "righteye.avg" "righteye.raw"]; # Specify possible eyes data could come from
    
    roi_array = list();
    for r in rois:
        if isinstance(r, dict):
            if 'Class' in r.keys():
                if r['Class'] == 'roi':
                    roi_array.append(r)
    
    for row in range(len(data)):
        for r in roi_array:
            roi_poly = Polygon((r['x'][n], r['y'][n]) for n in range(len(r['x'])))
            for e in eye_array:
                p = Point(data[row][e]['x'], data[row][e]['y'])
                data[row]['ROI_'+r['Name']][e] = p.within(roi_poly)
    
    return roi_array