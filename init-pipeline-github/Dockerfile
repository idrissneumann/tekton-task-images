FROM broadinstitute/python-requests:3

COPY init-pipeline-github/init-pipeline.sh /
COPY github-search-pr/search.sh /
COPY github-set-status/set-status.py /
COPY github-add-comment/add-comment.py /
COPY git-fetch-sources/fetch-sources.sh /
COPY slack-sender/slack-sender.py /

CMD ["/bin/sh", "-c", "/init-pipeline.sh"]