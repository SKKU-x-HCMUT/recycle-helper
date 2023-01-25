import base64, json
from flask import request, jsonify, session, redirect, url_for
# from src import cardboard
from src.config.firestore.db import db
from functools import wraps
from google.cloud import aiplatform
from google.cloud.aiplatform.gapic.schema import predict
from google.protobuf.json_format import MessageToJson
import firebase
from google.cloud import storage
from google.cloud.storage import client
import firebase_admin
from firebase_admin import credentials
from google.cloud import storage



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
        endpoint_id="6085264696112316416",
        location="us-central1",
        filename= "C:/Users/Anh Tu/Documents/recycle-helper/backend/src/glass.png",
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
        
        #uploading images###########################

        # Enable Storage
        client = storage.Client()

        # Reference an existing bucket.
        bucket = client.get_bucket('skkuxhcmut-recycle-helper.appspot.com')

        # Upload a local file to a new file to be created in your bucket.
        zebraBlob = bucket.blob('glass.png')
        zebraBlob.upload_from_filename(filename='C:/Users/Anh Tu/Documents/recycle-helper/backend/src/glass.png')

        # See gs://google-cloud-aiplatform/schema/predict/prediction/image_classification_1.0.0.yaml for the format of the predictions.
        predictions = response.predictions
        predictions_arr = {}
        i = 1
        for prediction in predictions:
            print(" prediction:", dict(prediction))
            predictions_arr[f"prediction_{i}"] = dict(prediction)
            i += 1
       
        return {"predictions": predictions_arr}, 200
