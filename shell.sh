#!/bin/bash

read -p "Enter the OpenShift role name: " role_name
read -p "Is it a cluster role? (yes/no): " is_cluster_role

if [ "$is_cluster_role" == "yes" ]; then
    oc get clusterrole $role_name -o json > role.json
else
    oc get role $role_name -o json > role.json
fi

python3 print_role_permissions.py role.json $role_name