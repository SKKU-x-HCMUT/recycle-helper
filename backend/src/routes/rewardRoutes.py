from flask import Blueprint
from src.controllers.rewardController import RewardController

rewardRouter = Blueprint("rewardRouter", __name__)

# get reward by id
rewardRouter.route("/rewards/<rewardId>", methods=['GET'])(RewardController.get_reward)

# get a specific user's rewards
rewardRouter.route("/rewards/user/<localId>", methods=['GET'])(RewardController.get_rewards_of_user)


