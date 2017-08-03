'''

GENERIC GET

Author: Edwin Gonzalez Urzua (eddysheikan@GitHub)

This program performs an HTTP GET Request to obtain information about
the application scopes using the Python Client. 

An Application Scope will have the following attributes

* id (string). Unique identifier for the application scope.
* short_name (string). User specified name of the application scope.
* name (string). Fully qualified name of the application scope. 
    This is a fully qualified name, i.e. it has name of parent scopes 
    (if applicable) all the way to the root scope.
* parent_app_scope_id (string). ID of the parent application scope.
* short_query (JSON). Filter (or match criteria) associated with the scope.
* query (JSON). Filter (or match criteria) associated with the scope in 
    conjunction with the filters of the parent scopes (all the way to the 
    root application scope).
* vrf_id  integer     ID of the VRF to which scope belongs to.

'''

from tetpyclient import RestClient
from credentials import API_ENDPOINT, API_KEY, API_SECRET
import json

# This /app_scopes resource is defined on the OpenAPI documentation
CURRENT_GET_ENDPOINT = '/app_scopes'

def main():
    # Create the REST Client 
    rc = RestClient(API_ENDPOINT, api_secret=API_SECRET, api_key=API_KEY, verify=False)

    #Submit a GET to /app_scopes
    resp = rc.get(CURRENT_GET_ENDPOINT)

    if resp.status_code != 200:
        print "Unsuccessful request returned code: {} , response: {}".format(resp.status_code,resp.text)
    results = resp.json()

    # Print the results...
    if hasattr(results, 'results'):
        print json.dumps(results["results"], indent = 2)       
    else:
        print json.dumps(results, indent = 2)

    #  Additionally, write to a text file
    with open("output.json", 'wb') as outfile:
            json.dump(results, outfile, indent=2)
    return 
    
if __name__ == '__main__':
    main()

from tetpyclient import RestClient
from credentials import API_ENDPOINT, API_KEY, API_SECRET
import json

# This /app_scopes resource is defined on the OpenAPI documentation
CURRENT_GET_ENDPOINT = '/app_scopes'

def main():
    # Create the REST Client 
    rc = RestClient(API_ENDPOINT, api_secret=API_SECRET, api_key=API_KEY, verify=False)

    #Submit a GET to /app_scopes
    resp = rc.get(CURRENT_GET_ENDPOINT)

    if resp.status_code != 200:
        print "Unsuccessful request returned code: {} , response: {}".format(resp.status_code,resp.text)
    results = resp.json()

    # Print the results...
    if hasattr(results, 'results'):
        print json.dumps(results["results"], indent = 2)       
    else:
        print json.dumps(results, indent = 2)

    #  Additionally, write to a text file
    with open("output.json", 'wb') as outfile:
            json.dump(results, outfile, indent=2)
    return 
    
if __name__ == '__main__':
    main()