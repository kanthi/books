#!/usr/bin/env python3
"""Local HTTPS preview helpers for indiprev.sh (Safari https-only friendly).

Modes:
  static  — serve a directory over HTTPS
  proxy   — HTTPS front-door reverse-proxy to a local HTTP upstream (Quarto)

Example:
  python3 preview-https-server.py static --port 4242 --dir ./_book --cert c.pem --key k.pem
  python3 preview-https-server.py proxy  --port 4242 --upstream 127.0.0.1:14242 --cert c.pem --key k.pem
"""

from __future__ import annotations

import argparse
import http.client
import http.server
import os
import ssl
import sys
import urllib.parse
from functools import partial
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path


def make_ssl_context(cert: Path, key: Path) -> ssl.SSLContext:
    ctx = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
    # Reasonable modern defaults; localhost only.
    ctx.minimum_version = ssl.TLSVersion.TLSv1_2
    ctx.load_cert_chain(certfile=str(cert), keyfile=str(key))
    return ctx


def run_static(port: int, directory: Path, cert: Path, key: Path, bind: str) -> None:
    os.chdir(directory)
    handler = partial(http.server.SimpleHTTPRequestHandler, directory=str(directory))
    httpd = ThreadingHTTPServer((bind, port), handler)
    httpd.socket = make_ssl_context(cert, key).wrap_socket(httpd.socket, server_side=True)
    print(f"HTTPS static server: https://localhost:{port}/  dir={directory}", flush=True)
    httpd.serve_forever()


class ReverseProxyHandler(BaseHTTPRequestHandler):
    upstream_host: str = "127.0.0.1"
    upstream_port: int = 0

    def log_message(self, fmt: str, *args) -> None:  # quieter
        sys.stderr.write("%s - %s\n" % (self.address_string(), fmt % args))

    def _proxy(self) -> None:
        length = int(self.headers.get("Content-Length", "0") or "0")
        body = self.rfile.read(length) if length > 0 else None

        # Preserve path + query
        path = self.path
        conn = http.client.HTTPConnection(self.upstream_host, self.upstream_port, timeout=60)
        headers = {k: v for k, v in self.headers.items() if k.lower() not in {"host", "connection"}}
        headers["Host"] = f"{self.upstream_host}:{self.upstream_port}"
        headers["Connection"] = "close"
        try:
            conn.request(self.command, path, body=body, headers=headers)
            resp = conn.getresponse()
            data = resp.read()
            self.send_response(resp.status, resp.reason)
            hop_by_hop = {
                "connection",
                "keep-alive",
                "proxy-authenticate",
                "proxy-authorization",
                "te",
                "trailers",
                "transfer-encoding",
                "upgrade",
            }
            for k, v in resp.getheaders():
                if k.lower() in hop_by_hop:
                    continue
                # Avoid leaking upstream absolute http URLs as Location where possible
                if k.lower() == "location" and v.startswith("http://"):
                    parsed = urllib.parse.urlparse(v)
                    v = parsed.path or "/"
                    if parsed.query:
                        v += "?" + parsed.query
                self.send_header(k, v)
            self.send_header("Content-Length", str(len(data)))
            self.end_headers()
            if self.command != "HEAD":
                self.wfile.write(data)
        except Exception as exc:  # noqa: BLE001 — surface proxy errors to browser
            msg = f"Upstream proxy error: {exc}\n".encode()
            self.send_response(502)
            self.send_header("Content-Type", "text/plain; charset=utf-8")
            self.send_header("Content-Length", str(len(msg)))
            self.end_headers()
            self.wfile.write(msg)
        finally:
            conn.close()

    def do_GET(self) -> None:  # noqa: N802
        self._proxy()

    def do_HEAD(self) -> None:  # noqa: N802
        self._proxy()

    def do_POST(self) -> None:  # noqa: N802
        self._proxy()

    def do_PUT(self) -> None:  # noqa: N802
        self._proxy()

    def do_DELETE(self) -> None:  # noqa: N802
        self._proxy()

    def do_OPTIONS(self) -> None:  # noqa: N802
        self._proxy()

    def do_PATCH(self) -> None:  # noqa: N802
        self._proxy()


def run_proxy(port: int, upstream: str, cert: Path, key: Path, bind: str) -> None:
    host, _, p = upstream.partition(":")
    up_port = int(p or "80")

    class Handler(ReverseProxyHandler):
        upstream_host = host or "127.0.0.1"
        upstream_port = up_port

    httpd = ThreadingHTTPServer((bind, port), Handler)
    httpd.socket = make_ssl_context(cert, key).wrap_socket(httpd.socket, server_side=True)
    print(
        f"HTTPS proxy: https://localhost:{port}/ -> http://{Handler.upstream_host}:{Handler.upstream_port}/",
        flush=True,
    )
    httpd.serve_forever()


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    sub = ap.add_subparsers(dest="mode", required=True)

    s = sub.add_parser("static", help="Serve a directory over HTTPS")
    s.add_argument("--port", type=int, required=True)
    s.add_argument("--dir", type=Path, required=True)
    s.add_argument("--cert", type=Path, required=True)
    s.add_argument("--key", type=Path, required=True)
    s.add_argument("--bind", default="127.0.0.1")

    p = sub.add_parser("proxy", help="HTTPS reverse proxy to local HTTP upstream")
    p.add_argument("--port", type=int, required=True)
    p.add_argument("--upstream", required=True, help="host:port of HTTP upstream")
    p.add_argument("--cert", type=Path, required=True)
    p.add_argument("--key", type=Path, required=True)
    p.add_argument("--bind", default="127.0.0.1")

    args = ap.parse_args()
    if args.mode == "static":
        if not args.dir.is_dir():
            print(f"error: not a directory: {args.dir}", file=sys.stderr)
            return 2
        run_static(args.port, args.dir.resolve(), args.cert, args.key, args.bind)
    else:
        run_proxy(args.port, args.upstream, args.cert, args.key, args.bind)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
