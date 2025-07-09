
import http.server
import socketserver
from urllib.parse import urlparse, parse_qs
import os

os.chdir("/opt/html")

CORRECT_ANSWERS = {
    "q1": "13",
    "q2": "3700",
    "q3": "960"
}

class MyHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path.startswith("/submit"):
            query = parse_qs(urlparse(self.path).query)
            question = query.get("question", [""])[0]
            answer = query.get("answer", [""])[0]
            expected = CORRECT_ANSWERS.get(question)

            self.send_response(200)
            self.send_header("Content-type", "text/plain; charset=utf-8")
            self.end_headers()

            if expected is None:
                self.wfile.write("❌ Unknown question.".encode("utf-8"))
            elif answer.strip() == expected:
                self.wfile.write("✅ Correct!".encode("utf-8"))
            else:
                self.wfile.write("❌ Incorrect.".encode("utf-8"))
        else:
            super().do_GET()

PORT = 8080
with socketserver.TCPServer(("", PORT), MyHandler) as httpd:
    print("Serving on port", PORT)
    httpd.serve_forever()
