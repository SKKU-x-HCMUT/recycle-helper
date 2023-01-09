from flask import Blueprint
from src.controllers.userController import UserController

userRouter = Blueprint("userRouter", __name__)


userRouter.route("/", methods=['GET'])(UserController.get_all_users)

userRouter.route("/<id>", methods=['GET'])(UserController.get_user)