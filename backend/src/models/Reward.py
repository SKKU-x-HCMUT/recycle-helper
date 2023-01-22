class Reward(object):
    def __init__(self, name, points_exchange):
        self.name = name
        self.points_exchange = points_exchange

    def to_dict(self):
        return {"name": self.name, "points_exchange": self.points_exchange}
    
    def __repr__(self):
        return (
            f'User(\
                name={self.name}, \
                points_exchange={self.points_exchange}\
            )'
        )