import pyrebase
import json

pb = pyrebase.initialize_app(json.load(open('src/config/auth/credentials.json')))
pbAuth = pb.auth()