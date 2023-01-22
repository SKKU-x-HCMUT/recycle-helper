import os
from flask import Flask, request, jsonify, session
import src.routes.userRoutes as userRoutes
import src.routes.rewardRoutes as rewardRoutes

# Initialize Flask App
app = Flask(__name__)
app.secret_key = 'will.change.later'
app.register_blueprint(userRoutes.userRouter, url_prefix = "/api")
app.register_blueprint(rewardRoutes.rewardRouter, url_prefix = "/api")

port = int(os.environ.get('PORT', 5000))
if __name__ == '__main__':
    app.run(threaded=True, host='0.0.0.0', port=port)