import os
from flask import Flask
import src.routes.userRoutes as userRoutes
import src.routes.rewardRoutes as rewardRoutes
import src.routes.voucherRoutes as voucherRoutes
import src.routes.mlcallRoutes as mlcallRoutes

# Initialize Flask App
app = Flask(__name__)
app.secret_key = 'will.change.later'
app.register_blueprint(userRoutes.userRouter, url_prefix = "/api")
app.register_blueprint(rewardRoutes.rewardRouter, url_prefix = "/api")
app.register_blueprint(voucherRoutes.voucherRouter, url_prefix = "/api")
app.register_blueprint(mlcallRoutes.mlcallRouter, url_prefix = "/api")

@app.route("/")
def deploy():
    return "Successfully deployed"


if __name__ == '__main__':
    app.run(threaded=True, host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))