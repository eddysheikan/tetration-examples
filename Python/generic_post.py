'''

GENERIC POST (flows)

Author: Edwin Gonzalez Urzua (eddysheikan@GitHub)

This program performs an HTTP POST Request to obtain information about
the flows using the Python Client.

'''

from tetpyclient import RestClient
from credentials import API_ENDPOINT, API_KEY, API_SECRET
import json

SUPPORTED_POST_ENDPOINTS = ['/flowsearch','/sensors','/app_scopes','/roles','/applications','/users']
CURRENT_POST_ENDPOINT = '/flowsearch'

# The HTTP Body should be sent in JSON format. The Python Client will set the Content-Type as
# application/json

CURRENT_POST_PAYLOAD = {
    "filter": {
        "type": "or",
        "filters": [
            
            {
                "type": "contains",
                "field": "src_hostname",
                "value": "abc"
            }
        ]
    },
    "scopeName": "default",
    "limit": 2,
    "t0": "2017-07-24T00:00:00-0000",
    "t1": "2017-07-25T00:00:00-0000"
}


def main():
    rc = RestClient(API_ENDPOINT, api_secret=API_SECRET, api_key=API_KEY, verify=False)

    # There is no need to specify header values, as the Python Client already handles it.
    
    resp = rc.post(CURRENT_POST_ENDPOINT,json_body=json.dumps(CURRENT_POST_PAYLOAD))

    if resp.status_code != 200:
        print "Unsuccessful request returned code: {} , response: {}".format(resp.status_code,resp.text)
    results = resp.json()

    if hasattr(results, "results"):
        print json.dumps(results["results"], indent = 2)
        
    else:
        print json.dumps(results, indent = 2)
    return 
    
if __name__ == '__main__':
    main()