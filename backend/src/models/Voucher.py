class Voucher(object):
    def __init__(self, name, store_name, voucher_description, start_date, expiry_date):
        self.name = name
        self.store_name = store_name
        self.voucher_description = voucher_description
        self.start_date = start_date
        self.expiry_date = expiry_date

    def to_dict(self):
        return {"name": self.name, "store_name": self.store_name, "voucher_description": self.voucher_description, "start_date": self.start_date, 
        "expiry_date": self.expiry_date}
    
    def __repr__(self):
        return (
            f'User(\
                name={self.name}, \
                store_name={self.store_name}, \
                voucher_description={self.voucher_description}, \
                start_date={self.start_date}, \
                expiry_date={self.expiry_date}\
            )'
        )