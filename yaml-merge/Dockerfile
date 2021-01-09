FROM python:3-alpine

COPY ./yaml-merge.py /

RUN pip install HiYaPyCo && \
    chmod +x yaml-merge.py

CMD ["/yaml-merge.py"]
