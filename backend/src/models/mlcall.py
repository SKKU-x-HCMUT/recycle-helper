class Mlcall(object):
    def __init__(self, project, endpoint_id, location, filename):
        self.project = project
        self.endpoint_id = endpoint_id
        self.location = location
        self.filename = filename

    def to_dict(self):
        return {"project": self.project, "endpoint_id": self.endpoint_id, "location": self.location, "filename": self.filename}
    
    def __repr__(self):
        return (
            f'User(\
                project={self.project}, \
                endpoint_id={self.endpoint_id}, \
                location={self.location}\
                filename={self.filename}\
            )'
        )