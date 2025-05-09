import re
import os
import json
import subprocess

# Get the environment variables
var1 = 763
var2 = 927

def simplify_labels(label_str):
    # Extract numerical values from the label string
    values = list(map(int, re.findall(r'@(\d+)', label_str)))
    
    # Check if there are at least two values to form a pattern
    if len(values) < 2:
        return label_str  # Return original if not enough values to simplify

    # Determine the step size
    step = values[1] - values[0]
    if all(values[i] - values[i - 1] == step for i in range(1, len(values))):
        # Identify start and count
        start = values[0]
        count = len(values)
        return f"@{start} + {step}*n, n=0..{count - 1}"
    else:
        return label_str  # Return original if no pattern found


def get_data(nodeshape, pc_on, id_name, jsonfilename, dotfilename, start=0, end=None):
    with open(jsonfilename, 'r') as jsonfile:
        jsondata = json.load(jsonfile)
        valuejson = jsondata['digest']

    if end is None:
        end = len(valuejson)

    data = []
    for entry in range(start, end):
        if entry >= len(valuejson):
            break
        subjson = valuejson[entry]
        cyclevalue = subjson['cycle']

        valueinfo = subjson['value']
        tmp = [cyclevalue, valueinfo.get(id_name)]
        data.append(tmp)

    transitions = {}

    for i in range(len(data) - 1):
        start = data[i][1]
        end = data[i + 1][1]
        transition = (start, end)

        if transition not in transitions:
            transitions[transition] = []

        if 'D' in jsonfilename:
            transitions[transition].append(data[i][0])  # Store the label (time)
        else:
            transitions[transition].append(data[i+1][0])

    src_dest_map = {}
    state_marked = []
    if pc_on == True:
        for src, dest in transitions.keys():
            if src not in src_dest_map:
                src_dest_map[src] = set()
            if src != dest:  # Exclude self-references
                src_dest_map[src].add(dest)

        for src, dests in src_dest_map.items():
            if len(dests) >= 2:
                state_marked.append(src)

    with open(dotfilename, 'w') as f:
        start_string = f"""digraph G {{
        node [style=rounded, penwidth=3, fontsize=20, shape={nodeshape}];
        """
        f.write(start_string)  # Start the DOT graph
    
        #if state_marked != []:
        #    for state_red in state_marked:
        #        f.write(f'"{state_red}" [style=filled,color=red];\n')

        for (start, end), labels in transitions.items():
            unique_labels = ', '.join(f'@{label}' for label in labels)
            #simplified_labels = unique_labels
            simplified_labels = simplify_labels(unique_labels)  # Simplify the labels
            color = 'gray'
            f.write(f'"{start}" -> "{end}" [label="{simplified_labels}", color=black,arrowsize=1,style=bold,penwidth=3,fontsize=20];\n')

        f.write('}\n')  # End the DOT graph

def extract_ids_to_dict(json_filename):
    # Initialize an empty dictionary to hold the IDs
    ids_dict = {}

    # Open the JSON file and load the data
    with open(json_filename, 'r') as jsonfile:
        jsondata = json.load(jsonfile)

        # Extract the 'id' data
        ids = jsondata.get('id', {})

        # Iterate over the IDs and save them into the dictionary
        for key, value in ids.items():
            coreid = value.split('.')[0][-1]
            module = value.split('.')[2][0:3]
            name = f'core{coreid}_{module}_'+'_'.join(value.split('.')[3:])
            ids_dict[key] = value.replace('.','_')  # Use the key from the JSON as the key in the dict

    return ids_dict

subprocess.run(["mkdir", "dstgfiles"])
ids_dict = extract_ids_to_dict('../sim/valuedata_Q.json')
for key, value in ids_dict.items():
    pc_on = False
    if 'pc' in value:
        pc_on = True
    else:
        pc_on = False

    print(f'Processing {value}_Q.dot')
    get_data('oval', pc_on, key, '../sim/valuedata_Q.json', f'dstgfiles/{value}_Q.dot', int(var1), int(var2))
    command = ['dot', '-Tpdf', f'dstgfiles/{value}_Q.dot', '-o', f'dstgfiles/{value}_Q.pdf']
    subprocess.run(command)
