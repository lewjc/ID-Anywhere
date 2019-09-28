from flask import Flask
import BusinessLogic.verifyBL as verify_logic

app = Flask(__name__)


@app.route('api/verify', methods=[POST])
def verify():
    if(request.method == 'POST'):
        # TODO: decide how to post the image byte strings (form or json
        # payload)
        verify_logic.verify(None, None, None)
    return 'Verify Face Endpoint'
