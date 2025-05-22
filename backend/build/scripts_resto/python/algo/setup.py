from setuptools import setup, find_packages

setup(
    name="utils",
    version="0.1",
    packages=find_packages(),
    install_requires=[
        "bs4",
        "requests",
        "google-api-python-client",
        "google-auth-oauthlib",
        "google-auth-httplib2",
        "yt-dlp",
        "reportlab",
        "PyMuPDF",
        "Pillow",
        "PyPDF2",
        "python-dateutil"
    ], 
)