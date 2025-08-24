FROM rocker/r2u:22.04

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    git \
    r-cran-remotes \
    && rm -rf /var/lib/apt/lists/*

# Copy your package into the container
WORKDIR /app
COPY . /app

# Install the package from local source
RUN R -e "remotes::install_local('/app')"

# Run the email function automatically on container start
CMD ["Rscript", "/app/run_email_listings.R"]
