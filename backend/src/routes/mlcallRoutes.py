from flask import Blueprint
from src.controllers.mlcallController import MlcallController

mlcallRouter = Blueprint("mlcallRouter", __name__)

# post image to classify trash
mlcallRouter.route("/predict", methods=['POST'])(MlcallController.predict)