class User(object):
    def __init__(self, userId, email, name, dob, sex, nationality, phone_number, points, classification_count, rewards=[], vouchers=[]):
        self.userId = userId
        self.email = email
        self.name = name
        self.dob = dob
        self.sex = sex
        self.nationality = nationality
        self.phoneNumber = phone_number
        self.classificationCount = classification_count
        self.points = points
        self.rewards = rewards
        self.vouchers = vouchers

    def to_dict(self):
        return {"name": self.name, "dob": self.dob, "sex": self.sex, "nationality": self.nationality, 
        "phoneNumber": self.phoneNumber, "email": self.email, "points": self.points, "classificationCount": self.classificationCount}
    
    def __repr__(self):
        return (
            f'User(\
                name={self.name}, \
                dob={self.dob}, \
                sex={self.sex}, \
                nationality={self.nationality}, \
                phoneNumber={self.phoneNumber}\
                email={self.email}\
                points={self.points}\
                classificationCount={self.classificationCount}\
            )'
        )