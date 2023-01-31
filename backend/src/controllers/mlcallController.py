import base64
from flask import request, session, redirect, url_for
from functools import wraps
from google.cloud import aiplatform
from google.cloud.aiplatform.gapic.schema import predict
from google.cloud import storage
from time import time 
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

    @login_required
    def predict_image_classification_sample(
        project="203585176079",
        endpoint_id="31723109484593152",
        location="us-central1",
        api_endpoint= "us-central1-aiplatform.googleapis.com",
    ):
        if 'image_file' not in request.files:
            return {"message": "Missing image file"}, 400
        
        # get image file from form's request
        image_file = request.files['image_file']
        image_file_content = image_file.stream.read()

        # The AI Platform services require regional API endpoints.
        client_options = {"api_endpoint": api_endpoint}
        # Initialize client that will be used to create and send requests.
        # This client only needs to be created once, and can be reused for multiple requests.
        client = aiplatform.gapic.PredictionServiceClient(client_options=client_options)
    
        # The format of each instance should conform to the deployed model's prediction input schema.
        encoded_content = base64.b64encode(image_file_content).decode("utf-8")
        instance = predict.instance.ImageClassificationPredictionInstance(
            content=encoded_content,
        ).to_value()
        instances = [instance]
        # See gs://google-cloud-aiplatform/schema/predict/params/image_classification_1.0.0.yaml for the format of the parameters.
        parameters = predict.params.ImageClassificationPredictionParams(
            confidence_threshold=0.5, max_predictions=1,
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
            prediction_confidence = prediction["confidences"][0]
            prediction_type = prediction["displayNames"][0]
            prediction_id = prediction["ids"][0]
            
        prediction_ret = {"id": prediction_id,"type": prediction_type, "confidence": prediction_confidence}

       
        #uploading images###########################

        # Enable Storage
        client = storage.Client()

        # Reference an existing bucket.
        bucket = client.get_bucket('skkuxhcmut-recycle-helper.appspot.com')

        # Upload a local file to a new file to be created in your bucket.
        zebraBlob = bucket.blob(f'unclassified/{session["user"]}_{prediction_type}_{int(time())}')
        image_file.seek(0)
        zebraBlob.content_type = image_file.content_type
        zebraBlob.upload_from_file(file_obj=image_file)

        return prediction_ret, 200
