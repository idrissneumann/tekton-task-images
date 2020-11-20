FROM broadinstitute/python-requests:3

COPY slack-sender.py /

RUN chmod +x /slack-sender.py

CMD [ "python3", "/slack-sender.py" ]
