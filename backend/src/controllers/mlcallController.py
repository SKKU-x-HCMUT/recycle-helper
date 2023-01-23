import base64
from flask import request, jsonify, session, redirect, url_for
# from src import cardboard
from src.config.firestore.db import db
from functools import wraps
from google.cloud import aiplatform
from google.cloud.aiplatform.gapic.schema import predict


aiplatform.init(
    # your Google Cloud Project ID or number
    # environment default used is not set
    project='203585176079',

    # the Vertex AI region you will use
    # defaults to us-central1
    location='us-central1',

    # Google Cloud Storage bucket in same region as location
    # used to stage artifacts
    staging_bucket='gs://newbucketskkuhcmut',

    # custom google.auth.credentials.Credentials
    # environment default creds used if not set
    credentials='my_credentials',

    # customer managed encryption key resource name
    # will be applied to all Vertex AI resources if set
    encryption_spec_key_name='my_encryption_key_name',

    # the name of the experiment to use to track
    # logged metrics and parameters
    experiment='my-experiment',

    # description of the experiment above
    experiment_description='my experiment decsription'
)


class MlcallController:
    def login_required(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            if 'user' not in session:
                # return redirect(url_for(''))      Should redirect to login page in Flutter
                return {'message': 'User must log in to perform this action'}, 403
            return f(*args, **kwargs)
        return decorated_function

    # @login_required
    def predict_image_classification_sample(
        project="203585176079",
        endpoint_id="7897400596175519744",
        location="us-central1",
        filename= "cardboard.png",
        api_endpoint= "us-central1-aiplatform.googleapis.com",
    ):
        print("In api!!")
        # The AI Platform services require regional API endpoints.
        client_options = {"api_endpoint": api_endpoint}
        # Initialize client that will be used to create and send requests.
        # This client only needs to be created once, and can be reused for multiple requests.
        client = aiplatform.gapic.PredictionServiceClient(client_options=client_options)
        with open(filename, "rb") as f:
            file_content = f.read()
            print('hehe: ',file_content)

        # The format of each instance should conform to the deployed model's prediction input schema.
        encoded_content = base64.b64encode(file_content).decode("utf-8")
        instance = predict.instance.ImageClassificationPredictionInstance(
            content=encoded_content,
        ).to_value()
        instances = [instance]
        # See gs://google-cloud-aiplatform/schema/predict/params/image_classification_1.0.0.yaml for the format of the parameters.
        parameters = predict.params.ImageClassificationPredictionParams(
            confidence_threshold=0.5, max_predictions=5,
        ).to_value()
        endpoint = client.endpoint_path(
            project=project, location=location, endpoint=endpoint_id
        )
        response = client.predict(
            endpoint=endpoint, instances=instances, parameters=parameters
        )
        print("response")
        print(" deployed_model_id:", response.deployed_model_id)
        # See gs://google-cloud-aiplatform/schema/predict/prediction/image_classification_1.0.0.yaml for the format of the predictions.
        predictions = response.predictions
        for prediction in predictions:
            print(" prediction:", dict(prediction))
