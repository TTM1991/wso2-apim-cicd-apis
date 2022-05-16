#!/bin/sh

echo $(which apictl)
apictl version

rm -rf $HOME/.wso2apictl

echo 'setting up dev environment'
apictl add-env -e dev \
                    --registration https://localhost:9444/client-registration/v0.17/register \
                    --apim https://localhost:9444 \
                    --token https://localhost:9444/token \
                    --admin https://localhost:9444/api/am/admin/v0.17 \
                    --api_list https://localhost:9444/api/am/publisher/v0.17/apis \
                    --app_list https://localhost:9444/api/am/store/v0.17/applications

echo 'setting up prod environment'
apictl add-env -e prod \
                    --registration https://localhost:9443/client-registration/v0.17/register \
                    --apim https://localhost:9443 \
                    --token https://localhost:9443/token \
                    --admin https://localhost:9443/api/am/admin/v0.17 \
                    --api_list https://localhost:9443/api/am/publisher/v0.17/apis \
                    --app_list https://localhost:9443/api/am/store/v0.17/applications