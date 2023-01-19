
from flask import request, jsonify, session, redirect, url_for
from src.models.User import User
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
                return {'message': 'User must log in to perform this action'}, 403
            return f(*args, **kwargs)
        return decorated_function
    
    @login_required
    def get_user(localId):
        """
            Get user document by user's id
        """
        try:
            user = db.collection('users').document(localId).get()
            return jsonify(user.to_dict()), 200
        except Exception as e:
            return f"An Error Occured: {e}", 500

    @login_required
    def update_user(localId):
        """
            Update other profile information: (name, dob, sex, nationality, phone_number)
        """
        try:
            # get information from request
            name = request.json.get('name')
            sex = request.json.get('sex')
            nationality = request.json.get('nationality')
            phone_number = request.json.get('phone_number')
            dob = request.json.get('dob')

            # find user in Firestore's "users" collection 
            user_ref = db.collection('users').document(localId)
            user_info = user_ref.get().to_dict()
            if user_info == None:
                return f"An Error Occured: Cannot find user with localId {localId}", 500

            # create user model
            userObject = User(email=user_info['email'], name=name, dob=dob, sex=sex, nationality=nationality, phone_number=phone_number, point=user_info['point'])
            db.collection('users').document(localId).update(userObject.to_dict())

            updatedUser = user_ref.get().to_dict()
            return jsonify(updatedUser), 200
        except Exception as e:
            return f"An Error Occured: {e}", 500

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

            # create user on firestore
            db.collection('users').document(user['localId']).set({"email": user['email'], "point": 0})
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
            return {'message': 'User is not in session'}, 500
