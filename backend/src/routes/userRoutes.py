from flask import Blueprint
from src.controllers.userController import UserController

userRouter = Blueprint("userRouter", __name__)


userRouter.route("/user/<localId>", methods=['GET'])(UserController.get_user)

userRouter.route("/user/update/<localId>", methods=['PUT'])(UserController.update_user)

userRouter.route("/register", methods=['POST'])(UserController.register)

userRouter.route("/login", methods=['POST'])(UserController.login)

userRouter.route("/logout", methods=['GET'])(UserController.logout)

# achieve reward -> exchange points for reward
userRouter.route("/user/achieve-reward", methods=['POST'])(UserController.achieve_reward)

# get user's rewards
userRouter.route("/user/<localId>/rewards", methods=['GET'])(UserController.get_rewards)

# get user's vouchers
userRouter.route("/user/<localId>/vouchers", methods=['GET'])(UserController.get_vouchers)
