FROM python:3

COPY env-files-utils/env_files_utils.py /
COPY github-set-status/set-status.py /

RUN chmod +x /set-status.py /env_files_utils.py

CMD [ "python3", "/set-status.py" ]
