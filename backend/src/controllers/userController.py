
from flask import request, jsonify, session, redirect, url_for
from src.config.firestore.db import db
from firebase_admin import auth
import pyrebase
import json
from functools import wraps

pb = pyrebase.initialize_app(json.load(open('src/config/auth/credentials.json')))
pbAuth = pb.auth()



class UserController:
    def login_required(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            if 'user' not in session:
                # return redirect(url_for(''))      Should redirect to login page in Flutter
                return {'message': 'User must log in'}, 403
            return f(*args, **kwargs)
        return decorated_function
    
    @login_required
    def get_all_users():
        """
            Get all documents in collection users
        """
        try:
            all_users = [doc.to_dict() for doc in db.collection('users').stream()]
            return jsonify(all_users), 200
        except Exception as e:
            return f"An Error Occured: {e}"

    def get_user(localId):
        """
            Get user document by user's id
        """
        try:
            user = db.collection('users').document(localId).get()
            return jsonify(user.to_dict()), 200
        except Exception as e:
            return f"An Error Occured: {e}"

    # Authentication functions
    def register():
        """
            Register new user
            request must have email and password
        """
        email = request.json.get('email')
        password = request.json.get('password')
        if email is None or password is None:
            return {'message': 'Error missing email or password'}, 400
        try:
            # create user on firebase authentication
            user = pbAuth.create_user_with_email_and_password(email, password)
            print(json.dumps(user))
            # create user on firestore
            db.collection('users').document(user['localId']).set({"email": user['email']})
            return {'message': f'Successfully created user {user["email"]}'}, 200
        except Exception as e:
            return {'message': f'Error creating user: {e}'},400

    def login():
        """
            Login
            request must have email and password
        """
        email = request.json.get('email')
        password = request.json.get('password')
        try:
            user = pbAuth.sign_in_with_email_and_password(email, password)
            print(json.dumps(user))
            id_token = user['idToken']
            refreshToken = user['refreshToken']
            session['user'] = user['localId']
            return {'idToken': id_token, 'refreshToken': refreshToken, 'localId': user['localId']}, 200
        except Exception as e:
            return {'message': f'There was an error logging in: {e}'},400

    def logout():
        if 'user' in session:
            session.pop('user')
            return {'message': 'Successfully logged out'}
        else:
            return {'message': 'User is not in session'}
