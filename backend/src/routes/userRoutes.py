from flask import Blueprint
from src.controllers.userController import UserController

userRouter = Blueprint("userRouter", __name__)


userRouter.route("/users", methods=['GET'])(UserController.get_all_users)

userRouter.route("/users/<id>", methods=['GET'])(UserController.get_user)

userRouter.route("/register", methods=['POST'])(UserController.register)

userRouter.route("/login", methods=['POST'])(UserController.login)

userRouter.route("/logout", methods=['GET'])(UserController.logout)

