
from flask import request, jsonify, session, redirect, url_for
from src.models.User import User
from src.config.firestore.db import db
from src.config.auth.auth import pbAuth
from functools import wraps

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
    def update_user():
        """
            Update other profile information: (name, dob, sex, nationality, phone_number)
        """
        try:
            # get information from request
            localId = request.json.get('localId')
            name = request.json.get('name')
            sex = request.json.get('sex')
            nationality = request.json.get('nationality')
            phone_number = request.json.get('phoneNumber')
            dob = request.json.get('dob')

            # find user in Firestore's "users" collection 
            user_ref = db.collection('users').document(localId)
            user_info = user_ref.get().to_dict()
            if user_info == None:
                return f"An Error Occured: Cannot find user with localId {localId}", 500

            # create user model
            user_object = User(userId=localId, email=user_info['email'], name=name, dob=dob, sex=sex, nationality=nationality, phone_number=phone_number, points=user_info['points'])

            db.collection('users').document(localId).update(user_object.to_dict())

            updated_user = user_ref.get().to_dict()
            return jsonify(updated_user), 200
        except Exception as e:
            return f"An Error Occured: {e}", 500

    @login_required
    def achieve_reward():
        """
            When the user click on achieve a reward in a rewards page
        """
        try:
            rewardId = request.json.get("rewardId")
            localId = request.json.get("localId")

            reward = db.collection('rewards').document(rewardId).get().to_dict()
            user = db.collection("users").document(localId).get().to_dict()

            # check reward's points_exchange and user's points
            if user["points"] < reward["pointsExchange"]:
                return {"message": "Not having enough points to achieve reward"}, 500

            # check how many rewards and vouchers of the same type that the user had
            ## check number of rewards
            update_rewards = {
                    f"{rewardId}": {
                        "rewardId": f"{rewardId}",
                        "pointsExchange": reward['pointsExchange'],
                        "quantity": 1
                    }
                }
            if 'rewards' in user:
                if f'{rewardId}' in user['rewards']:
                    user['rewards'][f'{rewardId}']['quantity'] += 1
                update_rewards.update(user["rewards"])

            ## update points after achieving rewards
            update_points = user["points"] - reward["pointsExchange"]

            ## check number of vouchers
            update_vouchers = reward["vouchers"]
            if 'vouchers' in user and 'vouchers' in reward:
                for voucherId in reward["vouchers"]:
                    if voucherId in user["vouchers"]:
                        user["vouchers"][f"{voucherId}"]["quantity"] += 1
                update_vouchers.update(user["vouchers"])


            # update user's document with reward and corresponding vouchers
            updateObject = {
                "rewards": update_rewards,
                "vouchers": update_vouchers,
                "points": update_points
            }
            
            print(updateObject)

            # update user's document
            db.collection('users').document(localId).update(updateObject)
            user = db.collection("users").document(localId).get().to_dict()

            return jsonify(user), 200
        except Exception as e:
            return { "message": f"An Error Occured: {e}" }, 500

    @login_required
    def get_rewards(localId):
        try:
            user = db.collection('users').document(localId).get().to_dict()
            if 'rewards' not in user:
                return { }, 200
            return jsonify(user['rewards']), 200
        except Exception as e:
            return { "message": f"An Error Occured: {e}" }, 500

    @login_required
    def get_vouchers(localId):
        try:
            user = db.collection('users').document(localId).get().to_dict()
            if 'vouchers' not in user:
                return { }, 200
            return jsonify(user['vouchers']), 200
        except Exception as e:
            return { "message": f"An Error Occured: {e}" }, 500

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
            db.collection('users').document(user['localId']).set({"userId": user['localId'], "email": user['email'], "points": 0})
            return {'message': f'Successfully created user {user["email"]}'}, 200
        except Exception as e:
            return {'message': f'Error creating user: {e}'}, 500

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
