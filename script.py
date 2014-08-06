import json
import os
import wget
from pprint import pprint
from sys import exit
from subprocess import call
from array import *
from git import Git

OUTPUT_DIRECTORY = '/home/academia-6/workspace/OCB/ocb/repo/'
JSON_URL = 'https://api.github.com/orgs/OCA/repos'
ERROR_SUCCESS = 0
CLIENT_ID='833ca29628619d897b1c'
CLIENT_SECRET='e3745df5191e16e206aadb506870ad71405f7c8e'

def checkDirectory(directory):
    try:
        if(os.path.exists(directory)):
            os.rmdir(directory)
        os.makedirs(directory)
        return ERROR_SUCCESS
    except:
        return not ERROR_SUCCESS
    
def getJsonData(url, fname='json.tmp'):
    try:
        if(os.path.isfile(fname)):
            os.remove(fname)
        
        url += ('?client_id=' + CLIENT_ID)
        url += ('&client_secret=' + CLIENT_SECRET)
        url += ('&per_page=10000')
                
        json_file = wget.download(url, fname);
        json_data = open(json_file)
        output_json = json.load(json_data)
        json_data.close()
        
        return output_json
    except:
        return None

def getPacket(data, name):
    for node in data:
        if node['name'] == name:
            return node
    return None

def getDefaultBranch(packet):
    if('default_branch' in packet):
        return packet['default_branch']
    return None

def getGitUrl(packet):
    if('git_url' in packet):
        return packet['git_url']
    return None

def getBranchesURL(packet):
    if('branches_url' in packet):
        url = packet['branches_url']
        return url.replace('{/branch}', '' )
    return None

def getPackets(data):
    packets=[]
    for node in data:
        if('name' in node):
            packets.append(node['name'])
    return packets

def getBranches(packet, master=False):
    branches=[]
    
    branches_url = getBranchesURL(packet)
    branches_data = getJsonData(branches_url, 'branches.json')
    
    for node in branches_data:
        if('name' in node and (master or node['name']!='master')):
            branches.append(node['name'])
        
    return sorted(branches, reverse=True)

repos_data = getJsonData(JSON_URL, 'repos.json')
packet_list = getPackets(repos_data)

for packet_name in packet_list:
    packet = getPacket(repos_data, packet_name)
    if(packet==None):
        continue
    branches = getBranches(packet)
    if(branches==None or len(branches)<1):
        continue
    git_url = getGitUrl(packet)
    if(git_url == None):
        continue
    
    directory = (OUTPUT_DIRECTORY + packet_name)
    checkDirectory(directory)
    
    command = "git clone \'%s\' \'%s\' -b \'%s\'" % (git_url, directory, branches[0])
    message = "\nGetting branch %s: \n\tfrom: %s\n\tto  : %s\n\texec: %s" % (branches[0], git_url, directory, command)
    print(message)
    #call(['git', 'clone', git_url, directory, '-b', branches[0]])
    g = Git( directory )
    g.execute(['git', 'clone', git_url, directory, '-b', branches[0]])


