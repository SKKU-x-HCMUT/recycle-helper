from flask import request, jsonify, session, redirect, url_for
from src import cardboard
from src.models.mlcall import Mlcall
from src.config.firestore.db import db
from functools import wraps

predict_image_classification_sample = Mlcall(
    project="203585176079",
    endpoint_id="7897400596175519744",
    location="us-central1",
    filename="inputfilename"
)

class MlcallController:
    def login_required(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            if 'user' not in session:
                # return redirect(url_for(''))      Should redirect to login page in Flutter
                return {'message': 'User must log in to perform this action'}, 403
            return f(*args, **kwargs)
        return decorated_function

    @login_required
    def predict_image_classification_sample(rewardId):
        # call api from gg cloud with predict_image_classification_sample
        pass
