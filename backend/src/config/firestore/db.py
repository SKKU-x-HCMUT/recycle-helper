from firebase_admin import credentials, firestore, initialize_app

# Initialize Firestore DB
cred = credentials.Certificate('./src/config/firestore/credentials.json')
default_app = initialize_app(cred)
db = firestore.client()