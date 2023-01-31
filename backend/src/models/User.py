class User(object):
    def __init__(self, userId, email, name, dob, sex, nationality, phone_number, points, rewards=[], vouchers=[]):
        self.userId = userId
        self.email = email
        self.name = name
        self.dob = dob
        self.sex = sex
        self.nationality = nationality
        self.phone_number = phone_number
        self.points = points
        self.rewards = rewards
        self.vouchers = vouchers

    def to_dict(self):
        return {"name": self.name, "dob": self.dob, "sex": self.sex, "nationality": self.nationality, 
        "phone_number": self.phone_number, "email": self.email, "points": self.points}
    
    def __repr__(self):
        return (
            f'User(\
                name={self.name}, \
                dob={self.dob}, \
                sex={self.sex}, \
                nationality={self.nationality}, \
                phone_number={self.phone_number}\
                email={self.email}\
                points={self.points}\
            )'
        )