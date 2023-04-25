class Voucher(object):
    def __init__(self, voucherId, name, store_name, voucher_description, start_date, expiry_date):
        self.voucherId = voucherId
        self.name = name
        self.storeName = store_name
        self.voucherDescription = voucher_description
        self.startDate = start_date
        self.expiryDate = expiry_date

    def to_dict(self):
        return {"voucherId": self.voucherId, "name": self.name, "store_name": self.storeName, "voucher_description": self.voucherDescription, "start_date": self.startDate, 
        "expiry_date": self.expiryDate}
    
    def __repr__(self):
        return (
            f'User(\
                voucherId={self.voucherId}, \
                name={self.name}, \
                store_name={self.storeName}, \
                voucher_description={self.voucherDescription}, \
                start_date={self.startDate}, \
                expiry_date={self.expiryDate}\
            )'
        )