#! /usr/bin/env python3

# typical SimpleHttpServer output:
#
# Serving HTTP on 0.0.0.0 port 8000 ...
# 10.10.10.203 - - [16/Sep/2020 16:09:11] "GET /myfile.exe HTTP/1.1" 200 -

import sys
import os
import json
from pathlib import Path
import http.server
import socketserver
import ifaddr
from colorama import init, Fore, Back, Style

# a file "local_shortcuts.json" can also be used to extend this dictionary and avoid
# committing personal folder structure information
SHORTCUTS = {
    'nc.exe' : '/usr/share/windows-resources/binaries',
}

PORTS = [ 8000, 8080, 8888, 9000, 9090, 9999 ]

class MyHttpRequestHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):

        cwd = self.directory
        path_override = False

        for key in SHORTCUTS.keys():
            if f"/{key}" == self.path:
                print(f"{Fore.WHITE+Style.DIM}Redirecting path {key} to {SHORTCUTS[key]}...")
                path_override = True
                self.directory = SHORTCUTS[key]
                break

        http.server.SimpleHTTPRequestHandler.do_GET(self)

        if path_override:
            self.directory = cwd


init(autoreset=True)

shorty = Path('local_shortcuts.json')
if shorty.exists():
    with open(shorty, 'r') as f:
        user = json.load(f)
        print(f'{Fore.CYAN+Style.BRIGHT}Loaded {len(user)} user shortcuts from {shorty.name}.')
        SHORTCUTS = {**SHORTCUTS, **user}   # python 3.5+ method to merge two dictionaries

adapters = ifaddr.get_adapters()

# create an object of the above class
handler_object = MyHttpRequestHandler

my_server = None

for port in PORTS:
    try:
        my_server = socketserver.TCPServer(("", port), handler_object)

        if my_server.server_address[0] == "0.0.0.0":
            for a in adapters:
                if a.nice_name != "lo":
                    print(f"{Fore.YELLOW+Style.BRIGHT}Serving HTTP on {a.nice_name}: {a.ips[0].ip} port {my_server.server_address[1]} ...")
        else:
            print(f"{Fore.YELLOW+Style.BRIGHT}Serving HTTP on {my_server.server_address[0]} port {my_server.server_address[1]} ...")

        break   # no errors occurred
    except OSError:
        pass

if my_server is None:
    print(f"{Fore.RED+Style.BRIGHT}All available ports are in use. Aborting...")
    sys.exit(1)

try:
    # start the server
    my_server.serve_forever()
except KeyboardInterrupt:
    pass

print()