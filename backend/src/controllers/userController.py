
from flask import request, jsonify
from src.config.firestore.db import db

class UserController:
    def get_all_users():
        """
            Get all documents in collection users
        """
        try:
            all_users = [doc.to_dict() for doc in db.collection('users').stream()]
            return jsonify(all_users), 200
        except Exception as e:
            return f"An Error Occured: {e}"

    def get_user(id):
        """
            Get user document by user's id
        """
        try:
            user = db.collection('users').document(id).get()
            return jsonify(user.to_dict()), 200
        except Exception as e:
            return f"An Error Occured: {e}"