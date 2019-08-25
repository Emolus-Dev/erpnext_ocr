FROM monogramm/docker-erpnext${VERSION}-${VARIANT}

# Build environment variables
ENV DOCKER_TAG=travis \
    DOCKER_VCS_REF=${TRAVIS_COMMIT} \
    DOCKER_BUILD_DATE=${TRAVIS_BUILD_NUMBER}

# Copy the whole repository to app folder
COPY . "/home/$FRAPPE_USER"/frappe-bench/apps/erpnext_ocr
# Add the docker test script
ADD docker_test.sh /.docker_test.sh

RUN set -ex; \
    sudo chmod 755 /.docker_test.sh; \
    sudo apk add --update \
        ghostscript \
        imagemagick \
        imagemagick-dev \
        tesseract-ocr \
    ; \
    sudo sed -i \
        -e 's/rights="none" pattern="PDF"/rights="read" pattern="PDF"/g' \
        /etc/ImageMagick*/policy.xml \
    ; \
    sudo mkdir -p "/home/$FRAPPE_USER"/frappe-bench/logs; \
    sudo touch "/home/$FRAPPE_USER"/frappe-bench/logs/bench.log; \
    sudo chmod 777 \
        "/home/$FRAPPE_USER"/frappe-bench/logs \
        "/home/$FRAPPE_USER"/frappe-bench/logs/* \
    ;
