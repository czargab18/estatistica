from setuptools import setup, find_packages

setup(
    name="backend",
    version="0.2",
    packages=find_packages(
        include=[]
    ),
    include_package_data=True,
    package_data={
        "": ["*.json", "*.csv"],
    },
    install_requires=[],
)
