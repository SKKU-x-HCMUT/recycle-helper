from flask import request, jsonify, session, redirect, url_for
from src.models.Voucher import Voucher
from src.config.firestore.db import db
from functools import wraps

class VoucherController:
    def login_required(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            if 'user' not in session:
                # return redirect(url_for(''))      Should redirect to login page in Flutter
                return {'message': 'User must log in to perform this action'}, 403
            return f(*args, **kwargs)
        return decorated_function

    @login_required
    def get_voucher(voucherId):
        try:
            voucher = db.collection('vouchers').document(voucherId).get()
            return jsonify(voucher.to_dict()), 200
        except Exception as e:
            return f"An Error Occured: {e}", 500
