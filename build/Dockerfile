FROM python:3.7-slim-buster

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV TZ='America/Buenos_Aires'

ARG DEBIAN_FRONTEND='noninteractive'

ARG OVER='14'
ARG OREL
ENV OVER=${OVER} OREL=${OREL}

ENV APT_DEPS=' \
    build-essential \
    libcups2-dev \
    libldap2-dev \
    libpq-dev \
    libsasl2-dev \
    libssl-dev \
    python3-dev \
    python3-wheel \
    swig'

RUN set -eux; \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        ghostscript \
        git \
        gnupg \
        iputils-ping \
        node-less \
        procps \
        python3-qrcode \
        python3-renderpm \
        python3-suds \
        sudo \
        ${APT_DEPS} \
    # Create odoo user
    && groupadd -g 1100 odoo \
    && useradd -m -d /home/odoo -s /bin/bash -u 1100 -g odoo -G sudo odoo \
    && echo 'odoo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    # Install wkhtmltopdf
    && curl -o wkhtmltox.deb -L https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.buster_amd64.deb \
    && apt-get -y install --no-install-recommends ./wkhtmltox.deb \
    # Install posgresql-client-12
    && echo 'deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main' >> /etc/apt/sources.list.d/postgresql.list \
    && curl -s https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && apt-get update && apt-get install -y --no-install-recommends postgresql-client-12 \
    # Upgrade pip
    && pip install -U pip \
    # Install dependencies
    && pip install wdb \
    && pip install debugpy \
    && pip install inotify \
    && echo 'fs.inotify.max_user_watches=52428' >> /etc/sysctl.conf \
    # Create required odoo folders
    && mkdir -p \
        /home/odoo/datadir \
        /home/odoo/project \
        /home/odoo/private \
        /home/odoo/public \
        /home/odoo/extra \
    && chown -R odoo:odoo /home/odoo \
    ###############################
    # Get odoo sources from Github
    ###############################
#    && git clone -b ${OVER}.0 --depth 1 https://github.com/odoo/odoo.git /home/odoo/src \
    && git clone -b ${OVER}.0-numa --depth 1 https://github.com/numaes/numa-public-odoo.git /home/odoo/src \
    # Remove unnecessary translations (removes ~400 MB from image!)
    && find /home/odoo/src/addons/*/i18n/ /home/odoo/src/odoo/addons/base/i18n/ -type f -not -name 'es.po' -not -name 'es_AR.po' -delete \
    # Remove unnecessary localization folders (removes ~58 MB from image)
    && find /home/odoo/src/addons/l10n_* -maxdepth 0 -type d -not -name 'l10n_ar' -not -name 'l10n_latam_base' -not -name 'l10n_latam_invoice_document' -exec rm -r {} + \
    # Prevent installation of unnecessary autoinstallable modules
    && sed -i "s/.*auto_install.*/'auto_install': False,/g" /home/odoo/src/addons/mail_bot/__manifest__.py \
    && sed -i "s/.*auto_install.*/'auto_install': False,/g" /home/odoo/src/addons/odoo_referral/__manifest__.py \
    && sed -i "s/.*auto_install.*/'auto_install': False,/g" /home/odoo/src/addons/partner_autocomplete/__manifest__.py \
    && sed -i "s/.*auto_install.*/'auto_install': False,/g" /home/odoo/src/addons/sms/__manifest__.py \
    && sed -i "s/.*auto_install.*/'auto_install': False,/g" /home/odoo/src/addons/snailmail/__manifest__.py \
    && sed -i "s/.*auto_install.*/'auto_install': False,/g" /home/odoo/src/addons/web_unsplash/__manifest__.py \
    && pip install -r /home/odoo/src/requirements.txt \
    # Upgrade jinja2 to avoid warnings
    && pip install -U jinja2 \
    # Upgrade psycopg2-binary to avoid warnings
    && pip install psycopg2-binary \
    # Install other dependencies
    && pip install elaphe3 \
    && pip install httplib2 \
    && pip install lxml~=4.3.2 \
    && pip install M2Crypto \
    && pip install num2words \
    && pip install phonenumbers \
    && pip install pycups \
    && pip install pyOpenSSL \
    && pip install python-dateutil \
    && pip install rarfile \
    && pip install requests~=2.21.0 \
    && pip install xlrd \
    # Install other localization dependencies
    # && pip install git+https://github.com/pysimplesoap/pysimplesoap@stable_py3k \
    # && pip install git+https://github.com/reingart/pyafipws@py3k \
#!!!# workaround for: Permission denied: '/usr/local/lib/python3.7/site-packages/pyafipws/cache' 
    # && mkdir -p /usr/local/lib/python3.7/site-packages/pyafipws/cache \
    # && chmod 777 -R /usr/local/lib/python3.7/site-packages/pyafipws \
#!!!# workaround for soap error: 'SSL: DH_KEY_TOO_SMALL'
    && sed -i "s/CipherString = DEFAULT@SECLEVEL=2/#CipherString = DEFAULT@SECLEVEL=2/g" /etc/ssl/openssl.cnf \
    # Remove build packages
    && apt-get remove -y git \
    && apt-get remove -y curl gnupg \
    && apt-get remove -y ${APT_DEPS} \
    && apt-get autoremove -y \
    # Removes .git history
    && rm -rf /home/odoo/src/.git \
    # Removes unnecessary build temporary files including pip cache
    && rm -rf /var/lib/apt/lists/* /wkhtmltox.deb ~/.cache/pip

COPY ./entrypoint.sh /home/odoo/entrypoint.sh
COPY ./odoo.conf /home/odoo/.odoorc

EXPOSE 8069 8072

WORKDIR /home/odoo
USER odoo

ENTRYPOINT ["./entrypoint.sh"]
CMD ["./src/odoo-bin"]
