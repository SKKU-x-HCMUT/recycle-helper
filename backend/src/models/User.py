import datetime

class User(object):
    def __init__(self, email, name, dob, sex, nationality, phone_number, point):
        self.email = email
        self.name = name
        self.dob = dob
        self.sex = sex
        self.nationality = nationality
        self.phone_number = phone_number
        self.point = point

    def to_dict(self):
        return {"name": self.name, "dob": self.dob, "sex": self.sex, "nationality": self.nationality, 
        "phone_number": self.phone_number, "email": self.email, "point": self.point}
    
    def __repr__(self):
        return (
            f'User(\
                name={self.name}, \
                dob={self.dob}, \
                sex={self.sex}, \
                nationality={self.nationality}, \
                phone_number={self.phone_number}\
                email={self.email}\
                point={self.point}\
            )'
        )