import sys
import json
import csv

def parse_roles(file_path, role_name):
    with open(file_path, 'r') as file:
        data = json.load(file)

    roles_info = {}

    rules = data.get('rules', [])
    
    for rule in rules:
        resources = rule.get('resources', [])
        verbs = rule.get('verbs', [])
        
        for resource in resources:
            if resource not in roles_info:
                roles_info[resource] = {}
            
            if role_name not in roles_info[resource]:
                roles_info[resource][role_name] = {}
            
            for verb in ['get', 'list', 'watch', 'create', 'update', 'patch', 'delete', 'deletecollection', 'edit', 'view']:
                roles_info[resource][role_name][verb] = 'yes' if verb in verbs else 'no'
    
    return roles_info

def write_csv(roles_info, role_name, output_file):
    header = ["Resource", "Role", "get", "list", "watch", "create", "update", "patch", "delete", "deletecollection", "edit", "view"]

    with open(output_file, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(header)
        
        for resource, roles in roles_info.items():
            for role, verbs in roles.items():
                row = [resource, role] + [verbs[verb] for verb in header[2:]]
                writer.writerow(row)

if __name__ == "__main__":
    file_path = sys.argv[1]
    role_name = sys.argv[2]
    output_file = f"{role_name}_permissions.csv"

    roles_info = parse_roles(file_path, role_name)
    write_csv(roles_info, role_name, output_file)

    print(f"Permissions for the role '{role_name}' have been saved to '{output_file}'")