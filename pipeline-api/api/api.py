from flask import Flask, request
from flask_restful import Resource, Api

from subprocess import check_output
from multiprocessing import Process
import os
import json
import sys

app = Flask(__name__)
api = Api(app)

def get_script_output (cmd):
    print("[get_script_output] cmd = {}".format(cmd))
    try:
        return check_output(cmd, shell=True, text=True)
    except:
        return check_output(cmd, shell=True, universal_newlines=True)

def is_not_empty (var):
    return var is not None and "" != var and "null" != var and "nil" != var

def is_empty (var):
    return not is_not_empty(var)

def is_empty_request_field (name):
    body = request.get_json(force=True)
    return not name in body or is_empty(body[name])

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

def check_mandatory_param(name):
    if is_empty_request_field(name):
        eprint("[check_mandatory_param] bad request : missing argument = {}, body = {}".format(name, request.data))
        return {
            "status": "bad_request",
            "reason": "missing {} argument".format(name)
        }
    else:
        return {
            "status": "ok"
        }

def is_not_ok(body):
    return not "status" in body or body["status"] != "ok"

def run_cmd (cmd):
    print("[run_cmd] output = {}".format(get_script_output(cmd)))

def run_pipeline():
    body = request.get_json(force=True)
    if is_empty_request_field('log_level'):
        log_level = "info"
    else:
        log_level = body['log_level']
    run_cmd("/run_pipeline.sh {} {} {}".format(body['pipeline_name'], body['git_branch'], log_level))

class PipelineEndPoint(Resource):
    def get(self):
        return {
            'status': 'ok',
            'available_pipelines': json.loads(get_script_output("/list.sh"))
        }
    def post(self):
        c = check_mandatory_param('pipeline_name')
        if is_not_ok(c):
            return c, 400

        c = check_mandatory_param('git_branch')
        if is_not_ok(c):
            return c, 400

        async_process = Process( 
            target=run_pipeline,
            daemon=True
        )
        async_process.start()
        return {
            'status': 'ok',
            'async': True
        }

class RootEndPoint(Resource):
    def get(self):
        return {
            'alive': True
        }

class ManifestEndPoint(Resource):
    def get(self):
        try:
            with open("/manifest.json") as manifest_file:
                manifest = json.load(manifest_file)
                return manifest
        except IOError as err:
            return {"error": err}

health_check_routes = ['/', '/health', '/health/']
pipeline_routes = ['/pipeline', '/pipeline/']
manifest_routes = ['/manifest', '/manifest/']

api.add_resource(RootEndPoint, *health_check_routes)
api.add_resource(PipelineEndPoint, *pipeline_routes)
api.add_resource(ManifestEndPoint, *manifest_routes)

if __name__ == '__main__':
    app.run()
