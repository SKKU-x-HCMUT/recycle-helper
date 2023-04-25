class Reward(object):
    def __init__(self, rewardId, name, points_exchange, vouchers):
        self.rewardId = rewardId
        self.name = name
        self.pointsExchange = points_exchange
        self.vouchers = vouchers

    def to_dict(self):
        return {"rewardId": self.rewardId, "name": self.name, "points_exchange": self.pointsExchange, "vouchers": self.vouchers}
    
    def __repr__(self):
        return (
            f'User(\
                rewardId={self.rewardId}, \
                name={self.name}, \
                points_exchange={self.pointsExchange}\
                vouchers={self.vouchers}\
            )'
        )