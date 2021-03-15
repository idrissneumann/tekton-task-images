FROM broadinstitute/python-requests:3

COPY env-files-utils/env_files_utils.py /
COPY slack-result-sender/slack-result-sender.py /

RUN chmod +x /slack-result-sender.py /env_files_utils.py

CMD [ "python3", "/slack-result-sender.py" ]
