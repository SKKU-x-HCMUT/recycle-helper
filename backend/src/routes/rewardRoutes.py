from flask import Blueprint
from src.controllers.rewardController import RewardController

rewardRouter = Blueprint("rewardRouter", __name__)

# get reward by id
rewardRouter.route("/reward/<rewardId>", methods=['GET'])(RewardController.get_reward)

rewardRouter.route("/rewards", methods=['GET'])(RewardController.get_all_rewards)


