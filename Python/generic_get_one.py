'''

GENERIC GET ONE (sensors)

Author: Edwin Gonzalez Urzua (eddysheikan@GitHub)

This program performs an HTTP GET Request to obtain information about
the sensors using the Python Client. After that, we use a lambda
function to obtain just one specific sensor.

'''

from tetpyclient import RestClient
from credentials import API_ENDPOINT, API_KEY, API_SECRET
import json,argparse
import requests.packages.urllib3

SUPPORTED_GET_ENDPOINTS = ['/sensors','/applications','/users','/vrfs','/assets/cmdb/annotations','/app_scopes','/roles','/switches']
CURRENT_ENDPOINT = '/sensors'

def main():

    requests.packages.urllib3.disable_warnings()

    parser = argparse.ArgumentParser()
    parser.add_argument('host_name', help='Sensor Hostname')
    args = parser.parse_args()
    

    # Create the Rest client 
    rc = RestClient(API_ENDPOINT, api_secret=API_SECRET, api_key=API_KEY, verify=False)

    # Submit a GET for all the sensors
    if args.endpoint in SUPPORTED_GET_ENDPOINTS:
        resp = rc.get(CURRENT_ENDPOINT)

    else:
        print "Not a valid GET endpoint"
        return

    if resp.status_code != 200:
        print "Unsuccessful request returned code: {} , response: {}".format(resp.status_code,resp.text)
    results = resp.json()

    # Obtaining the specific sensor
    one_sensor = filter(lambda x: x["host_name"] == args.host_name, results["results"])

    if hasattr(results, 'results'):
        print json.dumps(one_sensor, indent = 2)
    else:
        print json.dumps(one_sensor, indent = 2)
    return 
    
if __name__ == '__main__':
    main()