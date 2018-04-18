from socket import gethostname
def app(environ, start_response):
    data = gethostname().encode()
    start_response("200 OK", [
        ("Content-Type", "text/plain"),
        ("Content-Length", str(len(data)))
    ])
    return iter([data])