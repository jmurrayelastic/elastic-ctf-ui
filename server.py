import http.server
import socketserver
import os

os.chdir("/opt/html")

PORT = 8080
Handler = http.server.SimpleHTTPRequestHandler

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print("Serving on port", PORT)
    httpd.serve_forever()

