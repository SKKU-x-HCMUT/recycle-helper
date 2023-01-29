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
    def get_all_rewards():
        try:
            rewards_stream = db.collection('rewards').stream()
            all_rewards = [reward.to_dict() for reward in rewards_stream]
            return jsonify(all_rewards), 200
        except Exception as e:
            return f"An Error Occured: {e}", 500
