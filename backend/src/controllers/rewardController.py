from flask import request, jsonify, session, redirect, url_for
from src.models.Reward import Reward
from src.config.firestore.db import db
from functools import wraps

class RewardController:
    def login_required(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            if 'user' not in session:
                # return redirect(url_for(''))      Should redirect to login page in Flutter
                return {'message': 'User must log in to perform this action'}, 403
            return f(*args, **kwargs)
        return decorated_function

    @login_required
    def get_reward(rewardId):
        try:
            reward = db.collection('rewards').document(rewardId).get()
            return jsonify(reward.to_dict()), 200
        except Exception as e:
            return f"An Error Occured: {e}", 500

    @login_required
    def get_rewards_of_user(localId):
        try:
            user = db.collection('users').document(localId).get().to_dict()
            return jsonify(user['rewards']), 200
        except Exception as e:
            return f"An Error Occured: {e}", 500
