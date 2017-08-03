'''

CREATE SCOPES

Author: Edwin Gonzalez Urzua (eddysheikan@GitHub)

This program performs an HTTP POST Request to create several scopes
using the Python Client. 

'''

import os,sys

# Import Tetration client
from tetpyclient import RestClient
from credentials import API_ENDPOINT, API_KEY, API_SECRET
import json
import requests.packages.urllib3

# We use this line in order to avoid any warnings for Insecure Connection
requests.packages.urllib3.disable_warnings()

rc = RestClient(API_ENDPOINT, api_secret=API_SECRET, api_key=API_KEY, verify=False)

sites = ["A", "B", "C", "D", "E", "F"]

for site in sites:
    # This is the minimum required to create a Scope

    req_payload = {

        # This is the name of the scope

        "short_name": "Site " + str(site),

        # Query to determine which sensors will belong to the scope

        "short_query": {

            # "field" can be a user annotation. To use user annotations as queries
            # for scopes, we use the format user_{annotation}
        
            "field": "user_department",
            "type": "eq",
            "value": "Site " + str(site)
        },
        # Verify the app scope ID for the parent scope by using get scope first 
        "parent_app_scope_id": "59713afa755f02384789e966"
    }

    resp = rc.post('/app_scopes', json_body=json.dumps(req_payload))


print resp.status_code