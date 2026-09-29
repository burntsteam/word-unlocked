"""Verified downloads for the seed scripts (stdlib only; certifi optional).

Every scripture source file a fetch script downloads is pinned to a SHA-256
next to its URL and checked before it is parsed, so neither a network attacker
nor a silent upstream edit can change the text that ships in the app. TLS is
always verified; there is no unverified fallback.

If an upstream file changes on purpose, review the new text, then update its
pinned hash (and, for GitHub sources, the pinned commit) in the fetch script.
"""
import hashlib, os, ssl, urllib.error, urllib.request

try:                                    # python.org builds ship without CA certs
    import certifi
    CTX = ssl.create_default_context(cafile=certifi.where())
except ImportError:                     # system trust store, still verified
    CTX = ssl.create_default_context()


def download(url, timeout=90):
    """Return the bytes at url, fetched over verified TLS."""
    req = urllib.request.Request(url, headers={"User-Agent": "wordunlocked-seed"})
    try:
        with urllib.request.urlopen(req, timeout=timeout, context=CTX) as r:
            return r.read()
    except urllib.error.URLError as e:
        if isinstance(e.reason, ssl.SSLCertVerificationError):
            raise SystemExit(
                f"TLS certificate verification failed for {url}:\n  {e.reason}\n"
                "Install certifi (python3 -m pip install certifi) or fix this Python's\n"
                "CA certificates (python.org builds: run 'Install Certificates.command').\n"
                "Do not disable verification.")
        raise


def verify(data, sha256, name):
    """Return data unchanged if its SHA-256 matches the pinned hex digest, else abort."""
    actual = hashlib.sha256(data).hexdigest()
    if actual != sha256:
        raise SystemExit(
            f"Integrity check failed for {name}\n"
            f"  expected sha256 {sha256}\n"
            f"  actual   sha256 {actual}\n"
            "The source changed upstream or was altered in transit. Aborting; review\n"
            "the new text before updating the pinned hash.")
    return data


def fetch_verified(url, sha256, cache=None, timeout=90):
    """Return the bytes at url once they match the pinned SHA-256. A cache file is
    reused only while it still matches the pin, and written only after verifying."""
    if cache and os.path.exists(cache):
        with open(cache, "rb") as f:
            data = f.read()
        if hashlib.sha256(data).hexdigest() == sha256:
            return data
    data = verify(download(url, timeout), sha256, url)
    if cache:
        with open(cache, "wb") as f:
            f.write(data)
    return data
