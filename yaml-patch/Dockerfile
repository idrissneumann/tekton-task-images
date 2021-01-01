FROM python:3-alpine

COPY ./yaml-patch.py /

RUN pip install HiYaPyCo && \
    chmod +x yaml-patch.py

CMD ["/yaml-patch.py"]
