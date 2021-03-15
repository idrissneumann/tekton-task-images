FROM python:3

COPY env-files-utils/env_files_utils.py /
COPY github-add-comment/add-comment.py /

RUN chmod +x /add-comment.py /env_files_utils.py

CMD [ "python3", "/add-comment.py" ]
