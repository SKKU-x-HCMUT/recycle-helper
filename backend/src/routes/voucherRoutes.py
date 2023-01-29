from flask import Blueprint
from src.controllers.voucherController import VoucherController

voucherRouter = Blueprint("voucherRouter", __name__)

# get reward by id
voucherRouter.route("/voucher/<voucherId>", methods=['GET'])(VoucherController.get_voucher)

voucherRouter.route("/vouchers", methods=['GET'])(VoucherController.get_all_vouchers)



